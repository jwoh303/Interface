package com.buyer.yhkb.service;

import java.util.List;
import java.util.Map;

import com.buyer.yhkb.dao.YhkbPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class YhkbPoLoadService extends FileService implements Runnable {
	private YhkbPoDao dao = new YhkbPoDao();
	@Override
	public void run() {
		boolean isBreak = false;
		
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					try {
						logInfo("file info : " + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						int eCnt = 0;
						this.rMaps.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							if ("C".equals(iMap.get("STATUS"))) {
								lineCnt++;
								iMap.put("BUYER", "KRPOON0010");
								iMap.put("FILE_NAME", fName);
								
								this.rMaps.add(iMap);
							}
							
						}
						
						if(lineCnt > 0 ) {
							for(Map<String, String> item : this.rMaps) {
								boolean bRtn = dao.insertPodtYHKB(item);
								if (bRtn == false ) {
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+item.get("PO_NO")+" / "+item.get("LINE_NO")+" ]");
									dao.YhkbMailSend(item);
								}
							}
							logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
						} else {
							// 비정상 처리.
							logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
							isBreak = true;
						}
						// move back
						fUtil.moveBack(path, fName);
						logInfo("file Success : " + fName );
						// 정지여부.
						if (isBreak) break;
					} catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
						logInfo(CommonUtil.printStackTraceToString(e));
					}
				}
			}	
			
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}
