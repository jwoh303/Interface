package com.kep.common;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

public class FileUtil {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 * 파일내용 읽기
	 * @param srcDir
	 * @param filename
	 * @param charset
	 * @return
	 */
	public List<String> getFileContent(String srcDir, String filename, String charset) {
		List<String> rtnList	= new ArrayList<String>();
		FileReader fr = null;
		InputStreamReader is = null;
		BufferedReader br = null;
		String filePath = srcDir + "/" + filename;
		
		try {
//			fr = new FileReader(filePath);
			is = new InputStreamReader(new FileInputStream(filePath), charset);
			br = new BufferedReader(is);
			String lineStr = null;
			while ( (lineStr = br.readLine()) != null) { rtnList.add(lineStr); }
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try {fr.close();} catch(Exception e) {}
			try {br.close();} catch(Exception e) {}
		}
		
		return rtnList;
	}
	
	/**
	 * 파일 저장하기
	 * @param desDir
	 * @param filename
	 * @param fileContents
	 * @param newLine
	 * @param charset
	 * @return
	 */
	public boolean setFileContent(String desDir, String filename, List<String> fileContents, String charset , String newLine ) {
		boolean bSuccess = false;
		boolean bFileCreate = false;
		try {
			File file = new File(desDir + "/" + filename);
			bFileCreate = file.createNewFile();
			if ("".equals(newLine)) 
				newLine = System.getProperty("line.separator");
			if (bFileCreate == true) {
				BufferedWriter bfWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file.getPath()), charset));
				if (file.isFile() && file.canWrite()) {
					for( String lineData : fileContents ) {
						bfWriter.write(lineData + newLine);
					}
					bfWriter.close();
					bSuccess = true;
				}
			} else {
				log.error("File Create Error : " + filename + " is fail...");
			}
		} catch (IOException e) {
			e.printStackTrace();
			log.error("setFileContent Error : " + e.getMessage());
		}
		
		return bSuccess;
	}
	
	public List<String> getFileList(String srcDir, String prefix) {
		List<String> fList = new ArrayList<String>();
		try {
			File dir = new File(srcDir);
			File files[] = dir.listFiles();
			
			if (files != null) {
				Arrays.sort(files);
				for(int i =0 ; i < files.length ; i++) {	
					if( prefix == null || files[i].isFile() && files[i].getName().indexOf(prefix) > -1) {
						log.debug(files[i].getName());
						fList.add(files[i].getName());
					}
				}	
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
		
		return fList;
	}
	
    public boolean moveutil (String sFInfo, String dFInfo) {

    	boolean isSuccess = true;
		File f = new File(sFInfo);
		log.debug("move : " + sFInfo + " ==> " + dFInfo);
		try {
			FileUtils.moveFile(f,new File(dFInfo));
		} catch (IOException e) {
			isSuccess = false;
			log.debug("isSuccess = " + isSuccess + "["+sFInfo+" => "+dFInfo+"]");
		}
		return isSuccess;
	}
	
	public boolean move(String sFInfo, String dFInfo)  throws IOException {
		
		File f = new File(sFInfo);
		log.debug("move : " + sFInfo + " ==> " + dFInfo);
		
		boolean isSuccess = f.renameTo(new File(dFInfo));
		log.debug("isSuccess = " + isSuccess + "["+sFInfo+" => "+dFInfo+"]");
		return isSuccess;
	}
	
	public boolean moveBack(String srcPath, String fileName) throws IOException {

		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmsssss");
		Date time = new Date();
		String ntime = dFormat.format(time);
		
		String yyyy = ntime.substring(0,4);
		String mm = ntime.substring(4,6);
		String dd = ntime.substring(6,8);
		
		String bDir = srcPath + "/BACK/"+yyyy+"/"+mm+"/"+dd +"/";
		String sName = srcPath + "/" + fileName;
		String bName = srcPath + "/BACK/"+yyyy+"/"+mm+"/"+dd +"/" + fileName + "." + ntime;
		
		File backDir = new File(bDir);
		if ( !backDir.isDirectory()) {
			log.error("Diretory Create..");
			String rDir = srcPath + "/BACK/";
			String yDir = srcPath + "/BACK/"+yyyy+"/";
			String mDir = srcPath + "/BACK/"+yyyy+"/"+mm+"/";
			new File(rDir).mkdir();
			new File(yDir).mkdir();
			new File(mDir).mkdir();
			backDir.mkdir();
		}

		boolean isSuccess = this.move(sName, bName);
		
		return isSuccess;
	}
	
	public boolean moveBack_DAED(String srcPath, String fileName) throws IOException {

		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmsssss");
		Date time = new Date();
		String ntime = dFormat.format(time);
		
		String yyyy = ntime.substring(0,4);
		String mm = ntime.substring(4,6);
		String dd = ntime.substring(6,8);
		
		String bDir = srcPath + "/archive/"+yyyy+"/"+mm+"/"+dd +"/";
		String sName = srcPath + "/" + fileName;
		String bName = srcPath + "/archive/"+yyyy+"/"+mm+"/"+dd +"/" + fileName + "." + ntime;
		
		File backDir = new File(bDir);
		if ( !backDir.isDirectory()) {
			log.error("Diretory Create..");
			String rDir = srcPath + "/archive/";
			String yDir = srcPath + "/archive/"+yyyy+"/";
			String mDir = srcPath + "/archive/"+yyyy+"/"+mm+"/";
			new File(rDir).mkdir();
			new File(yDir).mkdir();
			new File(mDir).mkdir();
			backDir.mkdir();
		}

		boolean isSuccess = this.moveutil(sName, bName);
		
		return isSuccess;
	}
}