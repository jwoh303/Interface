package com.kep.ftp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class SoilFtpRecvService extends FileService implements Runnable  {

	@Override
	public void run() {
		
		try {
/*			
			log.info("[FTP 연결시도...]");
			connectFTP(hdInfo.get("TARGET_IP"), Integer.parseInt(hdInfo.get("TARGET_PORT")), hdInfo.get("TARGET_ID"), hdInfo.get("TARGET_PW"));
			
			log.info("[DOWNLOAD TARGET -> 34] DIR : "+ hdInfo.get("TARGET_DIR"));
			this.recvToKepFromTarget_ftp(hdInfo.get("TARGET_DIR"), hdInfo.get("FOLDER"), "");
			
			log.info("[FTP 연결해제 시도]");
			disconnectFTP(this.cftp);
*/
			log.info("[SFTP 연결시도...]");
			log.info("IP:"+hdInfo.get("TARGET_IP")+" port:"+ hdInfo.get("TARGET_PORT"));
			connectSFTP(hdInfo.get("TARGET_IP"), Integer.parseInt(hdInfo.get("TARGET_PORT")), hdInfo.get("TARGET_ID"), hdInfo.get("TARGET_PW"));
			
			log.info("[Soil DOWNLOAD -> 103.11] ID : "+hdInfo.get("TARGET_ID")+" , DIR : "+hdInfo.get("TARGET_DIR"));
			recvToKepFromTarget( hdInfo.get("TARGET_DIR"), hdInfo.get("FOLDER")+"/", hdInfo.get("TARGET_DIR")+"BACK/");
			
			log.info("[SFTP 연결해제 시도]");
			disconnectSFTP();
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}
