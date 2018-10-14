package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

/**
 * Windows Helper
 * Get windows password and username
 * @author XGN
 *
 */
public class WindowsHelper {
	/**
	 * Returns the user
	 * @return
	 */
	public String getUser(){
		
		try{
			File con=new File("hhsoj/user.txt");
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
	public String getPsd(){
		
		try{
			File con=new File("hhsoj/psd.txt");
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
