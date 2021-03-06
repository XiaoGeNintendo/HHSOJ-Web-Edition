package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.Config;

/**
 * Read configures of judging
 * @author XGN
 *
 */
public class ConfigLoader {
	
	static String RootPath=null;
	
	public static boolean isLinux(){
//		return true;
		return System.getProperty("os.name").toLowerCase().contains("linux");
	}
	
	/**
	 * Without the last slash('/')
	 * @return
	 */
	public static String getPath() {
		if(RootPath==null) {
			if(System.getProperty("os.name").toLowerCase().indexOf("win")>=0){
				//Windows
				javax.swing.filechooser.FileSystemView fsv = javax.swing.filechooser.FileSystemView.getFileSystemView(); 
				RootPath=fsv.getHomeDirectory().getAbsolutePath();
				RootPath+="\\hhsoj";
			}
			else if(System.getProperty("os.name").toLowerCase().indexOf("linux")>=0) {
				//Linux
				RootPath="/usr/hhsoj";
			}
			else {
				RootPath="hhsoj";
			}
//			System.out.println("HHSOJ root folder=\""+RootPath+"\"");
		}
		return RootPath;
	}
	
	public Config load(){
		
		try{
			File f=new File(ConfigLoader.getPath()+"/config.json");
			if(!f.exists()){
				f.createNewFile();
			}
			
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f)));
			String s, ans = "";
			while ((s = br.readLine()) != null) {
				ans += s + "\n";
			}
	
			br.close();
			
			return new Gson().fromJson(ans,Config.class);
		}catch(Exception e){
			return null;
		}
		
		
	}
}
