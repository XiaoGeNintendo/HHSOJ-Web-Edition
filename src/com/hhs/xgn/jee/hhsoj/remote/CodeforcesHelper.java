package com.hhs.xgn.jee.hhsoj.remote;

import java.util.List;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.type.Config;

/**
 * A util class for getting Codeforces API
 * 
 * @author XGN
 *
 */
public class CodeforcesHelper {
	
	/**
	 * The last query time.
	 */
	public static long lastQuery;
	/**
	 * The last query result
	 */
	public static List<CodeforcesProblem> problems=new ArrayList<>();
	
	
	/**
	 * Get the Codeforces Problems according to the API
	 * @return
	 */
	public static List<CodeforcesProblem> getCodeforcesProblems(){
		Config c=new ConfigLoader().load();
		if(c.isEnableRemoteJudge()){
			//OK. Now check time
			long now=System.currentTimeMillis();
			long delta=c.getQueryTime();
			long expectedLastTime=now-delta;
			if(lastQuery<expectedLastTime){
				//Out-of-date data. Will update
				updateCFProblems();
				lastQuery=System.currentTimeMillis();
			}
			
			return problems;
		}else{
			//Not enable remote judge
			return new ArrayList<>();
		}
	}
	
	/**
	 * Update Codeforce Problem Database
	 */
	public static void updateCFProblems() {
		
		try{
			String s=get("https://codeforces.com/api/problemset.problems");
			JsonParser jp=new JsonParser();
			JsonObject root=(JsonObject) jp.parse(s);
			
			String status=root.get("status").getAsString();
			if(status.equals("OK")){
				//Ok
				JsonArray result=root.get("result").getAsJsonObject().get("problems").getAsJsonArray();
				CodeforcesProblem[] arr=new Gson().fromJson(result, CodeforcesProblem[].class);
				problems=Arrays.asList(arr);
				
			}else{
				String message=root.get("comment").getAsString();
				throw new Exception("Status check failed:"+status+":"+message);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	/**
	 * Get source code of a webpage
	 * @param addr - Web page address
	 * @return
	 * @throws Exception
	 */
	public static String get(String addr) throws Exception {
		URL url;
		int responsecode;
		HttpURLConnection urlConnection;
		BufferedReader reader;
		String line;
		url = new URL(addr);
		urlConnection = (HttpURLConnection) url.openConnection();
		responsecode = urlConnection.getResponseCode();
		if (responsecode == 200) {
			reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "GBK"));
			String ss = "";
			while ((line = reader.readLine()) != null) {
				ss += line + "\n";
			}
			return ss;
		}else {
			throw new Exception("Bad response Code:" + responsecode);
		}
	}
	
	
}
