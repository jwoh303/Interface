package com.buyer.msmi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.msmi.dao.MsmiPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.kep.common.vo.PodtVo;

public class MsmiPoLoadService extends FileService implements Runnable {

	private MsmiPoDao dao = new MsmiPoDao();
	
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
							String fNameList [] = fName.split("_");
							if ("SI".equals(fNameList[1])) {
								logInfo("file info : " + fName);
								List<String> fContent = fUtil.getFileContent(path, fName, charset);
								int lineCnt = 0;
								int totCnt = 0;
								int eCnt = 0;
								this.rMaps.clear();
								
								for(String line : fContent) {
									Map<String, String> iMap = convertStringToMap(line);
									System.out.println("iMap1 = " + iMap);
									if ("C".equals(iMap.get("DATA_CLASSIFICATION")) || "O".equals(iMap.get("DATA_CLASSIFICATION")) || "H".equals(iMap.get("DATA_CLASSIFICATION"))) {
										lineCnt++;
										Map<String, String> pMap = new HashMap<String, String>();
										pMap.put("BUYER","KRMISU0014");
										pMap.put("LEGACY_PO_NO",iMap.get("GLOBAL_NUMBER"));
										pMap.put("LEGACY_PO_SEQ", "001");
										pMap.put("REVISION", "00");
										
										if ("O".equals(iMap.get("DATA_CLASSIFICATION"))) {
											pMap.put("STATUS", "C");
										} else if ("H".equals(iMap.get("DATA_CLASSIFICATION"))) {
											pMap.put("STATUS", "R");
										} else if ("C".equals(iMap.get("DATA_CLASSIFICATION"))) {
											pMap.put("STATUS", "D");
										} else {
											pMap.put("STATUS", iMap.get("DATA_CLASSIFICATION"));
										}
										pMap.put("BUYER_ITEM_NO", iMap.get("PRODUCT_CODE_FOR_PO"));
										
										Map<String, String> tMap = dao.MsmiPo_getBuyerItemNo(iMap);
										
										pMap.put("BUYER_ITEM_NO", tMap.get("BUYER_ITEM_NO"));
										pMap.put("REF_IF_NO", iMap.get("PRODUCT_CODE"));
										pMap.put("ADD_DATE", iMap.get("PO_DATE"));
										pMap.put("RD_DATE", iMap.get("MISUMI_RECEIVED_DATE"));
										pMap.put("DESCRIPTION", iMap.get("PRODUCT_NAME"));
										pMap.put("ITEM_QTY", iMap.get("QTY"));
										pMap.put("PLANT", iMap.get("PLANT"));
										pMap.put("UNIT_PRICE", iMap.get("PURCHASE_UNIT_PRICE"));
										pMap.put("CURRENCY_CODE", iMap.get("PURCHASE_CURRENCY_CODE"));
										pMap.put("DELY_TO_LOCATION_FLAG", "Y");
										pMap.put("LEGACY_PR_NO",iMap.get("SUPPLIER_CODE"));
										pMap.put("LEGACY_PR_NO",iMap.get("SUPPLIER_CODE"));
										pMap.put("LOAD_DATE",tMap.get("LOAD_DATE"));
										pMap.put("LOAD_TIME",tMap.get("LOAD_TIME"));
										pMap.put("ITEM_AMT", iMap.get("PURCHASE_AMOUNT"));
										pMap.put("UNIT_QTY", iMap.get("PO_QTY_PER_CARTON"));
										
										if ("8622".equals(iMap.get("SUPPLIER_CODE"))) {
											pMap.put("IF_FLAG", "E");
										} else {
											pMap.put("IF_FLAG", "N");
										}
										pMap.put("IV_COLUMN", tMap.get("IV_COLUMN"));
										pMap.put("DELY_TO_LOCATION_TEXT", tMap.get("DELY_TO_LOCATION_TEXT"));
										pMap.put("PURCHASER_USER_ID", "WOOJH");
									
										dao.POIFLOAD_Insert2(iMap);
										System.out.println("pMap = " + pMap);
										rMaps.add(pMap);
									}
								}
								if (lineCnt > 0 ) {
									String ifChkFlag = "N";
									String prevKey = "";
									Map<String, String> pItem = new HashMap<String, String>();
									
									for(Map<String, String> item : this.rMaps) {
										String nextKey = item.get("BUYER") + item.get("LEGACY_PO_NO") + item.get("LEGACY_PO_SEQ");
										if(  !prevKey.equals(nextKey)) {
											// if_progress 생성 및 반영
											if(!"".equals(prevKey)) {
												Map<String, String> lMap = new HashMap<String, String>();
												lMap.put("BUYER", pItem.get("BUYER"));
												lMap.put("GUBUN", "PO");
												lMap.put("LEGACY_NO", pItem.get("LEGACY_PO_NO"));
												lMap.put("LEGACY_PO_NO", pItem.get("LEGACY_PO_NO"));
												lMap.put("REVISION", "00");
												lMap.put("IF_CHK_FLAG", ifChkFlag);
												
												dao.logWrite(lMap);
											}
											prevKey = nextKey;
											pItem = item;
										}
										dao.Msmi_POIFLOAD_Insert(item);
									}
									Map<String, String> lMap = new HashMap<String, String>();
									lMap.put("BUYER", pItem.get("BUYER"));
									lMap.put("GUBUN", "PO");
									lMap.put("LEGACY_NO", pItem.get("LEGACY_PO_NO"));
									lMap.put("LEGACY_PO_NO", pItem.get("LEGACY_PO_NO"));
									lMap.put("REVISION", "00");
									lMap.put("IF_CHK_FLAG", ifChkFlag);
									
									dao.logWrite(lMap);
								} else {
									// 비정상 처리.
									logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
									isBreak = true;
								}
								// move back
								fUtil.moveBack(path, fName);
								logInfo("file Success : " + fName);
								// 정지여부.
								if (isBreak) break;
							}
						} catch (Exception e) {
							e.printStackTrace();
							logError(CommonUtil.printStackTraceToString(e));
						}
						
					}
				}
		   
		} catch (Exception e) {
			e.printStackTrace();
			logError(CommonUtil.printStackTraceToString(e));
		}	
	}
}
