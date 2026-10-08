package client;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
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
/**
 * @author jiwon
 *
 */
public class LSAT_FTP {
	
	private static Logger log	= Logger.getLogger(LSAT_FTP.class.getName());
	
	/* 103.11 DOWNLOAD PATH */
	private final static String KEP_FTP_RECV_PATH = "/export/ftp/pub_lsat/RECV/";
	private final static String KEP_FTP_SEND_PATH = "/export/ftp/pub_lsat/SEND/";
	
	/* 169 DOWNLOAD PATH */	
	private final static String KEP_RECV_PATH	= "D:/SFTPClient/LSAT/RECV/";
	private final static String KEP_SEND_PATH	= "D:/SFTPClient/LSAT/SEND/";

	/* LSAT FTP SERVER */
	private static String BUYER_FTP_URL = null;  
	private static int BUYER_FTP_PORT = 0;                
	private final static String BUYER_FTP_ID = "lsasftp";  
	private final static String BUYER_FTP_PW = "Lsamro&31";
	private final static String[] BUYER_SRC_PATH = {"/D:/SAPKEP/PR/", "/D:/SAPKEP/PR/RE/"};
	
	/* KEP FTP SERVER */
	private final static String KEP_FTP_URL = "10.20.103.11";  
	private final static int KEP_FTP_PORT = 51022;               
	private final static String KEP_FTP_ID = "eai";  
	private final static String KEP_FTP_PW = "eai8914!";  
	 
	private int count = 0;	
	private FTPClient cftp = null;
	private ChannelSftp cSftp = null;	
	private DButil dbutil = null;	
	private boolean canAccess = false;
	
	public void init(){
		
		dbutil = new DButil();
		
		String[] connections = dbutil.selectConnectionInfo("LSAT");
		
		BUYER_FTP_URL = connections[0]; // URL
		BUYER_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= 5) canAccess = true;
		else canAccess = false;
				
		log.debug("BUYER_FTP_URL : "+BUYER_FTP_URL);
		log.debug("BUYER_FTP_PORT : "+BUYER_FTP_PORT);
		log.debug("count : "+count);
	}	
	
	/**
	 * LSAT SFTP서버에서 다운받을 파일리스트 생성 
	 * @param cftp SFTP 접속 ChannelSftp
     * @param dir 검색 대상 디렉토리
     * @return ArrayList<String> 파일리스트
     * @throws Exception 
	 */
	public ArrayList<String> getFileListFromBuyerServer(String dir) throws Exception{
		/*
		 * 가져갈 파일 목록 생성
		 */
		ArrayList<String> fileList	= new ArrayList<String>();
		Vector<ChannelSftp.LsEntry> dataList = null;
		this.cSftp.cd(dir);		
		dataList = this.cSftp.ls("*");
		
		for (LsEntry lsEntry : dataList) {			
			if (lsEntry.getFilename().contains("DAESUNG_PO_SE")) {				
				log.debug("dataList getname : "+lsEntry.getFilename());	
				fileList.add(lsEntry.getFilename());
			}
		}
		Collections.sort(fileList);
//		this.cSftp.cd("/..");
		
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
	 * LSAT sFTP서버 -> KEP 중계서버 (169번 서버) 파일 전송
	 * @param sftp_url
	 * @param sftp_port
	 * @param sftp_id
	 * @param sftp_pw
	 * @param ssrcPath
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
			fileList = getFileListFromBuyerServer(srcPath);			
		} catch (Exception e) {
			throw new Exception("getFileList 에러");
		}
		
		for(int i = 0 ; i < fileList.size() ; i++) {
			// 파일 다운
			SFTPUtil.sFtpDownloadFile(srcPath, fileList.get(i), targetPath);
			// 다운 후 파일 원격디렉토리에서 삭제.
			SFTPUtil.sftpDeleteFile(srcPath, fileList.get(i)); // 테스트 진행 중, 삭제 X
			// Target Backup 폴더 이동.
//			File backFile	= new File(targetPath+"/"+fileList.get(i));
//			SFTPUtil.sFtpUploadFile(srcBackupPath, backFile);
		}
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
				//파일 경로 만들기
				SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmsssss");
				Date time = new Date();
				String ntime = dFormat.format(time);
				
				String yyyy = ntime.substring(0,4);
				String mm = ntime.substring(4,6);
				String dd = ntime.substring(6,8);
				
				String bDir = srcPath + "/BACK/"+yyyy+"/"+mm+"/"+dd +"/";
				String sName = srcPath + "/" + srcFile.getName();
				String bName = srcPath + "/BACK/"+yyyy+"/"+mm+"/"+dd +"/" + srcFile.getName() + "." + ntime;
				
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
				
				try {
					log.info("move : " + sName + " ==> " +  bName);
					isMove = this.move(sName, bName);
					if(!isMove) {
						log.info("[DOWNLOAD 34-> 103.11]이후 파일 renameTo 실패 copy,delete 시도 파일이름 : " + sName);
						
					}
				} catch (Exception e) {
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
	
	/**
	 * KEP 중계서버(169) -> LSAT SFTP서버 파일 전송 
	 * @param sftp_url
     * @param sftp_port
     * @param sftp_id
     * @param sftp_pw
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
			File backDir = new File(srcPath+"BACK/");
			if(!backDir.isDirectory()){ 
				backDir.mkdir();
			}
		}
			
		
		/* 파일리스트의 파일 전송 */
		for(int i = 0 ; i < fileList.size() ; i++) {
			
			/* 지역 오픈 */			
			isMove = true;
			File srcFile = new File(srcPath+fileList.get(i)); // 데이터 파일			
			SFTPUtil.sFtpUploadFile(targetPath, srcFile);			
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
		}
		fileList.clear();
	}
	
	public boolean move(String sFInfo, String dFInfo)  throws IOException {
		
		File f = new File(sFInfo);
		log.debug("move : " + sFInfo + " ==> " + dFInfo);
		
		boolean isSuccess = f.renameTo(new File(dFInfo));
		log.debug("isSuccess = " + isSuccess + "["+sFInfo+" => "+dFInfo+"]");
		return isSuccess;
	}
	
	/**
	 * 중계 서버(169)에서 보낼 파일 리스트 생성 
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
	
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error("서버 로그인 실패");
			dbutil.updateConnectionInfo(count+1, "LSAT");
			if(count >= 5){
				dbutil.sendWarningEmail();
			}
			throw new Exception("FTP 접속실패.");
		}else{
			log.debug("서버 로그인 성공");
			dbutil.updateConnectionInfo(1, "LSAT");
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
	
	public void execute() {
		this.init();
		log.debug("LSAT canAccess : " + canAccess);
		if(canAccess){
			try {
				dbutil.updateLastUpdateDateInfo("LSAT");
				/**
				 * lsat 로직 
				 * 1. lsat -> 169 -> 103.11
				 * 2. 103.11 -> 169 -> lsat
				 */
				
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID, BUYER_FTP_PW);

				/* 파일 수신 lsat -> 169 */
				log.info("[DOWNLOAD LSAT -> 169] ID : "+BUYER_FTP_ID+" , DIR : "+BUYER_SRC_PATH[0]);
				this.recvFromBuyerToKEP(BUYER_SRC_PATH[0], KEP_RECV_PATH);

				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
				
				System.out.println("sftp 연결시도");
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW);
				
				/* 파일 송신 103.11 -> 169 */
				System.out.println("[DOWNLOAD 103.11 -> 169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				log.info("[DOWNLOAD 103.11 -> 169] ID : "+KEP_FTP_ID+" , DIR : "+KEP_SEND_PATH);
				recvFromBuyerToKEP(KEP_FTP_SEND_PATH, KEP_SEND_PATH, KEP_FTP_SEND_PATH+"BACK/");
				
				/* 파일 수신 169 -> 103.11 */	
				System.out.println("[DOWNLOAD 169 -> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				log.info("[DOWNLOAD 169 -> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				sendToTargetFromKEP(KEP_FTP_ID, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				System.out.println("sftp 연결해제");
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();				
				
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(BUYER_FTP_URL, BUYER_FTP_PORT, BUYER_FTP_ID, BUYER_FTP_PW);
				
				/* 파일 송신 169 -> LSAT */
				log.info("[UPLOAD 169 -> LSAT] ID : "+BUYER_FTP_ID+" , DIR : "+BUYER_SRC_PATH[1]);
				this.sendToBuyerFromKEP(BUYER_FTP_ID, KEP_SEND_PATH, BUYER_SRC_PATH[1]);
				
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
			
			} catch (Exception e) {
				log.error(e);
			}
		}
		
		return;
	}
}
