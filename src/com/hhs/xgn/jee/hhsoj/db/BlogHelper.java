package com.hhs.xgn.jee.hhsoj.db;

import java.io.File;
import java.io.PrintWriter;

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
		
		try{
			PrintWriter pw=new PrintWriter(new File("hhsoj/blog/"+id));
			pw.println(gs.toJson(b));
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public int getBlogCount(){
		File f=new File("hhsoj/blog");
		if(!f.exists()){
			f.mkdirs();
		}
		
		return f.list().length;
	}
}
