package com.buyer.gsep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.buyer.gsep.dao.GsepIdDao;
import com.kep.common.CommonUtil;
import com.kep.common.FileUtil;
import com.kep.common.service.FileService;

public class GsepIdLoadService extends FileService implements Runnable{
	
	private GsepIdDao dao = new GsepIdDao();

	@Override
	public void run() {
		logInfo("Class Start : " + this.getClass().getName());
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("WORK_ID", "GSEP");
		pMap.put("PROGRAM_ID", this.getClass().getName());
		int idx = 0;
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					try {
						logDebug("file info : " + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							this.rMaps.add(iMap);
						}
						// checksum : GS건설은 체크섬 사용안함.
						// data save
						/**
						 * 1. merge 
						 * 2. update 최종 수정일이 2일 전인 데이터는 use_chk = 'N' 처리
						 */
						// 1. merge info
						idx = 0;
						for(Map<String, String> rMap : this.rMaps) {
							idx++;
							logDebug("emp_no["+idx+"] : " + rMap.get("EMP_NO"));
							dao.udpateGsepEmpInfo(rMap);
						}
						dao.udpateGsepEmpClose();
						// move back
						fUtil.moveBack(path, fName);
					} catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
					}
				}
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
		logInfo("Class Finish : " + this.getClass().getName());
	}
}