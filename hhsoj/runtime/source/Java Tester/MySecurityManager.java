
import java.io.FilePermission;
import java.lang.reflect.ReflectPermission;
import java.net.NetPermission;
import java.net.SocketPermission;
import java.security.Permission;
import java.security.SecurityPermission;
import java.util.PropertyPermission;

/**
 * 重写安全管理器
 * @author lvbiao
 *
 */
public class MySecurityManager extends SecurityManager{
	  
	    /** 
	     * 重写强行退出检测 
	     * 防止用户自行终止虚拟机的运行,但是调用程序端可以执行退出 
	     * */  
	    public void checkExit(int status) {  
	         throw new SecurityException("Exit On Client Is Not Allowed!");  
	    } 
	    
	    /** 
	     *  策略权限查看 
	     * 当执行操作时调用,如果操作允许则返回,操作不允许抛出SecurityException 
	     * */  
	    private void sandboxCheck(Permission perm) throws SecurityException {  
	        // 设置只读属性  
	        if (perm instanceof SecurityPermission) { 
	        	//安全性
	            if (perm.getName().startsWith("getProperty")) {  
	                return;  
	            }  
	        } else if (perm instanceof PropertyPermission) {  
	        	//属性
	            if (perm.getActions().equals("read")) {  
	                return;  
	            } else{
	            	throw new SecurityException(perm.toString()); 
	            }
	        } else if (perm instanceof FilePermission) {  
	        	//文件操作
	            if (perm.getActions().equals("read")) {  
	                return;  
	            }else{
	            	if(perm.getName().equals("data.txt") || perm.getName().equals("out.txt")){
	            		return;
	            	}
	            	throw new SecurityException(perm.toString()); 
	            }
	        } else if (perm instanceof ReflectPermission){  
	        	//反射
	           return;  
	        }else if(perm instanceof RuntimePermission){
	        	//运行时安全
	        	return;
	        }
	        else if(perm instanceof SocketPermission){
	        	//Socket权限
	        	if (perm.getActions().equals("accept") || 
	        			perm.getActions().equals("connect") ||
	        			perm.getActions().equals("listen") ||
	        			perm.getActions().equals("resolve")
	        			) {  
	        		return;  
	        	} 
	        }else if(perm instanceof NetPermission){
	        	//网络
	        	if(perm.implies(new NetPermission("specifyStreamHandler"))){
	        		//在构造 URL 时指定流处理程序的能力
	        		return;
	        	}else{
	        		throw new SecurityException(perm.toString());  
	        	}
	        }else{
	        	throw new SecurityException(perm.toString());  
	        }
	    }  
	    @Override  
	    public void checkPermission(Permission perm) {  
	        this.sandboxCheck(perm);  
	    }  
	  
	    @Override  
	    public void checkPermission(Permission perm, Object context) {  
	        this.sandboxCheck(perm);  
	    }
}