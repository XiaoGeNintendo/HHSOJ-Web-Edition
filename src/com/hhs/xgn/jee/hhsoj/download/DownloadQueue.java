package com.hhs.xgn.jee.hhsoj.download;


import java.util.Vector;


public class DownloadQueue {
	public static Vector<DownloadTask> queue=new Vector<>();
	
	public static boolean open=false;
	
	public static int first=0;
	
	public synchronized static void openThread(){
		if(open) return;
		System.out.println("Static block runs");
		Thread t=new DownloadThread();
		t.setName("Download Thread");
		
		t.start();
		open=true;
	}
	
	
	public synchronized static boolean hasElement(){
		return first!=queue.size();
	}
	
	public synchronized static DownloadTask getFirstSubmission(){
		return queue.get(first);
	}
	
	public synchronized static void popFront(){
		first++;
	}
	
	public synchronized static void addTask(DownloadTask s){
		queue.add(s);
		
		System.out.println("Added download task!"+queue);
		
		openThread();
	}

	public static Vector<DownloadTask> get(){
		return queue;
	}
	
	public static boolean isOpen() {
		return open;
	}


	public static void setOpen(boolean open) {
		DownloadQueue.open = open;
	}
}
