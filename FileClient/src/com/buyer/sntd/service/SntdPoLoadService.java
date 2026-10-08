package com.buyer.sntd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.buyer.sntd.dao.SntdPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.FileUtil;
import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtVo;
import com.kep.common.vo.PodtVo;


public class SntdPoLoadService extends FileService implements Runnable {
	
private SntdPoDao dao = new SntdPoDao();
	
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
						this.poList.clear();
						
						for(String line : fContent) {
							String gubun = line.substring(0, 1);
							PodtVo item = (PodtVo) convertStringToVo(line, new PodtVo());
							if ("D".equals(gubun)) {
								lineCnt++;
								String plant = item.getPLANT();
								
								if ("50".equals(plant)) {
									item.setBUYER("KRSNTD0003");
									item.setDELY_TO_LOCATION("D002");
									item.setDOC_TYPE("N");
								} else {
									item.setBUYER("KRSNTD0001");
									item.setDELY_TO_LOCATION("D001");
									item.setDOC_TYPE("S");
								};
								item.setFILE_NAME(fName);
								item.setREVISION("00");
								item.setPURCHASER_USER_DEPT(" ");
								item.setREQ_USER_ID(" ");
								item.setREQ_USER_DEPT(" ");
								item.setERROR_MSG(" ");
								item.setSELLER(" ");
								item.setIF_FLAG("N");
								
								this.poList.add(item);
							} else if ("T".equals(gubun)) {
								Map<String, String> iMap = convertStringToMap(line);
								totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
						}
						/**
						 * tCnt(데이터실 개수), totCnt(체크섬 개수) 가 같은지 확인한다.
						 */
						
						
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							String ifChkFlag = "N";
							String prevKey = "";
							PodtVo pItem = null;
							
							for(PodtVo item : this.poList) {
								String nextKey = item.getBUYER() + item.getLEGACY_PO_NO() + item.getREVISION();
								if(  !prevKey.equals(nextKey)) {
									// if_progress 생성 및 반영
									if(!"".equals(prevKey)) {
										Map<String, String> lMap = new HashMap<String, String>();
										lMap.put("BUYER", pItem.getBUYER());
										lMap.put("GUBUN", "PO");
										lMap.put("LEGACY_NO", pItem.getLEGACY_PO_NO());
										lMap.put("LEGACY_PO_NO", pItem.getLEGACY_PO_NO());
										lMap.put("REVISION", pItem.getREVISION());
										lMap.put("FILE_NAME", pItem.getFILE_NAME());
										lMap.put("IF_CHK_FLAG", ifChkFlag);
										
										dao.logWrite(lMap);
									}
									pItem = item;
									prevKey = nextKey;
								}
								// if_podt 생성 및 변경
								boolean bRtn = dao.insertSntdPo(item);
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+item.getLEGACY_PO_NO()+" / "+item.getLEGACY_PO_SEQ()+ " / " + item.getLEGACY_PO_NO()+" / "+item.getLEGACY_PO_SEQ() + " ]");
								}		
							}
							Map<String, String> lMap = new HashMap<String, String>();
							lMap.put("BUYER", pItem.getBUYER());
							lMap.put("GUBUN", "PO");
							lMap.put("LEGACY_PO_NO", pItem.getLEGACY_PO_NO());
							lMap.put("LEGACY_NO", pItem.getLEGACY_PO_NO());
							lMap.put("REVISION", pItem.getREVISION());
							lMap.put("FILE_NAME", pItem.getFILE_NAME());
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
						e.printStackTrace();
						logError(CommonUtil.printStackTraceToString(e));
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logError(CommonUtil.printStackTraceToString(e));
		}
		logInfo("Class Finish : " + this.getClass().getName());
	}
}
