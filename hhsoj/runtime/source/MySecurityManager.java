
import java.io.FilePermission;
import java.lang.reflect.ReflectPermission;
import java.net.NetPermission;
import java.net.SocketPermission;
import java.security.Permission;
import java.security.SecurityPermission;
import java.util.PropertyPermission;

/**
 * ��д��ȫ������
 * @author lvbiao
 *
 */
public class MySecurityManager extends SecurityManager{
	  
	    /** 
	     * ��дǿ���˳���� 
	     * ��ֹ�û�������ֹ�����������,���ǵ��ó���˿���ִ���˳� 
	     * */  
	    public void checkExit(int status) {  
	         throw new SecurityException("Exit On Client Is Not Allowed!");  
	    } 
	    
	    /** 
	     *  ����Ȩ�޲鿴 
	     * ��ִ�в���ʱ����,������������򷵻�,�����������׳�SecurityException 
	     * */  
	    private void sandboxCheck(Permission perm) throws SecurityException {  
	        // ����ֻ������  
	        if (perm instanceof SecurityPermission) { 
	        	//��ȫ��
	            if (perm.getName().startsWith("getProperty")) {  
	                return;  
	            }  
	        } else if (perm instanceof PropertyPermission) {  
	        	//����
	            if (perm.getActions().equals("read")) {  
	                return;  
	            } else{
	            	throw new SecurityException(perm.toString()); 
	            }
	        } else if (perm instanceof FilePermission) {  
	        	//�ļ�����
	            if (perm.getActions().equals("read")) {  
	                return;  
	            }else{
	            	if(perm.getName().equals("data.txt") || perm.getName().equals("out.txt")){
	            		return;
	            	}
	            	throw new SecurityException(perm.toString()); 
	            }
	        } else if (perm instanceof ReflectPermission){  
	        	//����
	           return;  
	        }else if(perm instanceof RuntimePermission){
	        	//����ʱ��ȫ
	        	return;
	        }
	        else if(perm instanceof SocketPermission){
	        	//SocketȨ��
	        	if (perm.getActions().equals("accept") || 
	        			perm.getActions().equals("connect") ||
	        			perm.getActions().equals("listen") ||
	        			perm.getActions().equals("resolve")
	        			) {  
	        		return;  
	        	} 
	        }else if(perm instanceof NetPermission){
	        	//����
	        	if(perm.implies(new NetPermission("specifyStreamHandler"))){
	        		//�ڹ��� URL ʱָ����������������
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