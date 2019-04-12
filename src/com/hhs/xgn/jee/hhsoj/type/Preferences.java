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
		"useEditor", //Whether to open editor
		"editorTheme", //Editor theme
		"commonLang", //Editor Language (Most useable language)
		"fontSize", //Editor font size
		"autoComplete", //Editor auto complete?
		"realname", //Real name
		"country", //Country From
		"company", //Organization From
	};
	
	public final PreferUnit[] allValue=new PreferUnit[]{
		new PreferUnit("Editor::Use Code Editor","Yes",true,new String[]{"Yes","No"}),
		new PreferUnit("Editor::Editor Theme","monokai",true,new String[]{
			"eclipse",
			"monikai",
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
		}),
		new PreferUnit("Social::Preferred Language","c++",true,new String[]{
				"C++",
				"Python",
				"Java"
		}),
		new PreferUnit("Editor::Font Size","12px",false,null),
		new PreferUnit("Editor::Enable Autocomplete","Yes",true,new String[]{"Yes","No"}),
		new PreferUnit("Social::Name","",false,null),
		new PreferUnit("Social::Country","Earth",false,null),
		new PreferUnit("Social::Company","",false,null)
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
