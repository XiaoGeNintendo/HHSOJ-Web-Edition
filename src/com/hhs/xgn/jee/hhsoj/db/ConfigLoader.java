package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.Config;

/**
 * Read configures of judging
 * @author XGN
 *
 */
public class ConfigLoader {
	
	public Config load(){
		
		try{
			File f=new File("hhsoj/config.json");
			if(!f.exists()){
				f.createNewFile();
			}
			
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f)));
			String s, ans = "";
			while ((s = br.readLine()) != null) {
				ans += s + "\n";
			}
	
			br.close();
			
			return new Gson().fromJson(ans,Config.class);
		}catch(Exception e){
			return null;
		}
		
		
	}
}
