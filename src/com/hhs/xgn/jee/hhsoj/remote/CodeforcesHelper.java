package com.hhs.xgn.jee.hhsoj.remote;

import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

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
	 * Given problem conId and index. Returns the problem
	 * @param s
	 * @return
	 */
	public static CodeforcesProblem getCodeforcesProblem(String s){
		List<CodeforcesProblem> l=getCodeforcesProblems();
		for(CodeforcesProblem c:l){
			if((c.getContestId()+c.getIndex()).equals(s)){
				return c;
			}
		}
		return null;
	}
	
	/**
	 * Returns a problem statement by a problem
	 * @param cp
	 * @return
	 */
	public static String getProblemStatement(CodeforcesProblem cp){
		try{
			String raw=get("https://codeforces.com/problemset/problem/"+cp.getContestId()+"/"+cp.getIndex());
			
			Document doc=Jsoup.parseBodyFragment(raw);
			
			return doc.getElementsByClass("problemindexholder").get(0).html();
		}catch(Exception e){
			e.printStackTrace();
			return "Fail to fetch problem statement.\n";
		}
	}
	/**
	 * Get the Codeforces Problems according to the API
	 * @return
	 */
	public synchronized static List<CodeforcesProblem> getCodeforcesProblems(){
		Config c=new ConfigLoader().load();
		if(c.isEnableRemoteJudge()){
			//OK. Now check time
			long now=System.currentTimeMillis();
			long delta=c.getQueryTime();
			long expectedLastTime=now-delta;
			if(lastQuery<expectedLastTime){
				//Out-of-date data. Will update
				updateCFProblems();
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
		System.out.println("Updating Codeforces Database");
		long now=System.currentTimeMillis();
		
		try{
			String s=get("https://codeforces.com/api/problemset.problems");
			
			System.out.println("Webpage Downloaded");
			
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
			
			System.out.println("Success:"+(System.currentTimeMillis()-now)+"ms cost.");
			lastQuery=System.currentTimeMillis();

		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * Get the last submission on Codeforces
	 */
	public static CodeforcesSubmission getLastSubmission(){
		
		try{
			Config c=new ConfigLoader().load();
			if(!c.isEnableRemoteJudge()){
				return null;
			}
			String res=get("http://codeforces.com/api/user.status?handle="+c.getCodeforcesUsername()+"&from=1&count=1");
			JsonParser jp=new JsonParser();
			JsonObject root=(JsonObject)jp.parse(res);
			String status=root.get("status").getAsString();
			
			if(!status.equals("OK")){
				String message=root.get("comment").getAsString();
				throw new Exception("Failed:"+message);
			}
			
			JsonArray ja=root.get("result").getAsJsonArray();
			return new Gson().fromJson(ja.get(0),CodeforcesSubmission.class);
		}catch(Exception e){
			e.printStackTrace();
			return null;
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
			reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "utf-8"));
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
