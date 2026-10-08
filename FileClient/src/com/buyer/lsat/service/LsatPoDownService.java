package com.buyer.lsat.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.lsat.dao.LsatPoDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class LsatPoDownService extends FileService implements Runnable {

	LsatPoDownDao dao = new LsatPoDownDao();
	
	@Override
	public void run() {			
		try {
			List<Map<String, String>> poList = dao.setectLsatPoList();
			if(poList.size() > 0) {
				List<String> fData = new ArrayList<String>();
				for(Map<String, String> dMap : poList) {
					String lData = convertMaptoString(dMap);
					// 마지막 || 제거
					if(lData.endsWith("||")) {
						lData = lData.substring(0,lData.length() -2);
					}
					fData.add(lData);
					dao.updateLsatPohd(dMap);
				}
				// 마지막줄 토탈값 필요 시
//					String tail = "T" + hdInfo.get("SPLIT_TYPE") + fData.size() + hdInfo.get("SPLIT_TYPE");
//					fData.add(tail);
				
				SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd");
				SimpleDateFormat sdfTime = new SimpleDateFormat("HHmmss");
				Date time = new Date();
				String ntime = sdfDate.format(time)+"_"+sdfTime.format(time);			
				String filename = hdInfo.get("PREFIX") + ntime + ".txt";
				fUtil.setFileContent(hdInfo.get("FOLDER"), filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));			
				boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
				if (!isSuccess)  {
					// 에러 처리.
					logError("File Create Error ["+filename+"]" );
				}
				
				logInfo("### Lsat File Success : " + filename );
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}		
	}
}
