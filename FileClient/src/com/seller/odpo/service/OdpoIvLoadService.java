package com.seller.odpo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.kep.common.vo.IvdtVo;
import com.kep.common.vo.PodtVo;
import com.seller.odpo.dao.OdpoIvDao;

public class OdpoIvLoadService extends FileService implements Runnable {
	private Logger log = Logger.getLogger(this.getClass());
	private OdpoIvDao dao = new OdpoIvDao();

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
								
								if("CJGLS".equals(iMap.get("PARCEL_COM_CODE"))) {
									iMap.put("PARCEL_COM_CODE","D013");
								} else if ("ODK".equals(iMap.get("PARCEL_COM_CODE"))) {
									iMap.put("PARCEL_COM_CODE"," ");
									iMap.put("PARCEL_INV_NO"," ");
								} else if ("오피스디포".equals(iMap.get("PARCEL_COM_CODE"))) {
									iMap.put("PARCEL_COM_CODE"," ");
									iMap.put("PARCEL_INV_NO"," ");
								} else if ("D".equals(iMap.get("PARCEL_COM_CODE"))) {
									iMap.put("PARCEL_COM_CODE"," ");
									iMap.put("PARCEL_INV_NO"," ");
								}
								Map <String,String> pMap = dao.selectOdpoPoInfo(iMap);
								
								iMap.put("REVISION", "00");
								iMap.put("PO_NO",pMap.get("PO_NO"));
								iMap.put("PO_SEQ",pMap.get("PO_SEQ"));
								
								this.rMaps.add(iMap);
							} else if ("T".equals(iMap.get("TYPE"))) {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT"));
							}
						}
						/**
						 * tCnt(데이터실 개수), totCnt(체크섬 개수) 가 같은지 확인한다.
						 */
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							String ifChkFlag = "N";
							String prevKey = "";
							Map<String,String> pItem = null;
							
							for(Map<String,String> item : this.rMaps) {
								String nextKey = item.get("BUYER") + item.get("LEGACY_IV_NO");
								
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
								boolean bRtn = dao.IVODPOIFLOAD_Insert(item);
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+ item.get("BUYER") + "/"  +item.get("LEGACY_PO_NO") + "/"  +item.get("LEGACY_PO_SEQ") + " ]");
								}		
							}
							Map<String, String> lMap = new HashMap<String, String>();
							lMap.put("BUYER", pItem.get("BUYER"));
							lMap.put("GUBUN", "IV");
							lMap.put("LEGACY_NO", pItem.get("LEGACY_IV_NO"));
							lMap.put("LEGACY_IV_NO", pItem.get("LEGACY_IV_NO"));
							lMap.put("REVISION", "00");
							lMap.put("FILE_NAME", pItem.get("FILE_NAME"));
							lMap.put("IF_CHK_FLAG", ifChkFlag);
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
			
			List<String> fList2 = fUtil.getFileList(path, "IV");
			
			if (fList2.size() > 0 ) {
				
				for(String fName : fList2) {
					// move back
					fUtil.moveBack(path, fName);
				}
				
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}