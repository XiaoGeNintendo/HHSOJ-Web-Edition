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
	
    
	public ArrayList<Users> init(){
		//Init
		ArrayList<Users> arr=new ArrayList<Users>();
		
		new File("hhsoj").mkdirs();
		
		File f=new File("hhsoj/users");
		
		if(!f.exists()){
			f.mkdirs();
		}
		
		for(File ff:f.listFiles()){
			try{
				
				
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(ff)));
				String json=br.readLine();
				
				br.close();
				
				Users u=new Gson().fromJson(json, Users.class);
				
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
	public ArrayList<Users> getAllUsers(){
		
		return init();
		
	}
	
	public int getSize(){
		File f=new File("hhsoj/users");
		return f.list().length;
	}
	
	public Users getUserInfo(String username){
		ArrayList<Users> arr=init();
		for(Users s:arr){
			if(s.getUsername().equals(username)){
				return s;
			}
		}
		
		return null;
	}
	
	public void addUser(Users u){
		
		
		int sz=getSize();
		
		String path="hhsoj/users";
		
		if(new File("hhsoj/users").exists()==false){
			new File("hhsoj/users").mkdirs();
		}
		
		try{
			
			
			PrintWriter pw=new PrintWriter(path+"/"+sz);
			pw.println(u.toJson());
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	public void deleteUser(String username){
		ArrayList<Users> a=getAllUsers();
		for(Users u:a){
			if(u.getUsername().equals(username)){
				new File("hhsoj/users/"+u.getId()).delete();
				return;
			}
		}
	}
}
