package com.hhs.xgn.jee.hhsoj.db;

import com.hhs.xgn.jee.hhsoj.type.Problem;

public class Templater {
	public static String loadTemplate(String s,Problem p){
		String st="<h2>Edit "+s+"</h2><textarea id=\"edit_"+s+"\" rows=20 cols=100>"+FileHelper.readFileFull(p.getPath()+"/"+s)+"</textarea><button onclick=\"update('"+s+"')\">Update File</button>";
		return st;
	}
}
