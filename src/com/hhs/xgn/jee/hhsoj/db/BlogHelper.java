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
	public void writeBlog(String title,String blog,String user){
		Blog b=new Blog(title,blog,user);
		Gson gs=new Gson();
		int id=getBlogCount()+1;
		b.setId(id);
		b.setTime(System.currentTimeMillis());
		
		try{
			PrintWriter pw=new PrintWriter(new File("hhsoj/blog/"+id));
			pw.println(gs.toJson(b));
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public Blog getBlogDataByID(String id){
		int id2=Integer.parseInt(id);
		
		ArrayList<Blog> arr=getAllBlogs();
		for(Blog zjs:arr){
			if(zjs.getId()==id2){
				return zjs;
			}
		}
		
		return null;
	}
	
	public ArrayList<Blog> getAllBlogs(){
		File f=new File("hhsoj/blog");
		ArrayList<Blog> arr=new ArrayList<Blog>();
		
		for(File bl:f.listFiles()){
			
			try{
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(bl)));
				arr.add(new Gson().fromJson(br.readLine(), Blog.class));
				br.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return arr;
	}
	
	public int getBlogCount(){
		File f=new File("hhsoj/blog");
		if(!f.exists()){
			f.mkdirs();
		}
		
		return f.list().length;
	}
}
