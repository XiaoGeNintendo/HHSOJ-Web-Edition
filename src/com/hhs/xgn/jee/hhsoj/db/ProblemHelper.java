package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesProblem;
import com.hhs.xgn.jee.hhsoj.type.Problem;

/**
 * Helper for Problems loading
 * 
 * @author XGN
 *
 */
public class ProblemHelper {

	public synchronized ArrayList<Problem> getAllProblems() {
		File f = new File(ConfigLoader.getPath() + "/problems");
		if (!f.exists()) {
			f.mkdirs();
		}

		ArrayList<Problem> arr = new ArrayList<Problem>();
		for (String sub : f.list()) {
			arr.add(readSingleProblem(sub));
		}

		// System.out.println("Read "+arr.size()+" problems.");
		return arr;
	}

	/**
	 * Returns the Codeforces Problem by the String
	 * 
	 * @param s
	 * @return
	 */
	public CodeforcesProblem getProblemDataR(String s) {
		s = s.substring(1);
		return CodeforcesHelper.getCodeforcesProblem(s);
	}

	/**
	 * Get the problem data by a unique problem name
	 * 
	 * @param s
	 * @return
	 */
	public synchronized Problem getProblemData(String s) {
		if (s.startsWith("C")) {
			return readContestProblem(s);
		}
		if (s.startsWith("R")) {
			Problem p = new Problem();
			p.setType(Problem.CODEFORCES);
			return p;
		}
		return readSingleProblem(s);
	}

	/**
	 * Get the statement of the problem with problem id
	 * 
	 * @param id
	 * @return
	 */
	public synchronized String getProblemStatement(String id) {

		try {
			if (id == null || id.equals("")) {
				return null;
			}
			Problem p = getProblemData(id);
			File statementPath = new File(p.getPath() + "/" + p.getArg("Statement"));
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(statementPath), "utf-8"));
			String s, ans = "";
			while ((s = br.readLine()) != null) {
				ans += s + "\n";
			}
			br.close();

			return ans;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * Read a problem from the contest with the given format String
	 * 
	 * @param s
	 *            the format string in format "C123A"
	 * @return the Problem
	 */
	public synchronized Problem readContestProblem(String s) {
		String conid = "";
		String conindex = "";
		for (int i = 1; i < s.length(); i++) {
			if (s.charAt(i) >= '0' && s.charAt(i) <= '9') {
				conid += s.charAt(i);
			} else {
				conindex = s.substring(i);
				break;
			}
		}

		return new ContestHelper().getContestDataById(conid).getProblem(conindex);
	}

	public synchronized Problem getProblemData(int id) {
		return readSingleProblem(id + "");
	}

	public synchronized Problem readSingleProblem(String folder) {
		return readSingleProblem(folder, ConfigLoader.getPath() + "/problems", true);
	}

	/*
	 * Folder Structure
	 * 
	 * hhsoj -problems -1000 -arg.txt -tests -test inputs -other files (solution
	 * & checker)
	 * 
	 * arg.txt contains: - Solution=sol.exe - Checker=checker.exe - Name=A+b
	 * Problem - TL=1000 - ML=1000 - Tag=math,implementation -
	 * Statement=statement.jsp
	 */
	public synchronized Problem readSingleProblem(String folder, String root, boolean setId) {
		String base = root + "/" + folder + "/";

		Problem p = new Problem();

		p.setArg(getArg(base + "arg.txt"));
		if (setId)
			p.setId(Integer.parseInt(folder));
		p.setName(p.getArg("Name"));
		p.setTag(p.getArg("Tag"));

		return p;
	}

	private synchronized Map<String, String> getArg(String file) {
		File f = new File(file);

		try {
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f)));

			Map<String, String> mp = new HashMap<String, String>();

			String line;
			while ((line = br.readLine()) != null) {
				int pos = line.indexOf("=");
				String key = line.substring(0, pos);
				String value = line.substring(pos + 1);
				mp.put(key, value);
			}

			br.close();

			// System.out.println(mp);
			return mp;
		} catch (Exception e) {
			// e.printStackTrace();
			return null;
		}
	}
}
