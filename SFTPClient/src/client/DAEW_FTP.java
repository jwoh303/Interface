package client;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.log4j.Logger;

import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.ChannelSftp.LsEntry;

import common.DButil;
import utils.FtpSUtils;
import utils.SFTPUtil;

public class DAEW_FTP {
	
	private static Logger log	= Logger.getLogger(DAEW_FTP.class.getName());
	
	/* BUYER UPLOAD PATH */
	private final static String KEP_FTP_RECV_PATH = "/export/ftp/pub_dwts/RECV/";
	private final static String KEP_FTP_SEND_PATH = "/export/ftp/pub_dwts/SEND/";
	
	/* TEMP DOWNLOAD PATH */	
	private final static String KEP_SEND_PATH	= "D:/SFTPClient/DAEW/SEND/";
	private final static String KEP_RECV_PATH	= "D:/SFTPClient/DAEW/RECV/";
	
	//dt.kcmkt.com
	/* BUYER FTP SERVER */
	private static String BUYER_FTP_URL = null;  //NOPMD 해당항목 반드시 필요한 내용임
	private static int BUYER_FTP_PORT = 0;                 //NOPMD 해당항목 반드시 필요한 내용임
	private final static String BUYER_FTP_ID = "kepftp";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String BUYER_FTP_PW = "$2vmffot!";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String[] BUYER_SRC_PATH = {"/data02/KEP/SEND/ERROR/", "/data02/KEP/SEND/"};
	
	/* KEP FTP SERVER */
	private final static String KEP_FTP_URL = "10.20.103.11";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static int KEP_FTP_PORT = 51022;                 //NOPMD 해당항목 반드시 필요한 내용임
	private final static String KEP_FTP_ID = "eai";  //NOPMD 해당항목 반드시 필요한 내용임
	private final static String KEP_FTP_PW = "eai8914!";  //NOPMD 해당항목 반드시 필요한 내용임 
	 
	private int count = 0;
	
	private FTPClient cftp = null;
	protected ChannelSftp cSftp = null;
	
	private DButil dbutil = null;
	
	private boolean canAccess = false;
	
	public void connectFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cftp = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);

		if(this.cftp == null){
			log.error("서버 로그인 실패");
			dbutil.updateConnectionInfo(count+1, "DAEW");
			if(count >= 5){
				dbutil.sendWarningEmail();
			}
			throw new Exception("FTP 접속실패.");
		}else{
			log.debug("서버 로그인 성공");
			dbutil.updateConnectionInfo(1, "DAEW");
		}
	}
	
	public void init(){
		
		dbutil = new DButil();
		
		String[] connections = dbutil.selectConnectionInfo("DAEW");
		
		BUYER_FTP_URL = connections[0]; // URL
		BUYER_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= 5) canAccess = true;
		else canAccess = false;
				
		log.debug("BUYER_FTP_URL : "+BUYER_FTP_URL);
		log.debug("BUYER_FTP_PORT : "+BUYER_FTP_PORT);
		log.debug("count : "+count);
	}
	
	public void disconnectFTP(FTPClient client) throws Exception{
		
		if(cftp != null){
			try {
				FtpSUtils.ftpLogOut(client);
			} catch (Exception e) {
				log.error("sFtp 연결해제 오류");
				throw new Exception("sFtp 연결해제 오류");
			}
		}
	}
	
	/**
	 * 미즈미 SFTP서버에서 다운받을 파일리스트 생성 
	 * @param cftp SFTP 접속 ChannelSftp
     * @param dir 검색 대상 디렉토리
     * @return ArrayList<String> 파일리스트
     * @throws Exception 
	 */
	public ArrayList<String> getFileListFromBuyerServer(FTPClient cftp, String dir) throws Exception{
		ArrayList<String> fileList	= new ArrayList<String>();

		FTPFile[] fList = this.cftp.listFiles(dir);
		
		for(FTPFile ff : fList ) {
			if ( ff.isFile() == true ) {
				log.debug("File Name : "+ff.getName());
				fileList.add(ff.getName());	
			}
		}
		
		Collections.sort(fileList);
		
		return fileList;
	}
	
	public ArrayList<String> getFileListFromBuyerServer(String dir) throws Exception{
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
			fileList = getFileListFromBuyerServer(cftp, srcPath);
		} catch (Exception e) {
			throw new Exception("getFileList 에러");
		}
		
		for(int i = 0 ; i < fileList.size() ; i++) {
			log.debug("DAEW srcPath : " + srcPath);
			log.debug("DAEW fileList.get("+i+") : " + fileList.get(i));
			// dat파일 다운
			File file = FtpSUtils.ftpDownloadFile(this.cftp, srcPath + fileList.get(i), targetPath + "/" + fileList.get(i));
			
			if ( file != null ) {
				// 다운 후 파일 원격디렉토리에서 삭제.
				FtpSUtils.ftpDeleteFile(this.cftp, srcPath + fileList.get(i));
			} else {
				fileList.remove(i);
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
		boolean isMove = false;
		
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
   		
		FtpSUtils.ftpDownloadFileInDirAndMove(fClient, srcPath, targetPath, srcPath+"BACK/");
   		
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
			File srcFile = new File(srcPath+fileList.get(i)); // 데이터 파일
			boolean bUpRtn = FtpSUtils.ftpUploadFile(this.cftp, srcFile, targetPath);
			
			if (bUpRtn == true) {
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
	
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error(ftp_url +"/"+ ftp_id + "서버 로그인 실패");
			System.out.println(ftp_url +"/"+ ftp_id + "서버 로그인 실패");
			
			throw new Exception(ftp_url + "/"+ ftp_id + "SFTP 접속실패.");
		}else{
			log.debug(ftp_url + "/"+ ftp_id +"서버 로그인 성공");
			System.out.println(ftp_url + "/"+ ftp_id +"서버 로그인 성공");
		}
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
	
	public void recvFromBuyerToKEP(String srcPath, String targetPath, String srcBackupPath) throws Exception{
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
		
		fileList = getFileListFromBuyerServer(srcPath);
		
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
	
	public void execute() {
		this.init();
		log.debug("DAEW canAccess : " + canAccess);
		if(canAccess){
			try {
				dbutil.updateLastUpdateDateInfo("DAEW");
				/**
				 * DAEW 로직 
				 * 1. 유한킴벌리 -> 34 -> 11
				 * 2. 11 -> 34 -> 유한킴벌리
				 */
				
//				log.info("[FTP 연결시도...]");
//				this.connectFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID, BUYER_FTP_PW);
//
//				/* 데이터 수신 /Outbound/ -> 34번 */
//				log.info("[DOWNLOAD BUYER->34] ID : "+BUYER_FTP_ID+" , DIR : "+BUYER_SRC_PATH[0]);
//				this.recvFromBuyerToKEP(BUYER_SRC_PATH[0], KEP_RECV_PATH);
//
//				log.info("[FTP 연결해제 시도]");
//				this.disconnectFTP(this.cftp);
//
//				/* 데이터 수신 34번 서버 -> 18(FTP)번 서버 */
//				log.info("[UPLOAD 34->18] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
//				this.recvFromWinsvToFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				/* 데이터 송신 18(FTP)번 서버 -> 34번 서버 */
//				log.info("[DOWNLOAD 18->34] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
//				this.sendToWinsvFromFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_FTP_SEND_PATH, KEP_SEND_PATH);
				
				System.out.println("sftp 연결시도");
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW);
				
				System.out.println("[DOWNLOAD 103.11-> 101.169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				log.info("[DOWNLOAD 103.11->101.169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				recvFromBuyerToKEP(KEP_FTP_SEND_PATH, KEP_SEND_PATH, KEP_FTP_SEND_PATH+"BACK/");

				System.out.println("sftp 연결해제");
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
				
				
				log.info("[FTP 연결시도...]");
				this.connectFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID, BUYER_FTP_PW);
				
				/* 데이터 송신 34번 서버 -> BUYER SR */
				log.info("[UPLOAD 34->BUYER] ID : "+BUYER_FTP_ID+" , DIR : "+BUYER_SRC_PATH[1]);
				this.sendToBuyerFromKEP(BUYER_FTP_ID, KEP_SEND_PATH, BUYER_SRC_PATH[1]);
				
				log.info("[FTP 연결해제 시도]");
				this.disconnectFTP(this.cftp);
			
			} catch (Exception e) {
				log.error(e);
			}
		}
		
		return;
	}
}
