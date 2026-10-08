package com.kep.common.service;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.log4j.Logger;

import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.ChannelSftp.LsEntry;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.DButil;
import com.kep.common.FileUtil;
import com.kep.common.FtpSUtils;
import com.kep.common.IFProperties;
import com.kep.common.SFTPUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.vo.GrdtUCVo;
import com.kep.common.vo.GrdtVo;
import com.kep.common.vo.IvdtUCVo;
import com.kep.common.vo.PodtUCVo;
import com.kep.common.vo.PodtVo;
import com.kep.common.vo.PrdtVo;
import com.kep.common.vo.RedtUCVo;

public class FileService {
	protected Logger log = null;
	protected String pId = this.getClass().getName();
	protected FileDao fDao = new FileDao();
	protected Map<String, String> hdInfo;
	protected List<Map<String, String>> dtInfos;
	protected List<Map<String, String>> rMaps = new ArrayList<Map<String, String>>();
	protected List<GrdtVo> grList = new ArrayList<GrdtVo>();
	protected List<PodtVo> poList = new ArrayList<PodtVo>();
	protected List<PrdtVo> prList = new ArrayList<PrdtVo>();
	protected List<PodtUCVo> poUcList = new ArrayList<PodtUCVo>();
	protected List<GrdtUCVo> grUcList = new ArrayList<GrdtUCVo>();
	protected List<IvdtUCVo> ivUcList = new ArrayList<IvdtUCVo>();
	protected List<RedtUCVo> reUcList = new ArrayList<RedtUCVo>();
	protected IFProperties prop = new IFProperties();
	protected FileUtil fUtil = new FileUtil();
	protected String tmpDir = "";
	protected ChannelSftp cSftp = null;
	
	protected FTPClient cftp = null;
	private DButil dbutil = null;
	private int count = 0;
	
	protected final int DEBUG = 0;
	protected final int INFO = 1;
	protected final int ERROR = 2;

	protected String rootPath = "";
	protected String logCnt = prop.getProperty("log.cnt");
	
	protected String splitType = "";

	/**
	 * Default Constructor
	 * P_ID 세팅 후 기초 데이터 조회
	 */
	public FileService() {
		this.log = Logger.getLogger(this.getClass());
		Map<String, String> pMap = new HashMap<String, String>();
		
		try {
			pMap.put("P_ID", this.pId);
			hdInfo = fDao.selectWorkHdInfo(pMap);
			dtInfos = fDao.selectWorkDtList(pMap);
			
	    	String osName = System.getProperty("os.name");
	    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
	    		this.rootPath = prop.getProperty("log.path.win");
	    		this.tmpDir = prop.getProperty("file.tmp.win");
	    		System.out.println(this.tmpDir);
	    		
	    	} else {
	    		this.rootPath = prop.getProperty("log.path.unix");
	    		this.tmpDir = prop.getProperty("file.tmp.unix");
	    	}
	    	
	    	this.splitType = hdInfo.get("SPLIT_TYPE");	    	
	    	if ("^||^".equals(this.splitType)) {
	    		this.splitType = "\\^\\|\\|\\^";
	    	}else if("^".equals(this.splitType)){
	    		this.splitType = "\\^";
	    	}else if("|".equals(this.splitType)) {
	    		this.splitType = "\\|";
	    	}else if("||".equals(this.splitType)) {
	    		this.splitType = "\\|\\|";
	    	}	    	
			
		} catch (SQLException e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}

	public void setInfo(String pId) {
		Map<String, String> pMap = new HashMap<String, String>();
		this.pId = pId;
		try {
			pMap.put("P_ID", this.pId);
			hdInfo = fDao.selectWorkHdInfo(pMap);
			dtInfos = fDao.selectWorkDtList(pMap);
			
	    	String osName = System.getProperty("os.name");
	    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
	    		this.rootPath = prop.getProperty("log.path.win");
	    		this.tmpDir = prop.getProperty("file.tmp.win");
	    	} else {
	    		this.rootPath = prop.getProperty("log.path.unix");
	    		this.tmpDir = prop.getProperty("file.tmp.unix");
	    	}
	    	
	    	this.splitType = hdInfo.get("SPLIT_TYPE");
		} catch (SQLException e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
	public void connectFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cftp = FtpSUtils.ftpLogin(ftp_url, ftp_port, ftp_id, ftp_pw);

		if(this.cftp == null){
			log.error(ftp_url +"/"+ ftp_id + "서버 로그인 실패");
			
			throw new Exception(ftp_url + "/"+ ftp_id + "SFTP 접속실패.");
		}else{
			log.debug(ftp_url + "/"+ ftp_id +"서버 로그인 성공");
		}
	}
	public void connectSFTP(String ftp_url, int ftp_port, String ftp_id, String ftp_pw) throws Exception{
		
		this.cSftp = SFTPUtil.sftpLogIn(ftp_url, ftp_port, ftp_id, ftp_pw);
		
		if(this.cSftp == null){
			log.error(ftp_url +"/"+ ftp_id + "서버 로그인 실패");
			
			throw new Exception(ftp_url + "/"+ ftp_id + "SFTP 접속실패.");
		}else{
			log.debug(ftp_url + "/"+ ftp_id +"서버 로그인 성공");
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
   public void sendToTargetFromKEP(String ftp_id, String srcPath, String targetPath) throws Exception{
		
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
			
			log.debug("targetPath : "+targetPath +"/ srcFile : " + srcFile);	
			
			//boolean bUpRtn = FtpSUtils.ftpUploadFile(this.cftp, srcFile, targetPath);
			boolean bUpRtn = SFTPUtil.sFtpUploadFile(targetPath,srcFile);
			
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
   
   public void sendToTargetFromKEP_ftp(String ftp_id, String srcPath, String targetPath) throws Exception{
		
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
			
			log.debug("targetPath : "+targetPath +"/ srcFile : " + srcFile);	
			
			boolean bUpRtn = FtpSUtils.ftpUploadFile(this.cftp, srcFile, targetPath);
			//boolean bUpRtn = SFTPUtil.sFtpUploadFile(targetPath,srcFile);
			
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
   public void recvToKepFromTarget(String srcPath, String targetPath, String srcBackupPath) throws Exception{
		
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
   
   public void recvToKepFromTarget_ftp(String srcPath, String targetPath, String srcBackupPath) throws Exception{
		
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
		
		fileList = getFileListFromTargetServer_ftp(srcPath);
		
		for(int i = 0 ; i < fileList.size() ; i++) {
						
			// dat파일 다운
			FtpSUtils.ftpDownloadFile(this.cftp, fileList.get(i), targetPath + "/" + fileList.get(i));
			// 다운 후 파일 원격디렉토리에서 삭제.
			FtpSUtils.ftpDeleteFile(this.cftp, fileList.get(i));
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
   
   public ArrayList<String> getFileListFromTargetServer_ftp(String dir) throws Exception{
		
		ArrayList<String> fileList	= new ArrayList<String>();
		
		FTPFile[] fList = this.cftp.listFiles(dir);
		
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
   public ArrayList<String> getFileListFromKEPServer(String srcDir, String filterStr) throws Exception{
		
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
   
	public Map<String, String> convertStringToMap(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
		if (this.splitType.equals("L")) {
			// 길이로 짜르는 경우
			int sIdx = 0;
			int dIdx = 0;
			for (Map<String, String> item : dtInfos) {
				dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
				String str = data.substring(sIdx, dIdx);
				iMap.put(item.get("F_ID"), str.trim());
				sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
			}
		} else {
			String[] arrData = data.split(this.splitType, -1);
			// 구분자로 짜르는 경우
			for (Map<String, String> item : dtInfos) {
				if ( "T".equals(arrData[0]) ) {
					if ("SNTD".equals(hdInfo.get("BUYER_ID"))) {
						iMap.put("TYPE", arrData[0]);
						iMap.put("TOT_CNT", arrData[2]);
						break;
						
					} else {
						iMap.put("TYPE", arrData[0]);
						iMap.put("TOT_CNT", arrData[1]);
						break;
					}
					
				} else{
			
					try {
						iMap.put(item.get("F_ID"), arrData[Integer.parseInt(item.get("SEQ"))].trim());
					} catch (Exception e) {
						iMap.put(item.get("F_ID"), "");
						log.error(item.get("F_ID") + " is error!!");
					}
				}
			}
		}
		return iMap;
	}
	public Map<String, String> convertStringToMap_ODPO2(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
		System.out.println("start!!!!!! " );
		if (this.splitType.equals("L") && data.length() > 0) {
			// 길이로 짜르는 경우
			int sIdx = 0;
			int dIdx = 0;
			String first = data.substring(0,1);
			int totalIdx = data.length();
			
			if ("D".equals(first)) {
			
				for (Map<String, String> item : dtInfos) {
//					dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
//					String str = data.substring(sIdx, dIdx);
//					
//					System.out.println("str = " + str);
//					
//					iMap.put(item.get("F_ID"), str.trim());
//					sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
					
					dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
					
					if (totalIdx > dIdx) {
						String str = data.substring(sIdx, dIdx);
						iMap.put(item.get("F_ID"), str.trim());
					} else {
						
						if (totalIdx > sIdx) {
							String str = data.substring(sIdx);
							iMap.put(item.get("F_ID"), str.trim());
						} else {
							iMap.put(item.get("F_ID"), " ");
						}
					}
					sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
					
				}
			} else {
				
				iMap.put("TOT_CNT", "0");
				
			}
		}
		return iMap;
	}
	
	public Map<String, String> convertStringToMap_DAEW(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
		
		
		System.out.println("start!!!!!! " );
		if (this.splitType.equals("L") && data.length() > 0) {
			// 길이로 짜르는 경우
			int sIdx = 0;
			int dIdx = 0;
			String first = data.substring(0,1);
			
			if ("D".equals(first)) {
			
				for (Map<String, String> item : dtInfos) {
					dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
					String str = data.substring(sIdx, dIdx);
					
					System.out.println("str = " + str);
					
					iMap.put(item.get("F_ID"), str.trim());
					sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
				}
			} else {
				
				iMap.put("TOT_CNT", "0");
				
			}
		}
		return iMap;
	}
	public Map<String, String> convertStringToMap_DAEW_PO(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
		System.out.println("start!!!!!! " );
		if (this.splitType.equals("L")) {
			// 길이로 짜르는 경우
			int sIdx = 0;
			int dIdx = 0;
			String first = data.substring(0,1);
//			System.out.println("data.length = " + data.length() );
			int totalIdx = data.length();
			
			if ("D".equals(first)) {
			
				for (Map<String, String> item : dtInfos) {
				
					dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
					
//					System.out.println("dIdx = " + dIdx);
//					System.out.println("totalIdx = " + totalIdx);
//					System.out.println("sIdx = " + sIdx);
					
					if (totalIdx > dIdx) {
						String str = data.substring(sIdx, dIdx);
						iMap.put(item.get("F_ID"), str.trim());
					} else {
						
						if (totalIdx > sIdx) {
							String str = data.substring(sIdx);
							iMap.put(item.get("F_ID"), str.trim());
						} else {
							iMap.put(item.get("F_ID"), " ");
						}
					}
//					System.out.println("iMap = " + iMap);
					sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
				}
			}
		}
		return iMap;
	}
	public Map<String, String> convertStringToMap_YHKB(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
	
			String[] arrData = data.split(this.splitType, -1);
//			int i = 0;
//			for (String str : arrData) {
//				System.out.println("str " + " ["+ i + "] = " + str );
//			}
//			
			if ("GH_Information_MRO_".equals(hdInfo.get("PREFIX"))) {
				int sIdx = 0;
				int dIdx = 0;
				for (Map<String, String> item : dtInfos) {
					if("".equals(arrData[0]) || arrData[0] == null) {
						break;
					}
					if ("45".equals(arrData[0].substring(0,2))) {
							try {
								iMap.put(item.get("F_ID"), arrData[Integer.parseInt(item.get("SEQ"))]);	
							} catch (Exception e) {
								iMap.put(item.get("F_ID"), "");
								log.error(item.get("F_ID") + " is error!!");
								logInfo(CommonUtil.printStackTraceToString(e));
							}
//						dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
//						String str = data.substring(sIdx, dIdx);
//						iMap.put(item.get("F_ID"), str);
//						sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
					} else {
						break;
					}
				}
			} else {
				for (Map<String, String> item : dtInfos) {
					if ( "0".equals(arrData[0].substring(0,1)) ) {
						
						iMap.put("TOT_CNT", arrData[0]);
	//					System.out.println("arrData[0] = " + arrData[0]);
						break;
						
					} else{
						if("START".equals(arrData[0]) || "ENDOFFILE".equals(arrData[0])){
	//						System.out.println("break !!!!!!!!!!!" );
							break;
						}else {
							try {
								iMap.put(item.get("F_ID"), arrData[Integer.parseInt(item.get("SEQ"))]);	
							} catch (Exception e) {
								iMap.put(item.get("F_ID"), "");
								log.error(item.get("F_ID") + " is error!!");
								logInfo(CommonUtil.printStackTraceToString(e));
							}
						}
					}
				}
			}
		return iMap;
	}
    
    /**
     * 맵에 입력된 데이터를 Vo객체로 이관한다.
     * @param pMap
     * @return
     */
    public Object convertMapToVo(Map<String, String> pMap, Object obj) {
    	Iterator<String> itr = pMap.keySet().iterator();
    	Method[] methods = obj.getClass().getDeclaredMethods();
    	String fId = null;
    	String methodStr = null;
    	while (itr.hasNext()) {
    		fId = (String) itr.next();
    		methodStr = "set" + fId;
    		try {
				for(int i=0 ; i <= methods.length - 1 ; i++) {
					if (methodStr.equals(methods[i].getName())) {
						methods[i].invoke(obj, pMap.get(fId));
					}
				}
			} catch (Exception e) { log.error(CommonUtil.printStackTraceToString(e)); }
    	}
    	return obj;
    }
    
    /**
     * 맵에 입력된 데이터를 Vo객체로 이관한다.
     * @param pMap
     * @return
     */
    public Object convertStringToVo(String data, Object obj) {
    	String methodStr = "";
    	try {
        	Method[] methods = obj.getClass().getDeclaredMethods();
        	if (this.splitType.equals("L")) {
    			// 길이로 짜르는 경우
    			int sIdx = 0;
    			int dIdx = 0;
    			for (Map<String, String> item : dtInfos) {
    				dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
    				String str = data.substring(sIdx, dIdx);
    				methodStr = "set" + item.get("F_ID");
    				for(int i=0 ; i <= methods.length - 1 ; i++) {
    					if (methodStr.equals(methods[i].getName())) {
    						methods[i].invoke(obj, str);
    					}
    				}
    				sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
    			}
        	} else {

    			String[] arrData = data.split(this.splitType, -1);
    			// 구분자로 짜르는 경우
    			for (Map<String, String> item : dtInfos) {
    				if ( "T".equals(arrData[0]) ) {
    					break;
    				} else {
    					methodStr = "set" + item.get("F_ID");
        				for(int i=0 ; i <= methods.length - 1 ; i++) {
        					if (methodStr.equals(methods[i].getName())) {
        						methods[i].invoke(obj, arrData[Integer.parseInt(item.get("SEQ"))].trim());
        					}
        				}
    				}
    			}
        	}
		} catch (Exception e) { log.error(CommonUtil.printStackTraceToString(e)); }
    	
    	return obj;
    }

    public String convertMaptoString(Map<String, String> pMap) {
    	String rtnStr = "";
    	for ( int i = 0 ; i < this.dtInfos.size() ; i++) {
    		for ( Map<String, String> item : dtInfos ) {
    			if ( i == Integer.parseInt(item.get("SEQ") ) ) {
    				String fData = String.valueOf(pMap.get(item.get("F_ID")));
    				
    				System.out.println("item.get(\"F_ID\") = " + item.get("F_ID"));
    				System.out.println("pMap.get(item.get(\"F_ID\")) = " + pMap.get(item.get("F_ID")));
    				System.out.println("fData = " + fData);
    				
    				if (fData == null || "null".equals(fData)) fData = "";
    				rtnStr = rtnStr + fData + hdInfo.get("SPLIT_TYPE");
        			break;
    			}
    		}
    	}
    	return rtnStr;
    }
    public String convertMaptoString_MSMI(Map<String, String> pMap) {
    	StringBuilder rtnStr = new StringBuilder();
    	for ( int i = 0 ; i < this.dtInfos.size() ; i++) {
    		for ( Map<String, String> item : dtInfos ) {
    			if ( i == Integer.parseInt(item.get("SEQ") ) ) {
    				String fData = String.valueOf(pMap.get(item.get("F_ID")));
    				
//    				System.out.println("item.get(\"F_ID\") = " + item.get("F_ID"));
//    				System.out.println("pMap.get(item.get(\"F_ID\")) = " + pMap.get(item.get("F_ID")));
//    				System.out.println("fData = " + fData);
    				
    				if (fData == null || "null".equals(fData)) fData = "";
//    				rtnStr = rtnStr + fData + hdInfo.get("SPLIT_TYPE");
    				
    				if("UPDATE_TIME".equals(String.valueOf(item.get("F_ID")))) {
    					rtnStr.append(fData);
    					break;
    				}
    				rtnStr.append(fData);
    				rtnStr.append("\t");
        			break;
    			}
    		}
    	}
    	return rtnStr.toString();
    }
    public String convertMaptoString_MSMS(Map<String, String> pMap) {
    	String rtnStr = "";
    	for ( int i = 0 ; i < this.dtInfos.size() ; i++) {
    		for ( Map<String, String> item : dtInfos ) {
    			if ( i == Integer.parseInt(item.get("SEQ") ) ) {
    				if(i != 44) {
	    				String fData = String.valueOf(pMap.get(item.get("F_ID")));
	    				
	    				if (fData == null || "null".equals(fData)) fData = "";
	    				rtnStr = rtnStr + fData + hdInfo.get("SPLIT_TYPE");
	        			break;
    				} else {
    					String fData = String.valueOf(pMap.get(item.get("F_ID")));
	    				
	    				if (fData == null || "null".equals(fData)) fData = "";
	    				rtnStr = rtnStr + fData;
	        			break;
    				}
    			}
    		}
    	}
    	return rtnStr;
    }
	public Map<String, String> convertStringToMap_PG_PGPay(String data) {
		Map<String, String> iMap = new HashMap<String, String>();
		
		
		System.out.println("start!!!!!! " );
		if (this.splitType.equals("L") && data.length() > 0) {
			// 길이로 짜르는 경우
			int sIdx = 0;
			int dIdx = 0;
			String first = data.substring(0,1);
			
			if ("D".equals(first)) {
			
				for (Map<String, String> item : dtInfos) {
					dIdx = dIdx + Integer.parseInt(item.get("F_LENGTH"));
					String str = data.substring(sIdx, dIdx);
					
					System.out.println(item.get("F_ID") + " => " + str);
					
					iMap.put(item.get("F_ID"), str.trim());
					sIdx = sIdx + Integer.parseInt(item.get("F_LENGTH"));
				}
			} else {
				
				iMap.put("TOT_CNT", "0");
				
			}
		}
		return iMap;
	}
    public void logDebug(String context) {
    	this.writeLog(this.DEBUG, context);
    	
    	String osName = System.getProperty("os.name");
    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
    		log.debug(context);
    	}
    }
    
    public void logInfo(String context) {
    	this.writeLog(this.INFO, context);
    	
    	String osName = System.getProperty("os.name");
    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
    		log.info(context);
    	}
    }
    
    public void logError(String context) {
    	this.writeLog(this.ERROR, context);
    	
    	String osName = System.getProperty("os.name");
    	if (osName.toUpperCase().indexOf("WINDOWS") > -1) {
    		log.error(context);
    	}
    }
    
    public void writeLog( int logLevel, String context ) {
    	/**
    	 * 일일 로그 파일 생성
    	 * 기본 폴더는 어디에 저장할까? 역시 property를 써야겠지?
    	 * 10일치 로그까지 보관한다. 10일 이상의 파일은 삭제한다. 어제 파일은 날짜를 추가하여 mv처리.
    	 * 로그 레벨 단위로 출력여부를 판단한다.
    	 * 로그 폴더가 없으면 폴더를 만든다.
    	 * dbType / pId 앞 4글자 기준으로 로그 폴더를 생성한다.
    	 */
		if ( Integer.parseInt(prop.getProperty("log.level")) <= logLevel ) {
	    	String logPath = "";
	    	String[] pArr = pId.split("\\.");
	    	String logFile = pArr[pArr.length - 1] + ".log"; 
	    	
	    	String dbType = CommonProperty.getDB_TYPE().toLowerCase() + "_log";
	    	String gubun = logFile.substring(0, 4).toUpperCase();
	
	    	logPath = this.rootPath + "/" + dbType +"/Log_"+gubun+"/";
	    	
			File logDir = new File(logPath);
			if ( !logDir.isDirectory()) {
				new File(this.rootPath + "/" + dbType).mkdir();
				logDir.mkdir();
			}
			/**
			 * 파일 속성 확인
			 * 로그 write하기 전에 생성일을 확인. 현재일과 틀릴 경우 log -> log_yyyymmdd 로 변경
			 */
			File lf = new File(logPath + "/" + logFile);
			
			if (lf.exists()) {
				Calendar fileTm = new GregorianCalendar();
				fileTm.setTimeInMillis( lf.lastModified() );
				String yyyy = "" + fileTm.get( Calendar.YEAR  );
				String mm = "" + ( fileTm.get( Calendar.MONTH ) + 1) ;
				if (Integer.parseInt(mm) < 10) mm = "0" + mm;
				String dd = "" + fileTm.get( Calendar.DATE  );
				if (Integer.parseInt(dd) < 10) dd = "0" + dd;
				String fTime = yyyy + mm + dd ;
				SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMdd");
				Date time = new Date();
				String ntime = dFormat.format(time);
				// 로그 파일 생성일 비교. 날짜가 넘어갈 경우 파일을 mv한다.
				if (Integer.parseInt(fTime) < Integer.parseInt(ntime)) {
					String sName = logPath + "/" + logFile;
					String bName = logPath + "/" + logFile + "." + fTime;
					log.debug("move : " + sName + " ==> " + bName);
					lf.renameTo(new File(bName));
				}
				
				List<String> logFiles = fUtil.getFileList(logPath, pId);
				int cnt = Integer.parseInt(this.logCnt);
				if( logFiles.size() > cnt ) {
					File dF = new File(logPath + logFiles.get(0));
					if (dF.exists()) dF.delete();
				}
			}
			
			try {
				SimpleDateFormat dFormat = new SimpleDateFormat("HH:mm:ss");
				Date time = new Date();
				String ntime = dFormat.format(time);
//				FileWriterWithEncoding
				FileWriter fw = new FileWriter(logPath + "/" + logFile, true);
				String strLevel = "";
				if (logLevel == this.DEBUG) strLevel = "DEBUG";
				else if (logLevel == this.INFO) strLevel = "INFO";
				else if (logLevel == this.ERROR) strLevel = "ERROR";
				fw.write("[" + strLevel + "][" + ntime + "]" + context + System.getProperty("line.separator"));
				fw.flush();
				fw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
    }
}