package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.Blog;

/**
 * Help to write blogs
 * @author XGN
 *
 */
public class BlogHelper {
	public synchronized void writeBlog(String title,String blog,String user){
		Blog b=new Blog(title,blog,user);
		Gson gs=new Gson();
		int id=getBlogCount()+1;
		b.setId(id);
		b.setTime(System.currentTimeMillis());
		
		
		try{
			PrintWriter pw=new PrintWriter(new File(ConfigLoader.getPath()+"/blog/"+id),"utf-8");
			pw.println(gs.toJson(b));
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public synchronized void refreshBlog(Blog b){
		try{
			PrintWriter pw=new PrintWriter(ConfigLoader.getPath()+"/blog/"+b.getId(),"utf-8");
			pw.println(new Gson().toJson(b));
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public synchronized Blog getBlogDataByID(int id){
		return getBlogDataByID(id+"");
	}
	
	public synchronized Blog getBlogDataByID(String id){
		int id2=Integer.parseInt(id);
		
		ArrayList<Blog> arr=getAllBlogs();
		for(Blog zjs:arr){
			if(zjs.getId()==id2){
				return zjs;
			}
		}
		
		return null;
	}
	
	public synchronized ArrayList<Blog> getAllBlogs(){
		File f=new File(ConfigLoader.getPath()+"/blog");
		ArrayList<Blog> arr=new ArrayList<Blog>();
		
		for(File bl:f.listFiles()){
			
			try{
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(bl),"utf-8"));
				
				Blog b=new Gson().fromJson(br.readLine(), Blog.class);
				if(b==null){
					br.close();
					throw new Exception("File returned an null");
				}
				arr.add(b);
				
				br.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return arr;
	}
	
	public synchronized int getBlogCount(){
		File f=new File(ConfigLoader.getPath()+"/blog");
		if(!f.exists()){
			f.mkdirs();
		}
		
		return f.list().length;
	}
}
