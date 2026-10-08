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

import common.CommonUtil;
import common.DButil;
import utils.FtpSUtils;
import utils.SFTPUtil;

public class IYNG_PARCEL {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	/* TARGET UPLOAD PATH */
	private final static String KEP_FTP_RECV_PATH = "/export/ftp/pub_iyng/RECV/";
	private final static String KEP_FTP_SEND_PATH = "/export/ftp/pub_iyng/SEND/";
	
	/* TEMP DOWNLOAD PATH */	
	private final  String KEP_SEND_PATH	= "D:/SFTPClient/IYNG/SEND/";
	private final  String KEP_RECV_PATH	= "D:/SFTPClient/IYNG/RECV/";
	
	/* TARGET FTP SERVER */
	private  String TARGET_FTP_URL = null;  //NOPMD 해당항목 반드시 필요한 내용임
	private  int TARGET_FTP_PORT = 0;                 //NOPMD 해당항목 반드시 필요한 내용임
	private  String TARGET_FTP_ID = "koreab2b";  //NOPMD 해당항목 반드시 필요한 내용임
	private  String TARGET_FTP_PW = "zhfldkdl1912!@";  //NOPMD 해당항목 반드시 필요한 내용임
	private  String[] TARGET_SRC_PATH = {"/koreab2b/POD/PUT","/koreab2b/POD/PUT_MOVE", "/koreab2b/HAWB/PUT"}; // 배송조회, 배송조회 백업, 
	
	/* KEP FTP SERVER */
	private final  String KEP_FTP_URL = "10.20.103.11";  //NOPMD 해당항목 반드시 필요한 내용임
	private final  int KEP_FTP_PORT = 51022;                 //NOPMD 해당항목 반드시 필요한 내용임
	private final  String KEP_FTP_ID = "eai";  //NOPMD 해당항목 반드시 필요한 내용임
	private final  String KEP_FTP_PW = "eai8914!";  //NOPMD 해당항목 반드시 필요한 내용임
	
	private ChannelSftp cSftp = null;
	
	private DButil dbutil = null;
	
	private int count = 0;
	private int limitCount = 3; // 메일 알림. 
	
	private boolean canAccess = false;
	
	public void execute() {
		
		this.init();
		
		log.debug("IYNG canAccess : " + canAccess);
		
		if (this.canAccess) {
			try {
				dbutil.updateLastUpdateDateInfo("IYNG");
				
//				log.info("[DOWNLOAD 18->34] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
//				this.sendToWinsvFromFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_FTP_SEND_PATH, KEP_SEND_PATH);

				System.out.println("sftp 연결시도");
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW);
				
				System.out.println("[DOWNLOAD 103.11-> 101.169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				log.info("[DOWNLOAD 103.11-> 101.169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				recvFromBuyerToKEP(KEP_FTP_SEND_PATH, KEP_SEND_PATH, KEP_FTP_SEND_PATH+"BACK/");

				System.out.println("sftp 연결해제");
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
				
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(TARGET_FTP_URL, TARGET_FTP_PORT, TARGET_FTP_ID, TARGET_FTP_PW);

				log.info("[UPLOAD 34 -> TARGET] DIR : "+TARGET_SRC_PATH[2]);
				this.sendToTargetFromKEP(KEP_SEND_PATH, TARGET_SRC_PATH[2]);
							
				log.info("[DOWNLOAD TARGET -> 34] DIR : "+TARGET_SRC_PATH[0]);
				this.recvFromTargetToKEP(TARGET_SRC_PATH[0], KEP_RECV_PATH, TARGET_SRC_PATH[1]);

				/* 데이터 수신 34번 서버 -> 18(FTP)번 서버 */
//				log.info("[UPLOAD 34->18] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
//				this.recvFromWinsvToFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
			} catch (Exception e) {
				e.printStackTrace();
				log.error("IYNG_PARCEL Error : " + CommonUtil.printStackTraceToString(e));
			} finally {
				log.info("[SFTP 연결해제 시도]");
				try {
					this.disconnectSFTP();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return;
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
		FtpSUtils.ftpDownloadFileInDirAndMove(fClient, srcPath, targetPath, srcPath+"BACK/");
		
		/* 전송 종료 */
		if(fClient != null) {
			FtpSUtils.ftpLogOut(fClient);
			fClient = null;
		}
	}
	
	public void init(){
		dbutil = new DButil();
		
		String[] connections = dbutil.selectConnectionInfo("IYNG");
		
		this.TARGET_FTP_URL = connections[0]; // URL
		this.TARGET_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= limitCount) this.canAccess = true;
		else this.canAccess = false;
				
		log.debug("TARGET_FTP_URL : "+this.TARGET_FTP_URL);
		log.debug("TARGET_FTP_PORT : "+this.TARGET_FTP_PORT);
		log.debug("count : "+count);
	}
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error("서버 로그인 실패");
			dbutil.updateConnectionInfo(count+1, "IYNG");
			if(count >= limitCount){
				dbutil.sendWarningEmailForIYPC();
			}
			throw new Exception("FTP 접속실패.");
		}else{
			log.debug("서버 로그인 성공");
			dbutil.updateConnectionInfo(1, "IYNG");
		}
		
	}
	
	public void disconnectSFTP() throws Exception{
		
		if(this.cSftp != null){
			try {
				SFTPUtil.ftpLogOut();
			} catch (Exception e) {
				log.error("sFtp 연결해제 오류");
				throw new Exception("sFtp 연결해제 오류");
			}
		}
	}
	/**
	 * TARGET sFTP서버 -> KEP 중계서버 (34번 장비) 파일 전송
	 * @param srcPath
	 * @param targetPath
	 * @return 
	 * @throws Exception
	 */
	public void recvFromTargetToKEP(String srcPath, String targetPath, String srcBackupPath) throws Exception{
				
		/* TARGET sFTP 서버 로그인 */
//		ChannelSftp cSftp = null;		

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
						
			// dat파일 다운
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
		 * txt파일 모두.
		 * 
		 */
		ArrayList<String> fileList	= new ArrayList<String>();
		Vector<ChannelSftp.LsEntry> dataList = null;
		
		
		this.cSftp.cd(dir);
		
		dataList = this.cSftp.ls("*");
		
		
		for (LsEntry lsEntry : dataList) {
			log.debug("dataList getname : "+lsEntry.getFilename());

			fileList.add(lsEntry.getFilename());
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
	 * KEP 중계서버(34번 장비) -> TARGET sFTP서버 파일 전송 
     * @param srcPath
     * @param targetPath
     * @return 
     * @throws Exception 
	 */
	public void sendToTargetFromKEP(String srcPath, String targetPath) throws Exception{
		
//		/* TARGET FTP 서버 로그인 */
//		ChannelSftp cSftp = null;
		/* 파일리스트 생성 */
		ArrayList<String> fileList = null;
		
		String filter = null;

		boolean isMove = false;

			
		fileList = new ArrayList<String>();
		fileList = getFileListFromKEPServer(srcPath, filter);

		if (fileList.size() == 0) {
			log.debug("전송할 파일이 존재하지 않습니다.");
			return;
		} else {
			log.debug("전송대상 : "+fileList.size()+" 건");	
			
			File backDir = new File(srcPath+"BACK/");
			if(!backDir.isDirectory()){ 
				backDir.mkdir();
			}
			
			/* 파일리스트의 파일 전송 */
			for(int i = 0 ; i < fileList.size() ; i++) {
				
				/* 지역 오픈 */			
				isMove = true;
					
				File datFile = new File(srcPath+fileList.get(i)); // 데이터 파일
				log.debug("Upload File : " + srcPath+fileList.get(i) + "\n ==> " + targetPath);
				SFTPUtil.sFtpUploadFile(targetPath, datFile);
				File desFile	= new File(srcPath + "BACK/" + fileList.get(i));
				
				log.debug("move : " + datFile.getPath()+"/"+datFile.getName() + " ==> " +  desFile.getPath()+"/"+desFile.getName());
				try {
					FileUtils.moveFile(datFile,desFile);
				} catch (IOException e) {
					isMove = false;
				}
				
				if(!isMove) {
					log.error("파일 이동 실패했습니다. ["+srcPath +"BACK/" + fileList.get(i)+"]");
				}
			}
	
			fileList.clear();
		}
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
				if(fList[i].isFile()){
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
					
					File backDir = new File(srcPath+"BACK/");
					if(!backDir.isDirectory()){ 
						backDir.mkdir();
					}
					
					File desFile	= new File(srcPath + "BACK/" + fileList.get(i));
					isMove	= srcFile.renameTo(desFile);
					//log.debug("경로 : "+srcPath + "BACK/" + fileList.get(i));
					
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
}
