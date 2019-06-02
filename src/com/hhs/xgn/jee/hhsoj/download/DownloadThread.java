package com.hhs.xgn.jee.hhsoj.download;

import java.io.*;
import java.net.URL;

public class DownloadThread extends Thread {
	
	public void run() {
		System.out.println("Download Thread Initaize Ok!");
		
		while (true) {
			
			
			while (DownloadQueue.hasElement() == false) {
				
			}

			DownloadTask dt=DownloadQueue.getFirstSubmission();
			DownloadQueue.popFront();
			
			System.out.println("Downloading "+dt);
			
			try{
				URL url=new URL(dt.getFrom());
				BufferedOutputStream bos=new BufferedOutputStream(new FileOutputStream(dt.getTo()));
				BufferedInputStream bis=new BufferedInputStream(url.openStream());
				
				byte[] data=new byte[102400];
				
				long sum=0,tmpsum=0;
				
				long start=System.currentTimeMillis();
				
				long bck=start;
				
				while(true){
					int read=bis.read(data);

					if(read==-1){
						break;
					}
					
					bos.write(data,0,read);
					
					sum+=read;
					
					tmpsum+=read;
					
					if(System.currentTimeMillis()-bck>=1000){
						dt.setSpeed(tmpsum);
						dt.setNow(sum);

						tmpsum=0;
						bck=System.currentTimeMillis();
					}
					
				}
				
				bis.close();
				bos.close();
				
				dt.setTimeDone(System.currentTimeMillis());
				System.out.println("Done downloading!");
			}catch(Exception e){
				dt.setNow(1);
				dt.setTimeDone(-System.currentTimeMillis());
				e.printStackTrace();
			}
		}
	}

	

}
