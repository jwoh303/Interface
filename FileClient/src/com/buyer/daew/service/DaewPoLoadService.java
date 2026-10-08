package com.buyer.daew.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class DaewPoLoadService extends FileService implements Runnable  {
	
	DaewPoDao dao = new DaewPoDao();
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
						logInfo("file info : " + path + "/" + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						this.rMaps.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap_DAEW_PO(line);
							String gubun = iMap.get("RECORD_SECT");
							
							if("D".equals(gubun)) {
								lineCnt++;
								
								iMap.put("BUYER","KRDAEW0016");
								iMap.put("REVISION", "00");
								iMap.put("STATUS", "C");
								if ("".equals(iMap.get("CURRENCY_CODE")) ||  " ".equals(iMap.get("CURRENCY_CODE"))) {
									iMap.put("STATUS", "D");
									dao.updateIfPodt(iMap);
								}
								if ("".equals(iMap.get("ISS_REQ_LOC")) ||  " ".equals(iMap.get("ISS_REQ_LOC"))) {
									iMap.put("ISS_REQ_LOC", " ");
								}
								Map <String, String> pMap = dao.Check04(iMap);
								Map <String, String> tMap = dao.Check01(iMap);
								
								if (pMap == null) {
									iMap.put("AGENT", " ");
									iMap.put("CONTRACT_NO", " ");
									iMap.put("CONTRACT_SEQ", " ");
								}else {
									iMap.put("AGENT", pMap.get("AGENT"));
									iMap.put("CONTRACT_NO", pMap.get("CONTRACT_NO"));
									iMap.put("CONTRACT_SEQ", pMap.get("CONTRACT_SEQ"));
								}
								if (tMap == null) {
	//								iMap.put("PURCHASER_USER_ID"," ");
	//								iMap.put("PURCHASER_USER_DEPT"," ");
								}else {
									iMap.put("PURCHASER_USER_ID", tMap.get("PURCHASER_USER_ID"));
									iMap.put("PURCHASER_USER_DEPT", tMap.get("PURCHASER_USER_DEPT"));
								}
								
								String unit_price[] = iMap.get("UNIT_PRICE").split("\\.");
								String target_qty[] = iMap.get("TARGET_QTY").split("\\.");
								String item_amt[] = iMap.get("ITEM_AMT").split("\\.");
								
								iMap.put("UNIT_PRICE",unit_price[0]);
								iMap.put("TARGET_QTY",target_qty[0]);
								iMap.put("ITEM_QTY",target_qty[0]);
								iMap.put("ITEM_AMT",item_amt[0]);
								iMap.put("REF_IF_NO", iMap.get("ISS_REQ_LOC"));
								iMap.put("REMARK", iMap.get("ISS_REQ_LOC_NAME"));
								
								iMap.put("BUYER","DAEW");
								
								this.rMaps.add(iMap);
							} 
						}
						
						if (lineCnt > 0) {
							// 정상 처리
							for(Map<String,String> item : this.rMaps) {
								dao.insertPodtUC(item);
							}
						} else {
							// 비정상 처리.
							// logWrite 기능 추가 여부 확인...
							logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
							isBreak = true;
						}
						// move back
						fUtil.moveBack(path, fName);
						logInfo("file Success : " + fName);
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
