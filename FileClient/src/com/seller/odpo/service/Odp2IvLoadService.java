package com.seller.odpo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.odpo.dao.Odpo2IvDao;

public class Odp2IvLoadService extends FileService implements Runnable {
	private Logger log = Logger.getLogger(this.getClass());
	private Odpo2IvDao dao = new Odpo2IvDao();

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
							Map<String, String> iMap = convertStringToMap_ODPO2(line);
							if ("D".equals(iMap.get("RECORD_SECT"))) {
								lineCnt++;
								System.out.println("iMap = " + iMap);
								iMap.put("BUYER","KRKORE0001C001");
								iMap.put("LEGACY_IV_NO",iMap.get("DLVY_SER_NO"));
								iMap.put("LEGACY_IV_SEQ",iMap.get("DLVY_SER_SEQ"));
								iMap.put("REVISION", "00");
								iMap.put("INVOICE_DATE",iMap.get("DLVY_DUE_DATE"));
								iMap.put("INV_QTY",iMap.get("DLVY_DUE_QTY"));
								iMap.put("REMARK",iMap.get("SHP_CMP_CD"));
								iMap.put("SHP_CMP_CD", " ");
								iMap.put("WYBIL_NO", " ");
								
								if ("HYUNDAI".equals(iMap.get("REMARK"))) {
									iMap.put("SHP_CMP_CD", "10002");
								} else if ("CJGLS".equals(iMap.get("REMARK"))) {
									iMap.put("SHP_CMP_CD", "10003");
								}
								
								iMap.put("DELIVERY_QTY",iMap.get("INV_QTY"));
								iMap.put("DELIVERY_DATE",iMap.get("INVOICE_DATE"));
								
								Map<String,String> pMap = dao.check01(iMap);
		
								if (pMap.size() > 0) {
									iMap.put("BUYER",pMap.get("BUYER"));
									iMap.put("PLCORD_NO",pMap.get("PLCORD_NO"));
									iMap.put("PLCORD_SEQ",pMap.get("PLCORD_SEQ"));
									iMap.put("PO_NO",pMap.get("PO_NO"));
									iMap.put("PO_SEQ",pMap.get("PO_SEQ"));
									iMap.put("LEGACY_PO_NO",pMap.get("PO_NO"));
								} else {
									Map<String,String> tMap = dao.check02(iMap);
									
									if (tMap.size() > 0 ) {
										iMap.put("BUYER",tMap.get("BUYER"));
										iMap.put("PLCORD_NO",tMap.get("PLCORD_NO"));
										iMap.put("PLCORD_SEQ",tMap.get("PLCORD_SEQ"));
										iMap.put("PO_NO",tMap.get("PO_NO"));
										iMap.put("PO_SEQ",tMap.get("PO_SEQ"));
									} else {
										iMap.put("BUYER","");
										iMap.put("PLCORD_NO","");
										iMap.put("PLCORD_SEQ","");
										iMap.put("PO_NO","");
										iMap.put("PO_SEQ","");
									}
								}
								
								this.rMaps.add(iMap);
							}
							
						}	
						
						if (lineCnt > 0) {
							// 정상 처리
							String ifChkFlag = "N";
							String prevKey = "";
							Map<String,String> pItem = null;
							
							for(Map<String,String> item : this.rMaps) {
								String nextKey = item.get("BUYER") + item.get("LEGACY_IV_NO");
								System.out.println("prevKey = "+ prevKey);
								System.out.println("nextKey = "+ nextKey);
								if(  !prevKey.equals(nextKey)) {
									// if_progress 생성 및 반영
									if(!"".equals(prevKey)) {
										Map<String, String> lMap = new HashMap<String, String>();
										
										lMap.put("BUYER", pItem.get("BUYER"));
										lMap.put("GUBUN", "IV");
										lMap.put("LEGACY_NO", pItem.get("LEGACY_IV_NO"));
										lMap.put("LEGACY_IV_NO", pItem.get("LEGACY_IV_NO"));
										lMap.put("REVISION", "00");
										lMap.put("FILE_NAME", pItem.get("FILE_NAME"));
										lMap.put("IF_CHK_FLAG", ifChkFlag);
										
										dao.logWrite(lMap);
									}
									pItem = item;
									prevKey = nextKey;
								}
								// if_podt 생성 및 변경
								boolean bRtn = dao.InsertOpdo2Iv(item);
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+ item.get("BUYER") + "/"  +item.get("LEGACY_PO_NO") + "/"  +item.get("LEGACY_PO_SEQ") + " ]");
								}		
							}
							System.out.println("pItem = "+ pItem);
							Map<String, String> lMap = new HashMap<String, String>();
							lMap.put("BUYER", pItem.get("BUYER"));
							lMap.put("GUBUN", "IV");
							lMap.put("LEGACY_NO", pItem.get("LEGACY_IV_NO"));
							lMap.put("LEGACY_IV_NO", pItem.get("LEGACY_IV_NO"));
							lMap.put("REVISION", "00");
							lMap.put("FILE_NAME", pItem.get("FILE_NAME"));
							lMap.put("IF_CHK_FLAG", ifChkFlag);
							System.out.println(lMap);
							dao.logWrite(lMap);
							
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
