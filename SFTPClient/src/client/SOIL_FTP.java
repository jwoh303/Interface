package client;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPSClient;
import org.apache.log4j.Logger;

import com.jcraft.jsch.ChannelSftp;

import common.CommonProperty;
import common.CommonUtil;
import common.DButil;
import utils.FtpSUtils;
import utils.SFTPUtil;

@SuppressWarnings("unused")
public class SOIL_FTP {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	/* TARGET UPLOAD PATH */
	private final static String KEP_FTP_RECV_PATH = "/export/ftp/pub_soil/RECV/";
	private final static String KEP_FTP_SEND_PATH = "/export/ftp/pub_soil/SEND/";
	
	/* TEMP DOWNLOAD PATH */
	private String KEP_SEND_PATH	= "D:/SFTPClient/SOIL/SEND/";
	private String KEP_RECV_PATH	= "D:/SFTPClient/SOIL/RECV/";

	private String KEP_SEND_PATH_dev	= "D:/SFTPClient_dev/SOIL/SEND/";
	private String KEP_RECV_PATH_dev	= "D:/SFTPClient_dev/SOIL/RECV/";
	
	/* TARGET FTP SERVER */
	private  String TARGET_FTP_URL = null;
	private  int TARGET_FTP_PORT = 0;           
	private  String TARGET_FTP_ID = "MRO"; 
	private  String TARGET_FTP_PW = "MroK2p123!#";  
	private  String TARGET_SRC_PATH =  "/"; 

	/* KEP FTP SERVER */
	private final  String KEP_FTP_URL = "10.20.103.11";  //NOPMD 해당항목 반드시 필요한 내용임
	private final  int KEP_FTP_PORT = 51022;                 //NOPMD 해당항목 반드시 필요한 내용임
	private final  String KEP_FTP_ID = "eai";  //NOPMD 해당항목 반드시 필요한 내용임
	private final  String KEP_FTP_PW = "eai8914!";  //NOPMD 해당항목 반드시 필요한 내용임
	
	private ChannelSftp cSftp = null;
	private FTPClient ftp = null;
	private FTPSClient ftps = null;
	private DButil dbutil = null;
	
	private int count = 0;
	private int limitCount = 3; 
	
	private boolean canAccess = false;
	private String [] connections= null;
	private int fetch = 0;
	
	public void execute() {
		
		this.init();
		
		if (this.canAccess) {
			try {
				
				if ( "0".equals(CommonProperty.getDB_CONN()) ) {
					this.KEP_SEND_PATH = this.KEP_SEND_PATH_dev;
					this.KEP_RECV_PATH = this.KEP_RECV_PATH_dev;
				}
				
				dbutil.updateLastUpdateDateInfo("SOIL");
				
				connections = dbutil.selectConnectionInfo("SOIL");
				
				log.info("[FTP TARGET 연결 시도]");				
				ftp = FtpSUtils.ftpLogin(TARGET_FTP_URL, TARGET_FTP_PORT, TARGET_FTP_ID, TARGET_FTP_PW);	// ftp
				
				if(ftp == null)  {
					throw new Exception("TARGET 접속 에러");
				}

				log.info("[DOWNLOAD TARGET -> 34] DIR : "+ TARGET_SRC_PATH);
				this.recvFromTargetToKEP(TARGET_SRC_PATH, KEP_RECV_PATH, "");
				
				/* 데이터 수신 34번 서버 -> 18(FTP)번 서버 */
//				log.info("[UPLOAD 34->18] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
//				this.recvFromWinsvToFtpsv(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				System.out.println("sftp 연결시도");
				log.info("[SFTP 연결시도...]");
				this.connectSFTP(KEP_FTP_URL, KEP_FTP_PORT, KEP_FTP_ID, KEP_FTP_PW);
				
				System.out.println("[DOWNLOAD 34-> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				log.info("[DOWNLOAD 34-> 103.11] ID : "+KEP_FTP_ID+" , DIR : "+KEP_FTP_RECV_PATH);
				sendToTargetFromKEP(KEP_FTP_ID, KEP_RECV_PATH, KEP_FTP_RECV_PATH);
				
				System.out.println("sftp 연결해제");
				log.info("[SFTP 연결해제 시도]");
				this.disconnectSFTP();
				
				
				dbutil.updateConnectionInfo(1, "SOIL");
				
			} catch (Exception e) {
				dbutil.updateConnectionInfo(count+1, "SOIL");
				if(count >= limitCount){ dbutil.sendWarningEmailForSOIL(); }
							
				e.printStackTrace();
				log.error("SOIL_FTP Error : " + CommonUtil.printStackTraceToString(e));
			} finally {
				log.info("[FTP 11번 연결해제 시도]");
				try {
					this.ftp.disconnect();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return;
	}
	
	public ArrayList<String> getFileListFromKEPServer2(String srcDir, String filterStr) throws Exception{
		
		/* 파일리스트 생성 */
		ArrayList<String> fileList	= new ArrayList<String>();
		
		System.out.println("srcDir : " + srcDir);
		
		File dir	= new File(srcDir);
		File[] fList	= dir.listFiles();
		
		if (fList != null && fList.length > 0) {
			for(int i = 0 ; i < fList.length ; i++) {
				if ( fList[i].getName().indexOf(".csv") > -1 ) {
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
			
       	File fSaveDirectory = new File(targetPath);
       	if(!fSaveDirectory.isDirectory()){
       		fSaveDirectory.mkdirs();
       	}
       	
       	fClient = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);
   		if(fClient == null) {
   			log.error("FTP 접속 실패");
			throw new Exception("FTP 접속 실패하였습니다. 배치를 종료합니다.");
		}
   		
		FtpSUtils.ftpDownloadFileInDirAndMove(fClient, srcPath, targetPath, srcPath+"BACK/");
		
		
		if(fClient != null) {
			FtpSUtils.ftpLogOut(fClient);
			fClient = null;
		}
	}
	
	public void init(){
		dbutil = new DButil();
		
		String[] connections = dbutil.selectConnectionInfo("SOIL");
		
		this.TARGET_FTP_URL = connections[0]; // URL
		this.TARGET_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= limitCount) this.canAccess = true;
		else this.canAccess = false;
		
		log.debug("TARGET_FTP_URL : "+this.TARGET_FTP_URL);
		log.debug("TARGET_FTP_PORT : "+this.TARGET_FTP_PORT);
		log.debug("count : "+count);
		
	}	
	/**
	 * TARGET sFTP서버 -> KEP 중계서버 (34번 장비) 파일 전송
	 * @param srcPath
	 * @param targetPath
	 * @return 
	 * @throws Exception
	 */

	public ArrayList<String> getFileListFromTargetServer(String dir) throws Exception{
		
		ArrayList<String> fileList	= new ArrayList<String>();
		
		FTPFile[] fList = this.ftp.listFiles(dir);
		
		for(FTPFile ff : fList ) {
			// TODO : 파일 확장자 체크, 용량 체크 추가.
			log.debug("File Name : "+ff.getName());
			if ( ff.getName().indexOf(".csv") > -1 ) {
				fileList.add(ff.getName());	
			}
		}
		
		Collections.sort(fileList);
		
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
					
				File datFile = new File(srcPath+fileList.get(i));  // 데이터 파일
				log.debug("Upload File : " + srcPath+fileList.get(i) + "\n ==> " + targetPath);
			
//				FtpSUtils.ftpUploadFile(ftp , datFile, targetPath); 
				FtpSUtils.ftpSUploadFile(ftps , datFile, targetPath);
						
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

	public void recvFromWinsvToFtpsv(String ftp_url, int ftp_port, String ftp_id, String ftp_pw, String srcPath, String targetPath) throws Exception{
		
		FTPClient fClient = null;
        File folder = new File(srcPath);
        ArrayList<String> fileList = new ArrayList<String>(Arrays.asList(folder.list()));
                
		
		fClient = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);
			
		if(fClient == null) {
			log.error("FTP 접속 실패");
			throw new Exception("FTP 접속 실패하였습니다.");
		}
		
		for(int i = 0 ; i < fileList.size() ; i++) {

			boolean isSend = false;
			boolean isMove = true;
			boolean isDelete = false;
			
			//log.debug("Send file... : " + srcPath + fileList.get(i));
			File srcFile	= new File(srcPath + fileList.get(i));
			
			if(srcFile.isFile()){
				
				long fSize = srcFile.length();
				if (fSize > 0) {
					isSend	= FtpSUtils.ftpUploadFile(fClient, srcFile, targetPath);
					log.debug("Send Result... : " + isSend);	
				} else {
					isSend	= false;
					isDelete = true;
					
					srcFile.delete();
				}
				
				if (isSend) {
					
					File backDir = new File(srcPath+"BACK/");
					if(!backDir.isDirectory()){ 
						backDir.mkdir();
					}
					
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
				} else if (!isSend & isDelete) {
					log.error("0 Byte 파일 삭제했습니다. : " + fileList.get(i));
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

	public void recvFromTargetToKEP(String srcPath, String targetPath, String srcBackupPath) throws Exception{
				
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
			FtpSUtils.ftpDownloadFile(this.ftp, fileList.get(i), targetPath + "/" + fileList.get(i));
			// 다운 후 파일 원격디렉토리에서 삭제.
			FtpSUtils.ftpDeleteFile(this.ftp, fileList.get(i));
		}
	}	
}
