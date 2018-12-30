package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

/**
 * Windows Helper
 * Get windows password and username
 * @author XGN
 * @deprecated
 */
public class WindowsHelper {
	/**
	 * Returns the user
	 * @return
	 */
	public synchronized String getUser(){
		
		try{
			File con=new File(ConfigLoader.getPath()+"/user.txt");
			if(con.exists()==false){
				con.createNewFile();
			}
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(con)));
			String s=br.readLine();
			br.close();
			return s;
		}catch(Exception e){
			return "";
		}
	}
	
	/**
	 * Returns the password
	 * @return
	 */
	public synchronized String getPsd(){
		
		try{
			File con=new File(ConfigLoader.getPath()+"/psd.txt");
			if(con.exists()==false){
				con.createNewFile();
			}
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(con)));
			String s=br.readLine();
			br.close();
			return s;
		}catch(Exception e){
			return "";
		}
	}
}
