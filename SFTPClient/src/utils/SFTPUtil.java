package utils;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.log4j.Logger;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

/**
 * 서버와 연결하여 파일을 업로드하고, 다운로드한다.
 *
 * @author 
 * @since 
 *
 */

public class SFTPUtil{
	private static Logger log	= Logger.getLogger(SFTPUtil.class.getName());	
	private static ChannelSftp cSftp = null;
	private static Session session = null;
	
    public static ChannelSftp sftpLogIn(String FTP_URL, int FTP_PORT, String FTP_ID, String FTP_PW){
    	
    	JSch.setLogger(new com.jcraft.jsch.Logger() {
    		public boolean isEnabled(int level) {return true;}
    		public void log(int level, String message) {
    			System.out.println(message);
    		}
    	});
    	
        JSch jsch = new JSch();
        
        Channel channel = null;
        
    	try {
			
    		session = jsch.getSession(FTP_ID, FTP_URL, FTP_PORT);    		
			session.setPassword(FTP_PW);
			
            java.util.Properties config = new java.util.Properties();
            
            config.put("StrictHostKeyChecking", "no");
            config.put(
            		"server_host_key",
            		"ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,"
            		+ "rsa-sha2-512,rsa-sha2-256,"
            		+ "ssh-rsa,ssh-dss"
            		);
            
            session.setConfig(config);
            session.connect();

            channel = session.openChannel("sftp");
            channel.connect(1000);            
			
		} catch (JSchException e) {
			log.error("SFTP 로그인 에러 : "+ e.getMessage());
			e.printStackTrace();
		}
    	
    	cSftp = (ChannelSftp) channel;
    	return cSftp;
    }
    
    public static boolean ftpLogOut() {
    	
    	boolean ret = false; 
    			
    	cSftp.quit();
    	session.disconnect();
    	
    	if(!cSftp.isConnected() && !session.isConnected()){
    		ret = true;
    		System.out.println("연결해제 완료");
    		log.info("연결해제 완료");
    		log.debug("cSftp 연결상태 확인 : "+cSftp.isConnected());
        	log.debug("seesion 연결상태 확인 :"+session.isConnected());
    	}
    	
    	return ret;
    }
    
       
    /**
     * 하나의 파일을 다운로드 한다.
     *
     */
    public static void sFtpDownloadFile_MSMS(String srcPath, String srcFileName, String destPath) throws Exception{
    	
    	/*2안*/
    	InputStream in = null;
        FileOutputStream out = null;

        try {
        	
        	cSftp.cd(srcPath);
            in = cSftp.get(srcFileName);
            
            out = new FileOutputStream(new File(destPath+"/" + srcFileName));
            int i;

            while ((i = in.read()) != -1) {
            	if(i == '\n')
            		out.write('\r');
                out.write(i);
            }

            cSftp.cd("/..");
            System.out.println("sFTP다운로드 중");
        } catch (Exception e) {
        	
        	System.out.println("sFTP다운로드 에러");
        	log.error("sFTP다운로드 에러");
            throw new Exception("sFTP다운로드 에러");

        } finally {

            try {
                out.close();
                in.close();
            } catch (IOException e) {
            	log.error("파일 클로즈 에러");
                e.printStackTrace();
            }
            
        }
        System.out.println("[sFTP 파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
        log.info("[sFTP 파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
    }
    public static void sFtpDownloadFile(String srcPath, String srcFileName, String destPath) throws Exception{
    	
    	/*2안*/
    	
    	InputStream in = null;
        FileOutputStream out = null;

        try {
        	
        	cSftp.cd(srcPath);
            in = cSftp.get(srcFileName);
            
            out = new FileOutputStream(new File(destPath+"/"+srcFileName));
            int i;

            while ((i = in.read()) != -1) {
            	
                out.write(i);
            }

            cSftp.cd("/..");
            System.out.println("sFTP다운로드 중");
        } catch (Exception e) {
        	
        	System.out.println("sFTP다운로드 에러");
        	log.error("sFTP다운로드 에러");
            throw new Exception("sFTP다운로드 에러");

        } finally {

            try {
                out.close();
                in.close();
            } catch (IOException e) {
            	log.error("파일 클로즈 에러");
                e.printStackTrace();
            }
            
        }
        System.out.println("[sFTP 파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
        log.info("[sFTP 파일 다운로드] 파일명 : "+ srcFileName + " / 다운로드 완료 ");
    }
    
    /**
     * 하나의 파일을 업로드 한다.
     *
     * @param dir
     *            저장시킬 주소(서버)
     * @param file
     *            저장할 파일
     */
    
    public static void sFtpUploadFile(String destPath, File file) throws Exception {
    	FileInputStream in = null;
       
    	try {
    		
            in = new FileInputStream(file);
            cSftp.cd(destPath);
            cSftp.put(in, file.getName());
            cSftp.cd("/..");
            
        } catch (Exception e) {
        	
        	log.error("sFTP업로드 에러");
        	throw new Exception("sFTP업로드 에러");
        	
        } finally {
        	
            try {
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    	log.info("[sFTP 파일 업로드] 파일명 : "+file.getName()+" / 업로드 성공");
    }

    public static void sftpDeleteFile(String Path, String FileName) throws Exception {
    	
    	try {
    		
			cSftp.rm(Path+"/"+FileName);
			System.out.println("success to delete file");
		} catch (SftpException e) {
			System.out.println("failed to delete file");
			e.printStackTrace();
			
			log.debug("failed to delete file");
			throw e;
		}
    }
}