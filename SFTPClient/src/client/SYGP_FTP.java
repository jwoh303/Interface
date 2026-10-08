package client;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPSClient;
import org.apache.log4j.Logger;

import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.ChannelSftp.LsEntry;
import com.koreab2b.mro.util.CommonAwsS3;

import common.CommonProperty;
import common.CommonUtil;
import common.DButil;
import utils.FtpSUtils;
import utils.SFTPUtil;

@SuppressWarnings("unused")
public class SYGP_FTP {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	/* TARGET UPLOAD PATH */
	private final  String KEP_FTP_RECV_PATH = "/RECV/";
	private final  String KEP_FTP_SEND_PATH = "/SEND/";
	
	/* TEMP DOWNLOAD PATH */
	private String KEP_SEND_PATH	= "D:/SFTPClient/SYGP/SEND/";
	private String KEP_RECV_PATH	= "D:/SFTPClient/SYGP/RECV/";

	private String KEP_SEND_PATH_dev	= "D:/SFTPClient_dev/SYGP/SEND/";
	private String KEP_RECV_PATH_dev	= "D:/SFTPClient_dev/SYGP/RECV/";
	
	/* TARGET FTP SERVER */
	private  String TARGET_FTP_URL = null;  
	private  int TARGET_FTP_PORT = 0;           
//	private  String TARGET_FTP_ID = "SY\\Server_Services"; 
//	private  String TARGET_FTP_PW = "$1Samyang#";  
	private  String TARGET_FTP_ID = "Server_Services_MRO"; 
	private  String TARGET_FTP_PW = "!1xkqtm9122$";  // !1xkqtm9122$
	private  String TARGET_SRC_PATH =  "/Chem/"; 

	private String KEP_MSDS_PATH = "ITEM_IMAGE/MSDS/";
	
//	private String KEP_SERVER_URL = "10.100.101.11";
//	private int KEP_SERVER_PORT = 41022;
//	private String KEP_SERVER_ID = "if_db1";
//	private String KEP_SERVER_PW = "kep67240";
					
	
	private ChannelSftp cSftp = null;
	private FTPClient ftp = null;
	private FTPSClient ftps = null;
	private DButil dbutil = null;
	
	private int count = 0;
	private int limitCount = 3; 
	
	private boolean canAccess = false;
	private String [][] connections= null;
	private int fetch = 0;
	
	public void execute() {
		
		this.init();
		
		if (this.canAccess) {
			try {
				
				if ( "0".equals(CommonProperty.getDB_CONN()) ) {
					this.KEP_SEND_PATH = this.KEP_SEND_PATH_dev;
					this.KEP_RECV_PATH = this.KEP_RECV_PATH_dev;
				}
				
				dbutil.updateLastUpdateDateInfo("SYGP");
				
				connections = dbutil.selectConnectionInfo_sygp();
			    fetch = connections.length;
				
//			    log.info("[SFTP 11번 연결 시도]");
//				this.connectSFTP(KEP_SERVER_URL, KEP_SERVER_PORT, KEP_SERVER_ID, KEP_SERVER_PW);
				
//				log.info("[Cloud S3 -> 34] ID : "+KEP_SERVER_ID+" , DIR : "+KEP_SEND_PATH);
				ICOMATCH_Fetch(connections, fetch);
				
				log.info("[FTP TARGET 연결 시도]");				
				ftps = FtpSUtils.ftpSLogIn(TARGET_FTP_URL, TARGET_FTP_PORT, TARGET_FTP_ID, TARGET_FTP_PW);	// TO-BE : ftps jdk 1.8 필요.
				if(ftps == null)  {
					throw new Exception("TARGET 접속 에러");
				}
					
				log.info("[UPLOAD 34 -> TARGET] DIR : "+TARGET_SRC_PATH);
				this.sendToTargetFromKEP(KEP_SEND_PATH, TARGET_SRC_PATH);
				
//				ICOMTRXL_Fetch(connections,fetch,"2");
				
				dbutil.updateConnectionInfo(1, "SYGP");

				Map<String, String> pMap = new HashMap<String, String>();
				pMap.put("COM_CODE", 	"SYGP");
				pMap.put("TASK_GUBUN", 	"ETC");
				pMap.put("IF_TYPE", 	"FTP-02-송신");
				pMap.put("TASK_ORDER", 	"2");
				
				dbutil.updateIfStatus(pMap);
				
			} catch (Exception e) {
				dbutil.updateConnectionInfo(count+1, "SYGP");
				if(count >= limitCount){
					if(ftp == null) {
						ICOMTRXL_Fetch(connections,fetch, "E");
					}
					dbutil.sendWarningEmailForSYGP();
				}
				e.printStackTrace();
				log.error("SYGP_FTP Error : " + CommonUtil.printStackTraceToString(e));
			} finally {
				log.info("[SFTP 11번 연결해제 시도]");
				try {
					this.disconnectSFTP();
					FtpSUtils.ftpSLogOut(ftps);	// TO-BE
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return;
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

	public void ICOMATCH_Fetch(String [][] connections, int fetch) throws Exception{
		
		for(int i=0;i<fetch ; i++) {
			
			ArrayList<String> rtnLst = new ArrayList<String>();		
			rtnLst = dbutil.selectInfo_sygp(connections, i);
			
//			ICOMTRXL_Fetch 호출 주석처리하고			
			String flag = "2";
			if(rtnLst.size() > 0) {
				try {
					for(int j=0; j<rtnLst.size(); j++ ) {
						fileCopyS3(KEP_MSDS_PATH,rtnLst.get(j),KEP_SEND_PATH);
					}			
				} catch (Exception e) {
					flag = "E";
					e.printStackTrace();
					throw new Exception("11번 -> 34번 파일 전송에 실패하였습니다.");
				}
			}else {
				flag = "E";
			}			
			dbutil.updateInfo_sygp(connections, i, flag);
			
		}
		
	}
	
	public void ICOMTRXL_Fetch(String [][] connections,int fetch,String check) {
		for(int i=0;i<fetch ; i++) {
			try {
				dbutil.updateInfo_sygp(connections, i,check);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	

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
		
		String[] connections = dbutil.selectConnectionInfo("SYGP");
		
		this.TARGET_FTP_URL = connections[0]; // URL
		this.TARGET_FTP_PORT = Integer.parseInt(connections[1]); // PORT
		count = Integer.parseInt(connections[2]); // count
		
		if(count <= limitCount) this.canAccess = true;
		else this.canAccess = false;
		
		log.debug("TARGET_FTP_URL : "+this.TARGET_FTP_URL);
		log.debug("TARGET_FTP_PORT : "+this.TARGET_FTP_PORT);
		log.debug("count : "+count);
		
	}
	
	public void fileCopy(String srcPath, String srcFileName, String destPath) throws Exception{
    	/*2안*/
    	
    	InputStream in = null;
        FileOutputStream out = null;

        try {

        	cSftp.cd(srcPath);
            in = cSftp.get(srcFileName);            
            
            out = new FileOutputStream(new File(destPath+srcFileName));
            	
            int i;
            while ((i = in.read()) != -1) {
                out.write(i);
            }
            
            cSftp.cd("/..");
        } catch (Exception e) {
        	 if(out == null) {
        		 log.info("[11번 -> 34번  파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 실패");
        		 throw new Exception("11번 -> 34번 다운로드 에러 (null 에러)");
             }
        	log.error("11번 -> 34번 다운로드 에러");
            throw new Exception("11번 -> 34번 다운로드 에러");

        } finally {

            try {
                in.close();
                out.close();
            } catch (IOException e) {
            	log.error("파일 클로즈 에러");
                e.printStackTrace();
            }
            
        }
        log.info("[11번 -> 34번  파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
    }


	public void fileCopy2(String srcPath, String srcFileName, String destPath) throws Exception{
    	/*2안*/
    	
    	InputStream in = null;
        FileOutputStream out = null;

        try {

//        	cSftp.cd(srcPath);
//            in = cSftp.get(srcFileName);            
        	in = new FileInputStream(srcPath+srcFileName);
            out = new FileOutputStream(new File(destPath+srcFileName));
            	
            int i;
            while ((i = in.read()) != -1) {
                out.write(i);
            }
        } catch (Exception e) {
        	 if(out == null) {
        		 log.info("[11번 -> 34번  파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 실패");
        		 throw new Exception("11번 -> 34번 다운로드 에러 (null 에러)");
             }
        	log.error("11번 -> 34번 다운로드 에러");
            throw new Exception("11번 -> 34번 다운로드 에러");

        } finally {

            try {
                in.close();
                out.close();
            } catch (IOException e) {
            	log.error("파일 클로즈 에러");
                e.printStackTrace();
            }
            
        }
        log.info("[11번 -> 34번  파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
    }
	
	
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{

		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error("서버 로그인 실패");

		throw new Exception("FTP 접속실패.");
		}else{
			log.debug("서버 로그인 성공");
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
					
				File datFile = new File(srcPath+fileList.get(i));  // 데이터 파일
				log.debug("Upload File : " + srcPath+fileList.get(i) + "\n ==> " + targetPath);
			
				FtpSUtils.ftpSUploadFile(ftps , datFile, targetPath);	// TO-BE
						
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
	
	public void fileCopyS3(String srcPath, String srcFileName, String destPath) throws Exception{
		
		int data = 0;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		try {
			// AWS 파일 유무 검증 단계 추가 개발 여기서 하면 될 듯
			if (CommonAwsS3.doesFileExists(srcPath + srcFileName)) {
				File srcFile = CommonAwsS3.download(srcPath + srcFileName, srcFileName);
				File desFile = new File(destPath + srcFileName);
				log.info("[AWS 파일 다운 완료] : "+ srcPath + srcFileName);
				fis = new FileInputStream(srcFile);
				fos = new FileOutputStream(desFile);
				
				int readBuffer = 0;
				byte[] buffer = new byte[512];
				while ( (readBuffer = fis.read(buffer)) != -1 ) {
					fos.write(buffer, 0, readBuffer);
				}
			} else {
				log.error("fileCopyS3 : File Not Found [" +srcPath + srcFileName + "]");
			}
		} catch (Exception e) {
			log.error("fileCopyS3 : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				fis.close();
				fos.close();	
			} catch (Exception e2) {}
		}
        log.info("[S3 -> 34번  파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
	}
}
