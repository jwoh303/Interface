package com.buyer.daed.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daed.dao.DaedPrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class DaedPrLoadService extends FileService implements Runnable{
	
	DaedPrDao dao = new DaedPrDao();
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		boolean isBreak = false;
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					logInfo("file info : " + fName);
					List<String> fContent = fUtil.getFileContent(path, fName, charset);
					int lineCnt = 0;
					int totCnt = 0;
					int eCnt = 0;
					String new_fName = "";
					
					for(String line : fContent) {
						
						lineCnt++;
						
						Map <String,String> iMap = new HashMap<String,String>();
						iMap = convertStringToMap(line);
						System.out.println(iMap);
						
						if("D".equals(iMap.get("TYPE")) || "F".equals(iMap.get("TYPE"))) {
							dao.REIF_LOAD(iMap);
						}
					}
					
					totCnt = lineCnt;
					
					if (lineCnt == totCnt && lineCnt > 0) {
						 SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
					   	 Date time = new Date();
						 String ntime = dFormat.format(time);
						 new_fName = fName + "." + ntime;

					} else {
						// 비정상 처리.
						logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
						isBreak = true;
					}
					// move back
					boolean isSuccess = fUtil.moveutil(path + "/" + fName , hdInfo.get("FOLDER") + "/archive/" + new_fName);
					if (!isSuccess)  {
						// 에러 처리.
						logError("File Create Error ["+fName+"]" );
					}
					// 정지여부.
					if (isBreak) break;
					
				}
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			logError(CommonUtil.printStackTraceToString(e));
		}
	}

}
