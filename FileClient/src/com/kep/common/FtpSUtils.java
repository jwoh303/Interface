package com.kep.common;
/** 
  * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 SDS에 있으며, 
  * SDS가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개,
  * 배포는 엄격히 금지되며, SDS의 지적재산권 침해에 해당됩니다.
  * (Copyright ⓒ 2005 SDS Co., Ltd. All Rights Reserved|Confidential)
  *-----------------------------------------------------------------------------
  * You are strictly prohibited to copy, disclose, distribute, modify, 
  * or use this program in part or as a whole without the prior written 
  * consent of SDS Co., Ltd. SDS Co., Ltd., owns the 
  * intellectual property rights in and to this program.
  * (Copyright ⓒ 2005 SDS Co., Ltd. All Rights Reserved|Confidential)
  *-----------------------------------------------------------------------------
  *
  * Class : FtpSUtils
  *
  * Comment	: FTPS 관련 구현
  *          
  *
  * History : 1.0.0(2016.05.17-정성훈) 최초작성
  *
  * @version 1.0.0
  * @author 정성훈
  *
  */ 

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPConnectionClosedException;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.net.ftp.FTPSClient;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;

public class FtpSUtils
{
	private static Logger log	= Logger.getLogger(FtpSUtils.class.getName());
    /**
     * FTPS 로그인
     * 
     * @param serverIp
     * @param FTPSId
     * @param FTPSPass
     * @return
     * @throws Exception
     */
	public static FTPSClient ftpSLogIn(String FTP_URL, int FTP_PORT, String FTP_ID, String FTP_PW) throws Exception{
			
		FTPSClient client = new FTPSClient("SSL");
		
		client.setControlEncoding("UTF-8"); 
	   
		// 접속
		log.debug("FTP Login Start......!");
		System.out.println(FTP_URL);
		System.out.println(FTP_PORT);
		
		client.connect(FTP_URL, FTP_PORT);
		log.debug("FTP Login Process    getReply......!");
		
		int reply = client.getReplyCode();
		if( !FTPReply.isPositiveCompletion(reply) ){
			ftpSLogOut(client);
			log.error("FTPS 서버 접속 실패");
			return null;
		} else {
			log.debug("FTPS 서버 접속 완료");
		}
		  
		client.execPBSZ(0);	// Set protection buffer size
		client.execPROT("P");	// Set data channel protection to private
		client.enterLocalPassiveMode();	// Enter local passive mode
		client.setFileType(FTP.BINARY_FILE_TYPE);
		
		// 로그인
		boolean isLogin = client.login(FTP_ID, FTP_PW);
		if( isLogin ){
			log.debug("로그인 성공");
		}else{
			log.error("로그인 불가!");
			client.disconnect();
			return null;
		}
		log.debug("FTP Login Success......!");
		
		return client;
	}
	
	public static FTPClient ftpLogin(String FTP_URL, int FTP_PORT, String FTP_ID, String FTP_PW) throws Exception {
		
		FTPClient client	= new FTPClient();
		
		client.setControlEncoding("UTF-8"); 
		
//		log.debug("FTP Login Start......!");
		client.connect(FTP_URL, FTP_PORT);
//		log.debug("FTP Login Process    getReply......!");
		int reply = client.getReplyCode();
		if( !FTPReply.isPositiveCompletion(reply) ){
			ftpLogOut(client);
			log.error("FTP 서버 접속 실패");
			return null;
		} else {
			log.debug("FTP 서버 접속 완료");
		}
		
		client.enterLocalPassiveMode();	// Enter local passive mode
		client.setFileType(FTP.BINARY_FILE_TYPE);	
		
		// 로그인
		boolean isLogin = client.login(FTP_ID, FTP_PW);
		if( isLogin ){
			log.debug("로그인 성공");
		}else{
			log.error("로그인 불가!");
			client.disconnect();
			return null;
		}
		
		return client;
	}
    
    /**
     * FTPS 종료
     * 
     * @param FTPSClient
     */
	public static void ftpSLogOut(FTPSClient client) throws Exception{
		
		try {
			/* check that control connection is working OK */
			client.noop();
			client.logout();
	    } catch (FTPConnectionClosedException e) {
			//logger.info("[ROOTTO] HOST=" + ftpHost + ":" + ftpPort + " USER=" + ftpUser + " - Server closed Connection."); //NOPMD
	    } finally {
	        if (client.isConnected()) {
	            try{client.disconnect();} catch (IOException ioe) {} //NOPMD
	        }
	    }
	}
    
    /**
     * FTP 종료
     * 
     * @param FTPSClient
     */
	public static void ftpLogOut(FTPClient client) throws Exception{
		
		try {
			/* check that control connection is working OK */
			client.noop();
			client.logout();
	    } catch (FTPConnectionClosedException e) {
			//logger.info("[ROOTTO] HOST=" + ftpHost + ":" + ftpPort + " USER=" + ftpUser + " - Server closed Connection."); //NOPMD
	    } finally {
	        if (client.isConnected()) {
	            try{client.disconnect();} catch (IOException ioe) {} //NOPMD
	        }
	    }
	}
    
    /**
     * FTP Download
     * 
     * @param FTPSClient
     * @param srcPathName
     * @param tgtPathName  /public/, C:\, C:\Test\
     * @throws Exception
     */
    public static void ftpSDownloadFileInDir(FTPSClient FTPSClient, String srcPathName, String tgtPathName) throws Exception 
    {
        FTPFile[] ftpfiles = FTPSClient.listFiles(srcPathName);
        if (ftpfiles != null)
        {
            for (int i = 0; i < ftpfiles.length; i++)
            {
                FTPFile file = ftpfiles[i];
                if (file.isFile())
                    ftpSDownloadFile(FTPSClient, srcPathName + file.getName(), tgtPathName + file.getName());                
            }
        }        
    }
    
    /**
     * FTP Download
     * 
     * @param FTPSClient
     * @param srcPathName
     * @param tgtPathName  /public/, C:\, C:\Test\
     * @throws Exception
     */
    public static void ftpDownloadFileInDir(FTPClient client, String srcPathName, String tgtPathName) throws Exception 
    {
        FTPFile[] ftpfiles = client.listFiles(srcPathName);
        if (ftpfiles != null)
        {
        	log.info("[FTP 파일 다운로드 ] 파일 SRC : "+srcPathName);
    		log.info("[FTP 파일 다운로드 ] 파일 TARGET : "+tgtPathName);
    		log.info("[FTP 파일 다운로드 ] 파일 크기 : "+ftpfiles.length);
            for (int i = 0; i < ftpfiles.length; i++)
            {
                FTPFile file = ftpfiles[i];
                if (file.isFile()) {
                    ftpDownloadFile(client, srcPathName + file.getName(), tgtPathName + file.getName());
                    //ftpDeleteFile(client, srcPathName + file.getName());
                }              
            }
        }        
    }
    
    /**
     * FTP Download
     * 
     * @param FTPSClient
     * @param srcFilePathName 서버에서 다운로드할 경로를 포함한 파일명
     * @param tgtFilePathName 로컬에 저장될 경로를 포함한 파일명
     * @return
     * @throws Exception
     */
    public static File ftpSDownloadFile(FTPSClient FTPSClient, String srcFilePathName, String tgtFilePathName) throws Exception 
    {
        File file = null;
        OutputStream outputStream = null;
        try {
        	file = new File(tgtFilePathName);
            outputStream = new FileOutputStream(file);
            boolean result = FTPSClient.retrieveFile(srcFilePathName, outputStream); 

            if(!result) {
            	file = null;
            	log.info("[FTP 파일 다운로드 ] 파일 : "+file.getName()+" / 다운로드 실패" );
            }
        } finally {
        	if(outputStream != null) {
        		outputStream.close();
        	}
        }
        
        return file;
    }   
    
    /**
     * FTP Download
     * 
     * @param FTPSClient
     * @param srcFilePathName 서버에서 다운로드할 경로를 포함한 파일명
     * @param tgtFilePathName 로컬에 저장될 경로를 포함한 파일명
     * @return
     * @throws Exception
     */
    public static File ftpDownloadFile(FTPClient client, String srcFilePathName, String tgtFilePathName) throws Exception 
    {
        File file = null;
        OutputStream outputStream = null;
        try {
        	System.out.println("srcFilePathName : " + srcFilePathName);
        	System.out.println("tgtFilePathName : " + tgtFilePathName);
        	file = new File(tgtFilePathName);
            outputStream = new FileOutputStream(file);
            boolean result = client.retrieveFile(srcFilePathName, outputStream); 
            
            if(!result) {
            	log.info("[FTP 파일 다운로드 ] 파일 : "+file.getName()+" / 다운로드 실패" );
            	file = null;
            }else{
            	log.info("[FTP 파일 다운로드 ] 파일 : "+file.getName()+" / 다운로드 성공" );
            }
        } finally {
        	if(outputStream != null) {
        		outputStream.close();
        	}
        }
        
        return file;
    }
    
    /**
     * FTP Upload
     * 
     * @param FTPSClient
     * @param srcFilePathName
     * @param strPath 서버에 저장될 Directory 위치 ex) "/", "/public/"
     * @return
     * @throws Exception
     */
    public static boolean ftpSUploadFile(FTPSClient ftps, File file, String strPath) throws Exception
    {
        InputStream inputStream = null;
        boolean result = false;
        try {
        	inputStream = new FileInputStream(file);
            result = ftps.storeFile(strPath + file.getName(), inputStream);
        } catch(IOException e) {
        	throw new Exception(e);
        } finally {
        	if(inputStream != null) {
        		try {
					inputStream.close();
				} catch (IOException e) {
		        	throw new Exception(e);
				}
        	}
        }
        
        return result;
    }
    /**
     * FTP Upload
     * 
     * @param FTPSClient
     * @param srcFilePathName
     * @param strPath 서버에 저장될 Directory 위치 ex) "/", "/public/"
     * @return
     * @throws Exception
     */
    public static boolean ftpUploadFile(FTPClient fClient, File file, String desPath) throws Exception
    {
    	log.info("[FTP 파일 업로드 시작~!!!!!!]  " );
        boolean result = false;
        InputStream is = null;
 
        try {
        	log.info("[FTP 파일 업로드] 파일 Des : "+desPath);
        	log.info("[FTP 파일 업로드] 파일 : "+file);
    		log.info("[FTP 파일 업로드] 파일 이름 : "+file.getName());
    		
    		is = new FileInputStream(file);
    		boolean bRtn = fClient.changeWorkingDirectory(desPath);
    		log.debug("[FTP 파일 업로드] chdir res : "+ bRtn);

    		if (fClient.isConnected() == true ) {
        		result = fClient.storeFile(file.getName(), is);
                log.info("[FTP 파일 업로드] 파일 result : "+result);	
    		} else {
    			log.info("[FTP 파일 업로드] fClient : "+ fClient.isConnected());
    		}
    		
        } catch(IOException e) {
        	log.error("[FTP 파일 업로드] 파일 : "+file.getName()+" / 업로드 실패" );
        	throw new Exception(e);
        	
        } finally {
        	if(result == true){
				log.info("[FTP 파일 업로드] 파일 : "+file.getName()+" / 업로드 성공" );
			}
        	if(is != null) {
        		
        		try {
        			is.close();
				} catch (IOException e) {
		        	throw new Exception(e);
				}
        	}
        }
        
        return result;
    }
    
    public static boolean ftpSUploadFile(FTPSClient FTPSClient, MultipartFile file, String strPathFilename) throws Exception
    {
        InputStream inputStream = null;
        boolean result = false;
        try {
        	inputStream = file.getInputStream();
        	result = FTPSClient.storeFile(strPathFilename, inputStream);
        } catch(IOException e) {
        	throw new Exception(e);
        } finally {
        	if(inputStream != null) {
        		try {
					inputStream.close();
				} catch (IOException e) {
		        	throw new Exception(e);
				}
        	}
        }
        return result;
    }
    
    /**
     * FTP Directory 변경
     * 
     * @param FTPSClient
     * @param dirPathName
     * @throws Exception
     */
    public static boolean ftpSChangeWorkingDir(FTPSClient FTPSClient, String dirPathName) throws Exception
    {
        return FTPSClient.changeWorkingDirectory(dirPathName);
    }
    /**
     * FTP Directory 변경
     * 
     * @param FTPSClient
     * @param dirPathName
     * @throws Exception
     */
    public static boolean ftpChangeWorkingDir(FTPClient FTPClient, String dirPathName) throws Exception
    {
        return FTPClient.changeWorkingDirectory(dirPathName);
    }
    
    /**
     * FTP file rename
     * 
     * @param FTPSClient
     * @param beforeFilePathName
     * @param afterFilePathName
     * @return
     * @throws Exception
     */
    public static boolean ftpRenameFile(FTPSClient FTPSClient, String beforeFilePathName, String afterFilePathName) throws Exception
    {
        return FTPSClient.rename(beforeFilePathName, afterFilePathName);        
    }
    
    /**
     * FTP file rename
     * 
     * @param FTPClient
     * @param beforeFilePathName
     * @param afterFilePathName
     * @return
     * @throws Exception
     */
    public static boolean ftpRenameFile(FTPClient FTPClient, String beforeFilePathName, String afterFilePathName) throws Exception
    {
        return FTPClient.rename(beforeFilePathName, afterFilePathName);        
    }

    /**
     * FTP file delete
     * 
     * @param FTPSClient
     * @param filePathName
     * @return
     * @throws Exception
     */
    public static boolean ftpSDeleteFile(FTPSClient FTPSClient, String filePathName) throws Exception
    {
    	try {
    		return FTPSClient.deleteFile(filePathName);
    	} catch(IOException e) {
    		throw new Exception(e);
    	}
    }
    
    public static boolean ftpDeleteFile(FTPClient FTPClient, String filePathName) throws Exception
    {
    	try {
    		return FTPClient.deleteFile(filePathName);
    	} catch(IOException e) {
    		e.printStackTrace();
    		throw new Exception(e);
    	}
    }
    
    public static FTPFile getFTPSFile(FTPSClient FTPSClient, String srcPathName, String filename) throws Exception 
    {
    	try {
	        FTPSClient.changeWorkingDirectory(srcPathName);
	        FTPFile[] ftpfiles = FTPSClient.listFiles(srcPathName);
	        if (ftpfiles != null)
	        {
	            for (int i = 0; i < ftpfiles.length; i++)
	            {
	                FTPFile file = ftpfiles[i];
	                if (file != null && filename.equals(file.getName()))
	                {
	                    return file;
	                }
	            }
	        }
    	} catch(IOException e) {
    		throw new Exception(e);
    	}
        
        return null;
    }
    
    public static boolean ftpSMakeDirectory(FTPSClient client, String pathname) throws Exception  {
    	try {
    		return client.makeDirectory(pathname);
    	} catch(IOException e) {
    		throw new Exception(e);
    	}
    }
    
    public static void ftpDownloadFileInDirAndMoveForMSMS_SUPP(FTPClient client, String srcPathName, String tgtPathName, String reNamePath) throws Exception 
    {
        FTPFile[] ftpfiles = client.listFiles(srcPathName);
        String tmp = null;
        if (ftpfiles != null)
        {
            for (int i = 0; i < ftpfiles.length; i++)
            {
                FTPFile file = ftpfiles[i];
                if (file.isFile()) {
                	tmp = file.getName();
                    if(tmp.charAt(0) == 'P'){
	                    ftpDownloadFile(client, srcPathName + file.getName(), tgtPathName + file.getName());
	                    ftpRenameFile(client, srcPathName + file.getName(), reNamePath + file.getName());
	                }
                }              
            }
        }        
    }
    
    public static void ftpDownloadFileInDirAndMoveForMSMI_CUST(FTPClient client, String srcPathName, String tgtPathName, String reNamePath) throws Exception 
    {
        FTPFile[] ftpfiles = client.listFiles(srcPathName);
        String[] tmpList = null;
        if (ftpfiles != null)
        {
            for (int i = 0; i < ftpfiles.length; i++)
            {
                FTPFile file = ftpfiles[i];
                if (file.isFile()) {
                	tmpList = file.getName().split("_");
                    if(tmpList[0].length()>3){
	                    ftpDownloadFile(client, srcPathName + file.getName(), tgtPathName + file.getName());
	                    ftpRenameFile(client, srcPathName + file.getName(), reNamePath + file.getName());
	                }
                }              
            }
        }        
    }
    
    public static void ftpDownloadFileInDirAndMove(FTPClient client, String srcPathName, String tgtPathName, String reNamePath) throws Exception 
    {
        FTPFile[] ftpfiles = client.listFiles(srcPathName);

        if (ftpfiles != null)
        {
        	log.info("[FTP 파일 다운로드 ] 파일 SRC : "+srcPathName);
    		log.info("[FTP 파일 다운로드 ] 파일 TARGET : "+tgtPathName);
    		log.info("[FTP 파일 다운로드 ] 파일 크기 : "+ftpfiles.length);
    		
            for (int i = 0; i < ftpfiles.length; i++)
            {
                FTPFile file = ftpfiles[i];
                if (file.isFile()) {
                    ftpDownloadFile(client, srcPathName + file.getName(), tgtPathName + file.getName());
                    boolean rtn = ftpRenameFile(client, srcPathName + file.getName(), reNamePath + file.getName());
                    
                    log.error("ftpRenameFile Src : " + srcPathName + file.getName());
                    log.error("ftpRenameFile Des : " + reNamePath + file.getName());
                    log.error("ftpRenameFile Result : " + rtn);
                }              
            }
        }        
    }
}
