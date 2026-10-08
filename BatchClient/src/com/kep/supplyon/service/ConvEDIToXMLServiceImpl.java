package com.kep.supplyon.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import sun.nio.cs.StandardCharsets;

import com.kep.common.EDItoXML;

public class ConvEDIToXMLServiceImpl implements ConvEDIToXMLService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute() {
		/*로컬 테스트용*/
		//String path = "C:/mendelson_opensource_as2/messages/kepas2/inbox/";
		/*운영 테스트용*/
		String path = "D:/mendelson_opensource_as2/messages/kepas2/inbox/";

		File dirFile = new File(path);
		File[] fileList = dirFile.listFiles();
		
		int fileCount = 0;
		
		boolean converted = false;
		boolean isMoved = false;
		
		for(File tf : fileList){
			if(tf.isFile() && !tf.getName().contains("_rep")){
				replaceStr(path, tf.getName());
				
				long time = System.currentTimeMillis(); 
				SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
				String cTime = dayTime.format(new Date(time));
				  
				File mFile = new File(path+"back/"+cTime+"_"+tf.getName());
					
				boolean isMovedt = false;
				/*renameTo 특성상 실패할 확률이 있어 반복문으로 구현*/
				for(int i=0;i<20;i++){
					isMovedt = tf.renameTo(mFile);
					if(isMovedt){
						log.debug("File moved to /back directory successfully");
						break;
					}
				}				
				
			}
		}
		
		fileList = dirFile.listFiles();
		
		for(File tf : fileList){

			if(tf.isFile() && tf.getName().contains("_rep")){
				
				converted = false;
				isMoved = false;
				
				log.info("Start to convert "+tf.getName()+"....");
				
				fileCount++;
				
				long time = System.currentTimeMillis(); 
				SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
				String cTime = dayTime.format(new Date(time));
				
				/*EDIFACT -> XML변환*/
				EDItoXML theObject = new EDItoXML(path+tf.getName(), path+"converted/"+tf.getName()+".xml");
				
				converted = theObject.run();
				
				theObject.terminate();				
				
				if(converted){
					log.info("["+tf.getName()+"]"+"converted successfully ..");
					File mFile = new File(path+"back/"+cTime+"_"+tf.getName());
					
					/*renameTo 특성상 실패할 확률이 있어 반복문으로 구현*/
					for(int i=0;i<20;i++){	
						isMoved = tf.renameTo(mFile);
						if(isMoved){
							log.info(fileCount + "files converted successfully");
							log.debug("File moved to /back directory successfully");
							break;
						}
					}
					
					
				}else{
					log.error(tf.getName()+"is not converted, check the file!!!");
				}
			}
		}
		
		
	}
	
	public void replaceStr(String path, String fileName){
		
	
		 File inputFile = new File(path+fileName);
		 File outputFile = new File(path+fileName+"_rep");

		 FileInputStream fileInputStream = null;
		 BufferedReader bufferedReader = null;
		 FileOutputStream fileOutputStream = null;
		 BufferedWriter bufferedWriter = null;
        
		 boolean result = false;

		 try {
			  // FileInputStream,FileOutputStream, BufferdReader, BufferedWriter
			  // 생성
			  fileInputStream = new FileInputStream(inputFile);
			  fileOutputStream = new FileOutputStream(outputFile);
	  	      bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream, "UTF-8"));
			  bufferedWriter = new BufferedWriter(new OutputStreamWriter(fileOutputStream, "UTF-8"));
	
			  // 원본 파일에서 읽어 들이는 한라인
			  String line;
			  // 패턴에 일치하는 문자로 대체하고 난 후의 string
			  String repLine;
	
			  // 바꾸고자 하는 string과 바꿀 sting 정의
			  String originalString = "ORDCHG:";
			  String replaceString = "ORDERS:";
	
			  // 원본 파일에서 한라인씩 읽는다.
			  while ((line = bufferedReader.readLine()) != null) {
				  // 일치하는 패턴에서는 바꿀 문자로 변환
				  repLine = line.replace(originalString, replaceString);
		
				  // 새로운 파일에 쓴다.
				  bufferedWriter.write(repLine, 0, repLine.length());
				  bufferedWriter.newLine();
			  }

			  
		 } catch (IOException ex) {
				  ex.printStackTrace();
		 } finally {
			 // 리소스 해제. 개별적으로 해제한다.
			 try {
				 bufferedReader.close();
				 } catch (IOException ex1) {
					   ex1.printStackTrace();
				   }
			 try {
				 bufferedWriter.close();
				 } catch (IOException ex2) {
					 ex2.printStackTrace();
				 }
		 }
		 
	}
	

}
