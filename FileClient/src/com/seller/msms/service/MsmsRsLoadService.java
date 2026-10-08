package com.seller.msms.service;

import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.msms.dao.MsmsRsDao;

public class MsmsRsLoadService extends FileService implements Runnable {

	private MsmsRsDao dao = new MsmsRsDao();
	
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
							if ("D".equals(iMap.get("TYPE"))) {
								lineCnt++;
								
								iMap.put("REVISION", "00");
								iMap.put("GUBUN", "RS");
								iMap.put("LEGACY_NO", iMap.get("PO_NO"));
								iMap.put("ERROR_MSG", "");
								
								rMaps.add(iMap);
								
							} else if ("T".equals(iMap.get("TYPE"))) {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT"));
							}
							
						}
						
						if (lineCnt == totCnt && lineCnt > 0) {
							
							for(Map<String, String> item : this.rMaps) {
								System.out.println("item : " + item);
								dao.logwrite(item);
								dao.PORS_Update(item);
							}
							
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
						e.printStackTrace();
						logError(CommonUtil.printStackTraceToString(e));
					}	
				}
			}
			
			
			List<String> fList2 = fUtil.getFileList(path, "IV");
			
			if (fList2.size() > 0 ) {
				
				for(String fName : fList2) {
					// move back
					fUtil.moveBack(path, fName);
				}
				
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			logError(CommonUtil.printStackTraceToString(e));
		}	
	}
}
