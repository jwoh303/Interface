package com.buyer.msmi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.msmi.dao.MsmiGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class MsmiGrXLoadService extends FileService implements Runnable {
	private MsmiGrDao dao = new MsmiGrDao();
	
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
					logInfo("file info : " + fName);
					List<String> fContent = fUtil.getFileContent(path, fName, charset);
					int lineCnt = 0;
					int totCnt = 0;
					int eCnt = 0;
					this.rMaps.clear();
					
					for(String line : fContent) {
						Map<String, String> iMap = convertStringToMap(line);
						
						if ("S".equals(iMap.get("DATA_CLASSIFICATION"))) {
							lineCnt++;
							Map<String, String> tMap = new HashMap<String, String>();
							
							tMap.put("BUYER","KRMISU0014");
							tMap.put("REVISION","00");
							tMap.put("LEGACY_PO_NO",iMap.get("GLOBAL_NUMBER"));
							tMap.put("LEGACY_PO_SEQ","001");
							tMap.put("LEGACY_GR_SEQ","001");
							
							Map<String, String> pMap = dao.Msmi_getBuyerItemNo(tMap);
							
							tMap.put("BUYER_ITEM_NO",pMap.get("BUYER_ITEM_NO"));
							tMap.put("UNIT_PRICE",String.valueOf(pMap.get("UNIT_PRICE")));
							tMap.put("ERROR_MSG", " ");
							tMap.put("FILE_NAME",fName);
							tMap.put("LOAD_DATE",pMap.get("LOAD_DATE"));
							tMap.put("LOAD_TIME",pMap.get("LOAD_TIME"));
							tMap.put("IF_FLAG", "N");
							tMap.put("GR_QTY",iMap.get("GR_QTY"));
							tMap.put("GR_DATE",iMap.get("GR_DATE"));
							tMap.put("GR_AMT",iMap.get("GR_AMT"));
							tMap.put("LEGACY_GR_NO",iMap.get("LEGACY_GR_NO"));
							
							this.rMaps.add(tMap);
						} 
					}
					
					if (lineCnt > 0) {
						String ifChkFlag = "N";
						String prevKey = "";
						Map<String, String> pItem = new HashMap<String, String>();
						
						for(Map<String, String> item : this.rMaps) {
							String nextKey = item.get("BUYER") + item.get("LEGACY_PO_NO") + item.get("REVISION") + item.get("LEGACY_GR_NO");
							if(  !prevKey.equals(nextKey)) {
								// if_progress 생성 및 반영
								if(!"".equals(prevKey)) {
									Map<String, String> lMap = new HashMap<String, String>();
									lMap.put("BUYER", item.get("BUYER"));
									lMap.put("GUBUN", "GR");
									lMap.put("LEGACY_NO", item.get("LEGACY_GR_NO"));
									lMap.put("LEGACY_GR_NO", item.get("LEGACY_GR_NO"));
									lMap.put("REVISION", "00");
									lMap.put("IF_CHK_FLAG", ifChkFlag);
									
									dao.logWrite(lMap);
								}
								prevKey = nextKey;
								pItem = item;
							}
							
							dao.Msmi_GRIFLOAD_Insert(item);
						}
						
						Map<String, String> lMap = new HashMap<String, String>();
						lMap.put("BUYER", pItem.get("BUYER"));
						lMap.put("GUBUN", "GR");
						lMap.put("LEGACY_NO", pItem.get("LEGACY_GR_NO"));
						lMap.put("LEGACY_GR_NO", pItem.get("LEGACY_GR_NO"));
						lMap.put("REVISION", "00");
						lMap.put("IF_CHK_FLAG", ifChkFlag);
						
						dao.logWrite(lMap);
						
					} else {
						// 비정상 처리.
						// logWrite 기능 추가 여부 확인...
						logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
						isBreak = true;
					}
					// move back
					fUtil.moveBack(path, fName);
					// 정지여부.
					if (isBreak) break;
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			logError(CommonUtil.printStackTraceToString(e));
		}
		
	}	
}
