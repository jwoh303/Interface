package com.buyer.daed.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daed.dao.DeadGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;

public class DaedGrLoadService extends FileService implements Runnable{
	
	private DeadGrDao dao = new DeadGrDao();
	
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
						
						if ("I".equals(iMap.get("GOODS_MVT_TYPE")) || "R".equals(iMap.get("GOODS_MVT_TYPE"))) {
							lineCnt++;
							
							iMap.put("BUYER", "DAED");
							
							Map<String, String> tMap = new HashMap<String, String>();
							
							tMap.put("BUYER","KRDAED0079");
							tMap.put("REVISION","00");
							tMap.put("STATUS","C");
							tMap.put("PRODUCT_ID", iMap.get("PRODUCT_ID"));
							
							String gr_qty[] = iMap.get("GR_QTY").split("\\."); 
							
							System.out.println("iMap.get(\"GR_QTY\")  = " + iMap.get("GR_QTY"));
							for (int i = 0; i<gr_qty.length; i++) {
								System.out.println("gr_qty " + i + " = " + gr_qty[i]);
							}
							tMap.put("GR_QTY", gr_qty[0]);
							Map<String, String> pMap = dao.Daed_getBuyerItemNo(tMap);
							
							tMap.put("BUYER_ITEM_NO", pMap.get("BUYER_ITEM_NO"));
							
							if("I".equals(iMap.get("GOODS_MVT_TYPE"))) {
								int qty = Integer.parseInt(tMap.get("GR_QTY")) * -1;
								String str_qty = Integer.toString(qty);
								
								tMap.put("GR_QTY",str_qty);
							} else {
								tMap.put("GR_QTY",gr_qty[0]);
							}
							
							int gr_amt = Integer.parseInt(tMap.get("GR_QTY")) * Integer.parseInt(iMap.get("UNIT_PRICE"));
							tMap.put("GR_AMT", Integer.toString(gr_amt));
							
							this.rMaps.add(iMap);
						}
						
					}
					
					
					if(lineCnt > 0 ) {
						for(Map<String, String> item : this.rMaps) {
							dao.insertGrdtDAED(item);
						}
						logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
					} else {
						// 비정상 처리.
						logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
						isBreak = true;
					}
					// move back
					fUtil.moveBack_DAED(path, fName);
					// 정지여부.
					if (isBreak) break;
				}
			}	
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
	}
}
