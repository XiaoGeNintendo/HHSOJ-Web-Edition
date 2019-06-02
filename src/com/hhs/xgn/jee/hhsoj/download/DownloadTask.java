package com.hhs.xgn.jee.hhsoj.download;

import java.util.Date;

public class DownloadTask {
	private String from;
	private String to;
	private long time;
	private long now;
	private long speed;
	private long timeDone;
	
	public String getStatus(){
		if(now==0){
			return "In queue";
		}
		if(timeDone>0){
			return "Done at "+new Date(timeDone);
		}
		if(timeDone<0){
			return "Error at "+new Date(-timeDone);
		}
		return "Downloaded"+s(now);
	}
	
	public String s(long filesize){
		if(filesize>=1024*1024*1024) //是否超过1G
    		return Math.round(filesize*100/1024/1024/1024)/100+"GB";
    	if(filesize>=1024*1024) //是否超过1M
    		return Math.round(filesize*10/1024/1024)/10+"MB"; 
    	if(filesize>=1024) //是否超过1K
    		return Math.round(filesize/1024)+"KB"; 
    	return filesize+"B"; //默认为字节数 
	}
	public DownloadTask(){
		
	}
	
	public DownloadTask(String f,String t,long tme){
		from=f;
		to=t;
		time=tme;
		now=speed=timeDone=0;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}
	
	public long getNow() {
		return now;
	}

	public void setNow(long now) {
		this.now = now;
	}

	public long getSpeed() {
		return speed;
	}

	public void setSpeed(long speed) {
		this.speed = speed;
	}

	public long getTimeDone() {
		return timeDone;
	}

	public void setTimeDone(long timeDone) {
		this.timeDone = timeDone;
	}

	@Override
	public String toString() {
		return "DownloadTask [from=" + from + ", to=" + to + ", time=" + time + ", now=" + now + ", speed=" + speed
				+ ", timeDone=" + timeDone + "]";
	}
}
