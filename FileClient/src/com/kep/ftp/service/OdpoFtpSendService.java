package com.kep.ftp.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewIvDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class OdpoFtpSendService extends FileService implements Runnable {
	
	
	@Override
	public void run() {
		try {
			
				log.info("[SFTP 연결시도...]");
				connectSFTP(hdInfo.get("TARGET_IP"), Integer.parseInt(hdInfo.get("TARGET_PORT")), hdInfo.get("TARGET_ID"), hdInfo.get("TARGET_PW"));
				
				log.info("[DOWNLOAD 103.11-> 111.48] ID : "+hdInfo.get("TARGET_ID")+" , DIR : "+hdInfo.get("TARGET_DIR"));
				sendToTargetFromKEP(hdInfo.get("TARGET_ID"), hdInfo.get("FOLDER")+"/", hdInfo.get("TARGET_DIR"));

				log.info("[SFTP 연결해제 시도]");
				disconnectSFTP();
			
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
		
	}
}
