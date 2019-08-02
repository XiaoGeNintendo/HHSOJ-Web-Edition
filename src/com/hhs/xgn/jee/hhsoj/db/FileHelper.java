package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

public class FileHelper {
	public static String readFileFull(String path){
		try{
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(path), "utf-8"));
			String l="",r="";
			while((r=br.readLine())!=null){
				l+=r+"\n";
			}
			br.close();
			return l;
		}catch(Exception e){
			return null;
		}
	}
	
	public static String writeFile(String path,String value){
		try{
			PrintWriter pw=new PrintWriter(path);
			pw.print(value);
			pw.close();
			return "Success";
		}catch(Exception e){
			return e+"";
		}
	}
}
