package com.kep.common.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;

@SuppressWarnings("unchecked")
public class FileExecService {
	private Logger log = Logger.getLogger(this.getClass());
	private FileDao dao	= new FileDao();
	public void execute() {
		/**
		 * File Exec Process
		 * 1. select Work list - WORK_ID ; PATH ; PRGRAM_LIST
		 * 						 FAGB ; /export/ftp/pub_fagb/RECV/ ; GR ; fagb_grifload
		 */
		try {
			List<Map<String, String>> hdList = dao.selectWorkHdList();
			if (hdList.size() > 0) {
				for (Map<String, String> iMap : hdList) {
					log.debug("Setting Info : " + (String)iMap.get("P_ID"));
					System.out.println("Setting Info : " + (String)iMap.get("P_ID"));
					try {
						Class cls = Class.forName(iMap.get("P_ID"));
						Object obj = cls.newInstance();
						Runnable r = (Runnable) obj;
						r.run();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
			System.out.println(CommonUtil.printStackTraceToString(e));
		}
	}
}