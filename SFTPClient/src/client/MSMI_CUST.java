package client;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;

import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.ChannelSftp.LsEntry;

import common.DButil;
import utils.FtpSUtils;
import utils.SFTPUtil;


public class MSMI_CUST {
	
	private static Logger log	= Logger.getLogger(MSMI_CUST.class.getName());
	
	/* BUYER UPLOAD PATH */
	private final static String KEP_FTP_RECV_PATH = "/export/ftp/pub_msmi/RECV/";
	private final static String KEP_FTP_SEND_PATH = "/export/ftp/pub_msmi/SEND/";
	
	/* TEMP DOWNLOAD PATH */	
	private final static String KEP_SEND_PATH	= "D:/SFTPClient/MSMI/SEND/";
	private final static String KEP_RECV_PATH	= "D:/SFTPClient/MSMI/RECV/";
	
	/* BUYER FTP SERVER */
	private static String BUYER_FTP_URL = null;  //NOPMD 해당항목 반드시 필요한 내용임
	private static int BUYER_FTP_PORT = 0;                 //NOPMD 해당항목 반드시 필요한 내용임
//	private final static String[] BUYER_FTP_ID = {"KOR8615","KOR8616","KOR8622"};  //NOPMD 해당항목 반드시 필요한 내용임
//	private final static String[] BUYER_FTP_PW = {"1Wckg48UL69O7lXgFtcC","ZvsHBGG2l483xRrs9G7p","YDO2GjyDA10tw1Mlj27u"};  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String[] BUYER_FTP_ID = {"KOR8615","KOR8616"};  //NOPMD 해당항목 반드시 필요한 내용임
//	private final static String[] BUYER_FTP_PW = {"1Wckg48UL69O7lXgFtcC","ZvsHBGG2l483xRrs9G7p"};  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String[] BUYER_FTP_PW = {"88197990","64160218"};  // 240924 변경
	private final static String[] BUYER_SRC_PATH = {"SI/","SR/","AR/"};
	
	/* KEP FTP SERVER */
	private final static String KEP_FTP_URL = "10.20.103.11";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static int KEP_FTP_PORT = 51022;                 //NOPMD 해당항목 반드시 필요한 내용임
	private final static String KEP_FTP_ID = "eai";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String KEP_FTP_PW = "eai8914!";  //NOPMD 해당항목 반드시 필요한 내용임
	
	private int count = 0;
	
	private ChannelSftp cSftp = null;
	
	private DButil dbutil = null;
	
	private boolean canAccess = false;
	
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error("서버 로그인 실패");
			dbutil.updateConnectionInfo(count+1, "MSMI");
			if(count >= 5){
				dbutil.sendWarningEmail();
			}
			throw new Exception("FTP 접속실패.");
		}else{
			log.debug("서버 로그인 성공");
			dbutil.updateConnectionInfo(1, "MSMI");
		}
	}
	
	public void init(){
		
		dbutil = new DButil();
		
		String[] connections = dbutil.selectConnectionInfo("MSMI");
		
		BUYER_FTP_URL = connections[0]; // URL
		BUYER_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= 5) canAccess = true;
		else canAccess = false;
				
		log.debug("BUYER_FTP_URL : "+BUYER_FTP_URL);
		log.debug("BUYER_FTP_PORT : "+BUYER_FTP_PORT);
		log.debug("count : "+count);
	}
	
	public void disconnectSFTP() throws Exception{
		
		if(cSftp != null){
			try {
				SFTPUtil.ftpLogOut();
			} catch (Exception e) {
				log.error("sFtp 연결해제 오류");
				throw new Exception("sFtp 연결해제 오류");
			}
		}
		
	}
	
	/**
	 * 미즈미 SFTP서버에서 다운받을 파일리스트 생성 
	 * @param cSftp SFTP 접속 ChannelSftp
     * @param dir 검색 대상 디렉토리
     * @return ArrayList<String> 파일리스트
     * @throws Exception 
	 */
	public ArrayList<String> getFileListFromBuyerServer(ChannelSftp cSftp, String dir) throws Exception{
		
		/*
		 * 가져갈 파일 목록 생성
		 * 
		 * 조건 1) *.chk 이 존재
		 * 조건 2) *.res 없는 경우
		 * 
		 */
		ArrayList<String> fileList	= new ArrayList<String>();
		String[] tmpList = null;
		
		boolean isFound = false;
		
		Vector<ChannelSftp.LsEntry> chkList = null;
		Vector<ChannelSftp.LsEntry> resList = null;
		
		ArrayList<String> chkFiles	= new ArrayList<String>();
		ArrayList<String> resFiles	= new ArrayList<String>();
		
		cSftp.cd(dir);
		
		chkList = cSftp.ls("*.chk");
		resList = cSftp.ls("*.res");
		
		
		for (LsEntry lsEntry : chkList) {
			log.debug("chkList getname : "+lsEntry.getFilename());
			tmpList = lsEntry.getFilename().split("\\.");
			log.debug("chklist split : "+tmpList[0]+","+tmpList[1]);
			chkFiles.add(tmpList[0]);
		}
		
		for (LsEntry lsEntry : resList) {
			log.debug("resList getname : "+lsEntry.getFilename());
			tmpList = lsEntry.getFilename().split("\\.");
			log.debug("reslist split : "+tmpList[0]+","+tmpList[1]);
			resFiles.add(tmpList[0]);
		}
		
		Collections.sort(chkFiles);
		Collections.sort(resFiles);
		
		/* 다운대상 체크 */
		for (int i=0; i<chkFiles.size(); i++) {
			
			isFound = false;
			
			for (int j=0; j<resFiles.size(); j++) {
				if(chkFiles.get(i).equals(resFiles.get(j))){
					isFound = true;
					break;
				}				
			}
			
			if(isFound == false){
				log.debug("file list 추가 : "+chkFiles.get(i));
				fileList.add(chkFiles.get(i));
			}
		}
		
		cSftp.cd("/..");
		
		if(fileList.size() != 0){
			log.debug("전송대상 파일 "+fileList.size()+"개");
		}else{
			log.debug("전송대상 파일이 없습니다.");
		}
		
		return fileList;
	}
	
	/**
	 * 중계 서버(34번 장비)에서 보낼 파일 리스트 생성 
     * @param srcDir 검색 대상 디렉토리
     * @param filterStr 필터링 문자열
     * @return ArrayList<String> 파일리스트
     * @throws Exception 
	 */
	public ArrayList<String> getFileListFromKEPServer(String srcDir, String filterStr) throws Exception{
		
		/* 파일리스트 생성 */
		ArrayList<String> fileList	= new ArrayList<String>();
		
		File dir	= new File(srcDir);
		File[] fList	= dir.listFiles();
		
		if (fList != null && fList.length > 0) {
			String filter = filterStr.substring(3, 7);
			for(int i = 0 ; i < fList.length ; i++) {
				
				String[] fileNameSplitByUnderbar = fList[i].getName().split("_");
				String[] fileNameSplitByDot = fList[i].getName().split("\\.");

//				log.debug("splitByUnderbar result : " + fileNameSplitByUnderbar[0]);
//				log.debug("splitByDot result : " + fileNameSplitByDot[0]);
				
				if (fList[i].isFile() && filter.equals(fileNameSplitByUnderbar[0])) {
					fileList.add(fileNameSplitByDot[0]);
				}
			}
		}
		
		if(fileList.size() != 0){
			log.debug("전송대상 파일 "+fileList.size()+"개");
		}else{
			log.debug("전송대상 파일이 없습니다.");
		}
		
		return fileList;
	}
	
	/**
	 * BUYER sFTP서버 -> KEP 중계서버 (34번 장비) 파일 전송
	 * @param ftp_url
	 * @param ftp_port
	 * @param ftp_id
	 * @param ftp_pw
	 * @param srcPath
	 * @param targetPath
	 * @return 
	 * @throws Exception
	 */
	public void recvFromBuyerToKEP(String srcPath, String targetPath) throws Exception{
				
		
		/* 수신준비, dir 생성 */		
		File fSaveDirectory = new File(targetPath);
		if(!fSaveDirectory.isDirectory()){
			fSaveDirectory.mkdirs();
		}
		
		
		/* 다운로드 받을 파일 선택 후 다운 */
		ArrayList<String> fileList	= new ArrayList<String>();
		
		try {
			fileList = getFileListFromBuyerServer(cSftp, srcPath);
		} catch (Exception e) {
			throw new Exception("getFileList 에러");
		}
		
		for(int i = 0 ; i < fileList.size() ; i++) {
					
			// dat파일 다운
			SFTPUtil.sFtpDownloadFile(srcPath, fileList.get(i)+".dat", targetPath);
			
			// res파일 생성
			File tmpFile = new File(targetPath+fileList.get(i)+".res");
			
			
			if(tmpFile.createNewFile()){
				log.debug("res파일이 성공적으로 생성 되었습니다. ["+srcPath + fileList.get(i)+"]");
			}else{
				log.error("res파일 생성에 실패하였습니다. ["+srcPath + fileList.get(i)+"]");
			}
			
			SFTPUtil.sFtpUploadFile(srcPath, tmpFile);
			
			if(tmpFile.delete()){
				log.debug("res파일이 성공적으로 삭제 되었습니다. ["+srcPath + fileList.get(i)+"]");
			}else{
				log.error("res파일 삭제에 실패하였습니다. ["+srcPath + fileList.get(i)+"]");
			}
				
		}

	}
	
	/**
	 * KEP 중계서버(34번 장비) -> KEP FTP(18번 장비) 파일전송
	 * @param ftp_url 
     * @param ftp_port
     * @param ftp_id
     * @param ftp_pw
     * @param srcPath
     * @param targetPath
     * @return
     * @throws Exception 
	 */
	public void recvFromWinsvToFtpsv(String ftp_url, int ftp_port, String ftp_id, String ftp_pw, String srcPath, String targetPath) throws Exception{
		
		boolean isSend = false;
		boolean isMove = true;
		
		FTPClient fClient = null;
        File folder = new File(srcPath);
        ArrayList<String> fileList = new ArrayList<String>(Arrays.asList(folder.list()));
                
	
		fClient = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(fClient == null) {
			log.error("FTP 접속 실패");
			throw new Exception("FTP 접속 실패하였습니다.");
		}
		
		for(int i = 0 ; i < fileList.size() ; i++) {
			
			//log.debug("Send file... : " + srcPath + fileList.get(i));
			File srcFile	= new File(srcPath + fileList.get(i));
			
			if(srcFile.isFile()){
				
				isSend	= FtpSUtils.ftpUploadFile(fClient, srcFile, targetPath);
				log.debug("Send Result... : " + isSend);
				
				if (isSend) {
					
					File desFile	= new File(srcPath + "BACK/" + fileList.get(i));
					log.debug("move : " + srcFile.getPath()+"/"+srcFile.getName() + " ==> " +  desFile.getPath()+"/"+desFile.getName());
					try {
						FileUtils.moveFile(srcFile,desFile);
					} catch (IOException e) {
						isMove = false;
					}
					
					if(!isMove) {
						log.error("파일 이동 실패했습니다. ["+srcPath +"BACK/" + fileList.get(i)+"]");
					}
				} else {
					log.error("FTP 전송 실패했습니다. ["+srcPath +"BACK/" + fileList.get(i)+"]");
				}
			}
		}
		
		if(fClient != null) {
			
			FtpSUtils.ftpLogOut(fClient);
			fClient = null;
			
		}
	}
	
	/**
	 * KEP FTP(18번 장비) -> KEP 중계서버(34번 장비) 파일전송 
	 * @param ftp_url
     * @param ftp_port
     * @param ftp_id
     * @param ftp_pw
     * @param srcPath
     * @param targetPath
     * @return 
     * @throws Exception 
	 */
	public void sendToWinsvFromFtpsv(String ftp_url, int ftp_port, String ftp_id, String ftp_pw, String srcPath, String targetPath) throws Exception{
		FTPClient fClient = null;
		
		
		
		/* 수신준비, dir 생성 */
        File fSaveDirectory = new File(targetPath);
        if(!fSaveDirectory.isDirectory()){
        	fSaveDirectory.mkdirs();
        }
        	/* 접속 및 로그인 */
       	fClient = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);
   		if(fClient == null) {
   			log.error("FTP 접속 실패");
			throw new Exception("FTP 접속 실패하였습니다. 배치를 종료합니다.");
		}
   		
   		/* 파일 다운로드 */
		FtpSUtils.ftpDownloadFileInDirAndMoveForMSMI_CUST(fClient, srcPath, targetPath, srcPath+"BACK/");
		
		/* 전송 종료 */
   	
		if(fClient != null) {
			
			FtpSUtils.ftpLogOut(fClient);
			fClient = null;  //NOPMD 해당항목 반드시 필요한 내용임
			
		}

	}
	
	/**
	 * KEP 중계서버(34번 장비) -> BUYER sFTP서버 파일 전송 
	 * @param ftp_url
     * @param ftp_port
     * @param ftp_id
     * @param ftp_pw
     * @param srcPath
     * @param targetPath
     * @return 
     * @throws Exception 
	 */
	public void sendToBuyerFromKEP(String ftp_id, String srcPath, String targetPath) throws Exception{
		
		/* BUYER FTP 서버 로그인 */
//		ChannelSftp cSftp = null;
		/* 파일리스트 생성 */
		ArrayList<String> fileList = null;
		
		boolean isMove = false;
			
		fileList = new ArrayList<String>();
		fileList = getFileListFromKEPServer(srcPath, ftp_id);
		
		if (fileList.size() == 0) {
			log.debug("전송할 파일이 존재하지 않습니다.");
			return;
		} else {
			log.debug("전송대상 : "+fileList.size()+" 건");	
		}
			
		
		/* 파일리스트의 파일 전송 */
		for(int i = 0 ; i < fileList.size() ; i++) {
			
			/* 지역 오픈 */			

	    	isMove = true;
			
			File datFile = new File(srcPath+fileList.get(i)+".dat"); // 데이터 파일
			File chkFile = new File(srcPath+fileList.get(i)+".chk"); // 데이터 전송확인용 chk파일
			
			chkFile.createNewFile();
			
			SFTPUtil.sFtpUploadFile(targetPath, datFile);
			SFTPUtil.sFtpUploadFile(targetPath, chkFile);
			
			File desFile	= new File(srcPath + "BACK/" + fileList.get(i) + ".dat");
			log.debug("move : " + datFile.getPath()+"/"+datFile.getName() + " ==> " +  desFile.getPath()+"/"+desFile.getName());
			try {
				FileUtils.moveFile(datFile,desFile);
			} catch (IOException e) {
				isMove = false;
			}
			
			if(!isMove) {
				log.error("파일 이동 실패했습니다. ["+srcPath +"BACK/" + fileList.get(i)+"]");
			}
			
			if(chkFile.delete()){
				log.debug("chk파일이 성공적으로 삭제 되었습니다. ["+srcPath + fileList.get(i)+"]");
			}else{
				log.error("chk파일 삭제에 실패하였습니다. ["+srcPath + fileList.get(i)+"]");
			}
			
		}

		fileList.clear();
		
	}
	
public void recvFromBuyerToKEP(String srcPath, String targetPath, String srcBackupPath) throws Exception{
		
		/* TARGET sFTP 서버 로그인 */
		/* 수신준비, dir 생성 */		
	   
		File fSaveDirectory = new File(targetPath);
		if(!fSaveDirectory.isDirectory()){
			fSaveDirectory.mkdirs();

			File backDir = new File(targetPath+"BACK/");
			if(!backDir.isDirectory()){ 
				backDir.mkdir();
			}
		}
		
		/* 다운로드 받을 파일 선택 후 다운 */
		ArrayList<String> fileList	= new ArrayList<String>();
		
		fileList = getFileListFromTargetServer(srcPath);
		
		for(int i = 0 ; i < fileList.size() ; i++) {
						
			// 파일 다운
			SFTPUtil.sFtpDownloadFile(srcPath, fileList.get(i), targetPath);
			// 다운 후 파일 원격디렉토리에서 삭제.
			SFTPUtil.sftpDeleteFile(srcPath, fileList.get(i));
			// Target Backup 폴더 이동.
			File backFile	= new File(targetPath+"/"+fileList.get(i));
			SFTPUtil.sFtpUploadFile(srcBackupPath, backFile);
		}
	}
	
public ArrayList<String> getFileListFromTargetServer(String dir) throws Exception{
	
	/*
	 * 가져갈 파일 목록 생성
	 */
	ArrayList<String> fileList	= new ArrayList<String>();
	Vector<ChannelSftp.LsEntry> dataList = null;
	
	
	this.cSftp.cd(dir);
	
	dataList = this.cSftp.ls("*");
	
	
	for (LsEntry lsEntry : dataList) {
		
		if (!lsEntry.getFilename().equals("BACK")) {
			log.debug("dataList getname : "+lsEntry.getFilename());

			fileList.add(lsEntry.getFilename());
		}
	}
	
	Collections.sort(fileList);
	
	
	this.cSftp.cd("/..");
	
	if(fileList.size() != 0){
		log.debug("전송대상 파일 "+fileList.size()+"개");
		for (String ss : fileList) {
			log.debug("폴더내 파일 : "+ss);
		}
	}else{
		log.debug("전송대상 파일이 없습니다.");
	}
	
	return fileList;
}
	
public void sendToTargetFromKEP(String ftp_id, String srcPath, String targetPath) throws Exception{
	
	/* 파일리스트 생성 */
	ArrayList<String> fileList = null;
	
	boolean isMove = false;
		
	fileList = new ArrayList<String>();
	fileList = getFileListFromKEPServer2(srcPath, ftp_id);
	
	if (fileList.size() == 0) {
		System.out.println("전송할 파일이 존재하지 않습니다.");
		log.debug("전송할 파일이 존재하지 않습니다.");
		return;
	} else {
		System.out.println("전송대상 : "+fileList.size()+" 건");
		log.debug("전송대상 : "+fileList.size()+" 건");	
	}
		
	
	/* 파일리스트의 파일 전송 */
	for(int i = 0 ; i < fileList.size() ; i++) {
		
		/* 지역 오픈 */			
		isMove = true;
		File srcFile = new File(srcPath+fileList.get(i)); // 데이터 파일
		SFTPUtil.sFtpUploadFile(targetPath,srcFile);
		
		if (isMove == true) {
			File desFile	= new File(srcPath + "BACK/" + fileList.get(i) );
			
			log.debug("move : " + srcFile.getPath()+"/"+srcFile.getName() + " ==> " +  desFile.getPath()+"/"+desFile.getName());
			try {
				FileUtils.moveFile(srcFile,desFile);
			} catch (IOException e) {
				isMove = false;
			}
			
			if(!isMove) {
				log.error("파일 이동 실패했습니다. ["+srcPath +"BACK/" + fileList.get(i)+"]");
			}	
		} else {
			log.error("파일 업로드 실패했습니다. ["+srcPath + fileList.get(i)+"]");
		}
		
	}
	fileList.clear();
}

public ArrayList<String> getFileListFromKEPServer2(String srcDir, String filterStr) throws Exception{
	
	/* 파일리스트 생성 */
	ArrayList<String> fileList	= new ArrayList<String>();
	
	System.out.println("srcDir : " + srcDir);
	
	File dir	= new File(srcDir);
	File[] fList	= dir.listFiles();
	
	if (fList != null && fList.length > 0) {
		for(int i = 0 ; i < fList.length ; i++) {
			if (fList[i].isFile()) {
				fileList.add(fList[i].getName());
			}
		}
	}
	
	if(fileList.size() != 0){
		log.debug("전송대상 파일 "+fileList.size()+"개");
	}else{
		log.debug("전송대상 파일이 없습니다.");
	}
	
	return fileList;
}

	public void execute() {
		
		this.init();
		
		log.debug("MSMI canAccess : " + canAccess);
		
		if(canAccess){
			try {
				dbutil.updateLastUpdateDateInfo("MSMI");
				
				for(int i = 0 ; i < BUYER_FTP_ID.length ; i++ ){
					
					log.info("[SFTP 연결시도...]");
					this.connectSFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID[i], BUYER_FTP_PW[i]);
					
					/* 데이터 수신 BUYER -> 34번 서버 SI */
					log.info("[DOWNLOAD BUYER->34] ID : "+BUYER_FTP_ID[i]+" , DIR : "+BUYER_SRC_PATH[0]);
					this.recvFromBuyerToKEP(BUYER_SRC_PATH[0], KEP_RECV_PATH);

					/* 데이터 수신 BUYER -> 34번 서버 AR */
					log.info("[DOWNLOAD BUYER->34] ID : "+BUYER_FTP_ID[i]+" , DIR : "+BUYER_SRC_PATH[2]);
					this.recvFromBuyerToKEP(BUYER_SRC_PATH[2], KEP_RECV_PATH);
					
					log.info("[SFTP 연결해제 시도]");
					this.disconnectSFTP();
				}
				
				/* 데이터 수신 34번 서버 -> 18(FTP)번 서버 */
//				log.info("[UPLOAD 34->18] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
//				this.recvFromWinsvToFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				/* 데이터 송신 18(FTP)번 서버 -> 34번 서버 */
//				log.info("[DOWNLOAD 18->34] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
//				this.sendToWinsvFromFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_FTP_SEND_PATH, KEP_SEND_PATH);
				
				System.out.println("sftp 연결시도");
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW);
				
				System.out.println("[DOWNLOAD 103.11->34] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				log.info("[DOWNLOAD 103.11->34] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				recvFromBuyerToKEP(KEP_FTP_SEND_PATH, KEP_SEND_PATH, KEP_FTP_SEND_PATH+"BACK/");

				System.out.println("[DOWNLOAD 34-> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				log.info("[DOWNLOAD 34-> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				sendToTargetFromKEP(KEP_FTP_ID, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				System.out.println("sftp 연결해제");
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
				
				
				
				
				
				for(int i = 0 ; i < BUYER_FTP_ID.length ; i++ ){
					
					log.info("[SFTP 연결시도...]");
					this.connectSFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID[i], BUYER_FTP_PW[i]);
					
					/* 데이터 송신 34번 서버 -> BUYER SR */
					log.info("[UPLOAD 34->BUYER] ID : "+BUYER_FTP_ID[i]+" , DIR : "+BUYER_SRC_PATH[1]);
					this.sendToBuyerFromKEP(BUYER_FTP_ID[i], KEP_SEND_PATH, BUYER_SRC_PATH[1]);
					
					log.info("[SFTP 연결해제 시도]");
					this.disconnectSFTP();
				}
			
			} catch (Exception e) {
				log.error(e);
			}
		}
		
		return;
	}
}
