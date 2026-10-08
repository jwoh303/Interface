package com.buyer.daew.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtUCVo;

public class DaewGrLoadService extends FileService implements Runnable  {
	private DaewGrDao dao = new DaewGrDao();
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
						int t_gr_amt = 0;
						int tot_amt = 0;
						this.rMaps.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap_DAEW_PO(line);
							String gubun = iMap.get("RECORD_SECT");
							
							if("D".equals(gubun)) {
								lineCnt++;
								
								Map<String, String> tMap = new HashMap<String,String>();
								
								tMap.put("BUYER","KRDAEW0016");
								tMap.put("LEGACY_PO_NO",iMap.get("LEGACY_PO_NO"));
								tMap.put("LEGACY_PO_SEQ",iMap.get("LEGACY_PO_SEQ"));
								tMap.put("BUYER_ITEM_NO", iMap.get("BUYER_ITEM_NO"));
								
								if ("".equals(tMap.get("BUYER_ITEM_NO")) || " ".equals(tMap.get("BUYER_ITEM_NO"))) {
									Map<String, String> pMap = dao.getBuyerItemNo(tMap);
									
									iMap.put("BUYER_ITEM_NO",(pMap.get("BUYER_ITEM_NO")));
								}
								
	//							logInfo("iMap : " + iMap);
								if ("".equals(iMap.get("LEGACY_INV_NO")) || " ".equals(iMap.get("LEGACY_INV_NO"))) {
									Map<String,String> pMap = dao.Check03(tMap);
									iMap.put("LEGACY_INV_NO",pMap.get("LEGACY_INV_NO"));
								}
								
								String unit_price []= iMap.get("UNIT_PRICE").split("\\.");
								String gr_qty []= iMap.get("GR_QTY").split("\\.");
								String gr_amt []= iMap.get("GR_AMT").split("\\.");
								String ro_qty []= iMap.get("RO_QTY").split("\\.");
								String ro_amt []= iMap.get("RO_AMT").split("\\.");
								
								iMap.put("UNIT_PRICE",unit_price[0].trim());
								iMap.put("GR_QTY",gr_qty[0].trim());
								iMap.put("GR_AMT",gr_amt[0].trim());
								iMap.put("RO_QTY",ro_qty[0].trim());
								iMap.put("RO_AMT",ro_amt[0].trim());
								
								iMap.put("BUYER","DAEW");
								iMap.put("SITE","KA");
								iMap.put("REVISION","00");
								iMap.put("FILE_NAME",fName);
								iMap.put("STATUS", "C");
								
	//							tot_amt += Integer.parseInt(iMap.get("GR_AMT"));
								
								this.rMaps.add(iMap);
							} else {
	//							totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
	//							t_gr_amt = Integer.parseInt(iMap.get("T_GR_AMT").trim());
							}
						}
						
						if (lineCnt > 0) {
							// 정상 처리
							for(Map<String,String> item : this.rMaps) {
								dao.insertGrdtUC(item);
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
