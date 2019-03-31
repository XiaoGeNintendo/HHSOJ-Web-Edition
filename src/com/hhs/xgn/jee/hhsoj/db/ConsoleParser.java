package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;


/**
 * Class to parse the console command
 * @author XGN
 *
 */
public class ConsoleParser {
	
	static class Return{
		String position;
		String response;
		String stream;
		public Return(String position, String response, String stream) {
			this.position = position;
			this.response = response;
			this.stream = stream;
		}
		
	}
	
	public static String toJson(String position,String response,String stream){
		return new Gson().toJson(new Return(position,response,stream));
	}
	
	public static String parse(HttpSession session,HttpServletRequest request){
		try{
			
//			System.out.println(request.getParameterMap().entrySet());
			String position=request.getParameter("position");
			String command=request.getParameter("command");
			String stream=request.getParameter("stream");
			
			String[] str=command.split(" ");
			String cmd=str[0].toLowerCase();
			
			if(cmd.equals("cd")){
				
				if(str.length==1){
					return toJson(position,"Error 112:Grammar Error",stream);
				}
				String large="";
				for(int i=1;i<str.length;i++){
					large+=str[i]+" ";
				}
				large=large.trim();
				
				File f;
				if(large.equals("..")){
					if(!position.substring(0,position.length()-1).contains("/")){
						return toJson(position,"Error 113:Can't go back!",stream);
					}
					String nw=position.substring(0,position.substring(0,position.length()-1).lastIndexOf('/'));
					f=new File(nw);
					
					if(!f.exists() || f.isFile()){
						return toJson(position,"Error 112:Folder doesn't exist.",stream);
					}
					
					return toJson(nw+"/","OK:Changed position",stream);
				}else{
					f=new File(position+large);
					
					if(!f.exists() || f.isFile()){
						return toJson(position,"Error 111:Folder doesn't exist.",stream);
					}
					
					return toJson(position+large+"/","OK:Changed position",stream);
				}
			}

			if(cmd.equals("list")){
				File f=new File(position);
				String response="";
				for(File sub:f.listFiles()){
					response+=sub.getName()+" isDir="+sub.isDirectory()+"\n";
				}
				
				return toJson(position,response,stream);
			}
			
			if(cmd.equals("copy")){
				if(str.length==1){
					return toJson(position,"Error 312:Grammar Error",stream);
				}
				String large="";
				for(int i=1;i<str.length;i++){
					large+=str[i]+" ";
				}
				large=large.trim();
				
				
				File f=new File(position+large);
				if(!f.exists() || f.isDirectory()){
					return toJson(position,"Error 311:File doesn't exist",stream);
				}
				
				String file=readFrom(f);
				
				return toJson(position,"OK.Total "+file.length()+" bytes.",file);
			}
			
			if(cmd.equals("write")){
				try{
					if(str.length==1){
						return toJson(position,"Error 412:Grammar Error",stream);
					}
					String large="";
					for(int i=1;i<str.length;i++){
						large+=str[i]+" ";
					}
					large=large.trim();
					
					File f=new File(position+large);
					PrintWriter pw=new PrintWriter(f, "utf-8");
					pw.println(stream);
					pw.close();
					
					return toJson(position, "OK: write "+stream.length()+" bytes", "");
				}catch(Exception e){
					return toJson(position,"Error 411:IO Exception "+e,stream);
				}
			}
			
			if(cmd.equals("mkdir")){
				if(str.length==1){
					return toJson(position,"Error 512:Grammar Error",stream);
				}
				String large="";
				for(int i=1;i<str.length;i++){
					large+=str[i]+" ";
				}
				large=large.trim();
				
				File f=new File(position+large);
				if(f.exists()){
					return toJson(position,"Error 511:Folder already exists",stream);
				}
				boolean x=f.mkdirs();
				if(!x){
					return toJson(position,"Error 513:Failed to create new dir",stream);
				}
				return toJson(position,"OK. New folder is created",stream);
			}
			
			if(cmd.equals("del")){
				if(str.length==1){
					return toJson(position,"Error 512:Grammar Error",stream);
				}
				String large="";
				for(int i=1;i<str.length;i++){
					large+=str[i]+" ";
				}
				large=large.trim();
				
				File f=new File(position+large);
				if(!f.exists()){
					return toJson(position,"File/Folder doesn't exist",stream);
				}
				
				delete(f);
				return toJson(position,"OK. It is deleted",stream);
			}
			
			return toJson(position,"Error 001:Unknown command "+cmd,stream);
		}catch(Exception e){
			e.printStackTrace();
			return toJson(ConfigLoader.getPath(),"FATAL ERROR:"+e,"");
		}
	
	}

	private static void delete(File f){
		if(f.isDirectory()){
			for(File f2:f.listFiles()){
				delete(f2);
			}
			f.delete();
		}else{
			f.delete();
		}
	}
	
	private static String readFrom(File f) {
		try{
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(f), "utf-8"));
			String lines="",line;
			while((line=br.readLine())!=null){
				lines+=line+"\n";
			}
			br.close();
			return lines;
			
		}catch(Exception e){
			return e+"";
		}

	}
}
