package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

/**
 * Read announcement
 * @author XGN
 */
public class AnnouncementReader {

	public synchronized String readAnnouncement(){
		try{
			File f=new File(ConfigLoader.getPath()+"/announcement.txt");
			if(!f.exists()){
				f.createNewFile();
			}
			
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(f),"utf-8"));
			String anno=br.readLine();
			br.close();
			return anno;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
		
	}
}
