import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import com.google.gson.Gson;

/**
 * Used to test java program
 * @author XGN	
 *
 */
public class JavaTester {
	
	public int tl=0,ml=0;
	public String file;
	public String result="";
	public Thread thread=null;
	
	/**
	 * args[0] -- time limit
	 * args[1] -- memory limit
	 * args[2] -- Orginal File path
	 * Class file path: Program.class
	 * Input file path: in.txt
	 * Output file path: out.txt 
	 * Data file path: data.txt
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception{
		new JavaTester().solve(args);	
	}
	
	public void solve(String[] args) throws Exception{
		
		
		try{
			if(args.length!=3){
				throw new IllegalArgumentException("Argument Error");
			}
			
			tl=Integer.parseInt(args[0]);
			ml=Integer.parseInt(args[1]);
			file=args[2];
			
			JavaClassLoader jcl=new JavaClassLoader();
			Class<?> cla=jcl.loadClass(getClassFile("Program.class"), "Program");
			Method mainMethod=cla.getMethod("main", String[].class);
			mainMethod.setAccessible(true);
			
			System.setIn(new FileInputStream("in.txt"));
			SecurityManager security=null;
			
			try{
				security=System.getSecurityManager();
				if(security==null){
					System.setSecurityManager(new MySecurityManager());
				}
				
				process(mainMethod);
				
				
			}catch(Exception e){
				System.setSecurityManager(null);
				TestResult tr=new TestResult("Judgement Failed",0,0,file,e+"");
				write(tr);
			}finally{
				
				System.setSecurityManager(null);
				
			}
			
		}catch(IllegalArgumentException e){
			TestResult tr=new TestResult("Judgement Failed", 0, 0, "DISABLE", "Java tester argument error");
			write(tr);
		}
	}
	
	private TestResult process(Method mainMethod) throws Exception {
		FutureTask<TestResult> task=null;
		try{
			task=new FutureTask<TestResult>(new Callable<TestResult>() {

				@Override
				public TestResult call() throws Exception {
					long startTime=0;
					int startMem=0;
					MemoryMXBean mmb=ManagementFactory.getMemoryMXBean();
					System.setOut(new PrintStream("out.txt"));
					
					try{
						System.gc();
						startTime=System.currentTimeMillis();
						startMem=(int)mmb.getHeapMemoryUsage().getUsed();
						
						mainMethod.invoke(null, new Object[]{new String[0]});
						
						
					}catch(InvocationTargetException e){
						
						System.setSecurityManager(null);
						
						Throwable targetException=e.getTargetException();
						if(targetException instanceof OutOfMemoryError){
							//mle :)
							TestResult tr=new TestResult("Memory Limit Exceeded",0,ml,file,"VM Exploded :(");
							write(tr);
							return tr;
							
						}else if(targetException instanceof SecurityException || targetException instanceof ExceptionInInitializerError){
							//Small ass hacker :)
							TestResult tr=new TestResult("Restrict Function",0,0,file,targetException+"");
							write(tr);
							return tr;
						}else{
							//RE :(
							TestResult tr=new TestResult("Runtime Error",0,0,file,targetException+"");
							write(tr);
							return tr;
						}
					}
					
					int usedMemory=(int)(mmb.getHeapMemoryUsage().getUsed()-startMem);
					long usedTime=System.currentTimeMillis()-startTime;
					
					int usedMemKB=switchMemory(usedMemory);
					
					TestResult tr=new TestResult("Accepted", (int)usedTime, usedMemKB, file, "");
					write(tr);
					
					return tr;
				}
			});
		}catch(Exception e){
			
			TestResult tr=new TestResult("Judgement Failed", 0, 0, file, e+"");
			write(tr);
		}
		
		thread=new Thread(task);
		thread.start();
		TestResult tr=null;
		try{
			tr=task.get(tl+50, TimeUnit.MILLISECONDS);
		}catch(TimeoutException e){
			tr=new TestResult("Time Limit Exceeded", tl, 0, file, e+"");
			task.cancel(true);
			return tr;
		}
		
		return tr;
	}

	private int switchMemory(int usedMemory) {
		float tem = (float) usedMemory / 1024.0f;
		return (int)tem;
	}
	
	private void write(TestResult tr) throws Exception{
		Gson gs=new Gson();
		PrintWriter pw=new PrintWriter("data.txt");
		pw.println(gs.toJson(tr));
		pw.close();
	}
	/**
	 * Get class file in byte
	 * @param file
	 * @return
	 * @throws Exception 
	 */
	public byte[] getClassFile(String path){
		File classFile = new File(path);
		if(classFile.length()>=40*1024){
			throw new RuntimeException("Class file too big");
		}
		
		byte[] mainClass = new byte[(int) classFile.length()];
		try {
			FileInputStream in = new FileInputStream(classFile);
			in.read(mainClass);
			in.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return mainClass;
	}
}
