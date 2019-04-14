package com.hhs.xgn.jee.hhsoj.type;

import java.util.TreeMap;

/**
 * A class to store user's perferences <br/>
 * In fact it's only a map...
 * @author XGN
 *
 */
public class Preferences {
	public TreeMap<String,PreferUnit> units=new TreeMap<>();
	
	public final String[] allKey=new String[]{
		"editorTheme", //Editor theme
		"commonLang", //Editor Language (Most useable language)
		"fontSize", //Editor font size
		"autoComplete", //Editor auto complete?
		"realname", //Real name
		"country", //Country From
		"company", //Organization From
	};
	
	public final PreferUnit[] allValue=new PreferUnit[]{
		new PreferUnit("Editor::Editor Theme","monokai",true,new String[]{
			"eclipse",
			"monokai",
			"github",
			"xcode",
			"dracula",
			"cobalt",
			"terminal",
			"twilight",
			"kuroir",
			"chrome",
			"dawn",
			"dreamweaver",
		},false),
		new PreferUnit("Social::Preferred Language","C++",true,new String[]{
				"C++",
				"Python",
				"Java"
		},true),
		new PreferUnit("Editor::Font Size","12px",false,null,false),
		new PreferUnit("Editor::Enable Autocomplete","Yes",true,new String[]{"Yes","No"},false),
		new PreferUnit("Social::Name","",false,null,true),
		new PreferUnit("Social::Country","Earth",false,null,true),
		new PreferUnit("Social::Company","",false,null,true)
	};
	
	public Preferences(){
		for(int i=0;i<allKey.length;i++){
			units.put(allKey[i], allValue[i]);
		}
	}
	
	public PreferUnit get(String r){
		return units.get(r);
	}
	
	
}
