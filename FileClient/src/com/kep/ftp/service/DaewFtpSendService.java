package com.kep.ftp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.DButil;
import com.kep.common.service.FileService;


public class DaewFtpSendService extends FileService implements Runnable  {

	@Override
	public void run() {
		
		try {
			
			log.info("[FTP 연결시도...]");
			connectFTP(hdInfo.get("TARGET_IP"), Integer.parseInt(hdInfo.get("TARGET_PORT")), hdInfo.get("TARGET_ID"), hdInfo.get("TARGET_PW"));
			
			/* 데이터 송신 34번 서버 -> BUYER SR */
			log.info("[UPLOAD 103.11->BUYER] ID : "+hdInfo.get("TARGET_ID")+" , DIR : "+hdInfo.get("TARGET_DIR"));
			sendToTargetFromKEP_ftp(hdInfo.get("TARGET_ID"), hdInfo.get("FOLDER"), hdInfo.get("TARGET_DIR"));
			
			log.info("[FTP 연결해제 시도]");
			disconnectFTP(this.cftp);
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}
