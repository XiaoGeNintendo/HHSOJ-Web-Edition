package com.hhs.xgn.jee.hhsoj.db;

import com.hhs.xgn.jee.hhsoj.type.Submission;

public class TypeMaster {
	
	static String modal="<i class=\"%s\" data-toggle=\"tooltip\" data-placement=\"left\" title=\"%s\"></i>";
	
	static String[] typeHeader=new String[]{"R","C","H","T",""};
	static Object[][] arg=new Object[][]{
		new String[]{
			"fa fa-cloud","Remote Judge Submission"
		},
		new String[]{
			"fa fa-sort-amount-desc","Contest Problemset Submission"
		},
		new String[]{
			"fa fa-plane","Hack Attempt"
		},
		new String[]{
			"fa fa-edit","Custom Test Submission"
		},
		new String[]{
			"fa fa-send","Normal Submission"
		}
	};
	
	public static String render(Submission s){
		for(int i=0;i<typeHeader.length;i++){
			if(s.getProb().startsWith(typeHeader[i])){
				return String.format(modal, arg[i]);
			}
		}
		
		return null; //This should never happen
	}
}
