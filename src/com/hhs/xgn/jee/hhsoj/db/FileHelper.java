package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.lang.ProcessBuilder.Redirect;

import com.hhs.xgn.jee.hhsoj.type.Config;

public class FileHelper {
	public static String readFileFull(String path){
		try{
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(path), "utf-8"));
			String l="",r="";
			while((r=br.readLine())!=null){
				l+=r+"\n";
			}
			br.close();
			return l;
		}catch(Exception e){
			return null;
		}
	}
	
	/**
	 * First write then compile
	 */
	public static String compileFile(String path,String value){
		try{
			String ret=writeFile(path,value);
			if(!ret.equals("Success")){
				return "Failed to write file";
			}
			
			Config con=new ConfigLoader().load();	
			ProcessBuilder pb = new ProcessBuilder(new String[] { "g++",path,"-DONLINE_JUDGE", (con.isEnableCPP11()?"-std=c++11":"-DNOCPP"), "-O2"});

			File err=new File(path+".compileerrorfile.tmp");
			pb.redirectError(err);
			
			Process p = pb.start();

			long tme = System.currentTimeMillis();

			boolean killed = true;
			while (p.isAlive()) {
				if (System.currentTimeMillis() - tme >= con.getWaitTimeout() * 1000) {
					killed = false;
					break;
				}
			}
		
			String content="(None)";
			if(err.exists()){
				content=readFileFull(path+".compileerrorfile.tmp");
				err.delete();
			}
			
			if(killed){
				if(p.exitValue()==0){
					return "Success:"+content;
				}else{
					return "CE:\n"+content;
				}
			}else{
				return "Failed: Compile Timeout";
			}
		}catch(Exception e){
			return "Failed:"+e+"";
		}
	}
	public static String writeFile(String path,String value){
		try{
			PrintWriter pw=new PrintWriter(path,"utf-8");
			pw.print(value);
			pw.close();
			return "Success";
		}catch(Exception e){
			return "Failed:"+e+"";
		}
	}
}
