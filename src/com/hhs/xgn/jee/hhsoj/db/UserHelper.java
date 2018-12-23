package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.Users;

/**
 * Helper for Users. It's a javabean
 * @author XGN
 *
 */
public class UserHelper {
	
    
	public synchronized ArrayList<Users> init(){
		//Init
		ArrayList<Users> arr=new ArrayList<Users>();
		
		new File(ConfigLoader.getPath()).mkdirs();
		
		File f=new File(ConfigLoader.getPath()+"/users");
		
		if(!f.exists()){
			f.mkdirs();
		}
		
		for(File ff:f.listFiles()){
			try{
				
				
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(ff)));
				String json=br.readLine();
				
				br.close();
				
				Users u=new Gson().fromJson(json, Users.class);
				
				if(u==null){
					throw new Exception("File returned an null");
				}
				arr.add(u);
			}catch(Exception e){
				e.printStackTrace();
				
			}
		}
		
		return arr;
		
	}
	
	/**
	 * Get all users' information from the file system
	 * @return the users
	 */
	public synchronized ArrayList<Users> getAllUsers(){
		
		return init();
		
	}
	
	public synchronized int getSize(){
		File f=new File(ConfigLoader.getPath()+"/users");
		return f.list().length;
	}
	
	public synchronized Users getUserInfo(String username){
		ArrayList<Users> arr=init();
		for(Users s:arr){
			if(s.getUsername().equals(username)){
				return s;
			}
		}
		
		return null;
	}
	
	public synchronized void addUser(Users u){
		
		
		int sz=getSize();
		
		String path=ConfigLoader.getPath()+"/users";
		
		if(new File(ConfigLoader.getPath()+"/users").exists()==false){
			new File(ConfigLoader.getPath()+"/users").mkdirs();
		}
		
		try{
			
			u.setId(sz);
			PrintWriter pw=new PrintWriter(path+"/"+sz);
			pw.println(u.toJson());
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	public synchronized void deleteUser(String username){
		ArrayList<Users> a=getAllUsers();
		for(Users u:a){
			if(u.getUsername().equals(username)){
				new File(ConfigLoader.getPath()+"/users/"+u.getId()).delete();
				return;
			}
		}
	}
	
	/**
	 * Change the status of the Users according to the id
	 * @param u
	 */
	public synchronized void refreshUser(Users u){
		try{
			PrintWriter pw=new PrintWriter(ConfigLoader.getPath()+"/users/"+u.getId());
			pw.println(u.toJson());
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
