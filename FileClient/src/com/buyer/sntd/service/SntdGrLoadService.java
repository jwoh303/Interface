package com.buyer.sntd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.sntd.dao.SntdGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.kep.common.FileUtil;
import com.kep.common.vo.GrdtVo;

public class SntdGrLoadService extends FileService implements Runnable{

private SntdGrDao dao = new SntdGrDao();
	
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
						this.grList.clear();
						
						for(String line : fContent) {
							String gubun = line.substring(0, 1);
							GrdtVo item = (GrdtVo) convertStringToVo(line, new GrdtVo());
							if ("D".equals(gubun)) {
								lineCnt++;
								
								String plant = item.getPLANT();
								
								if ("50".equals(plant)) {
									item.setBUYER("KRSNTD0003");
								}
								else {
									item.setBUYER("KRSNTD0001");
								};
								
								item.setFILE_NAME(fName);
								item.setREVISION("00");
								item.setIF_FLAG("N");
								item.setERROR_MSG("");
								
								this.grList.add(item);
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
							System.out.println("정상처리");
							String ifChkFlag = "N";
							String prevKey = "";
							GrdtVo gItem = null;
							
							for(GrdtVo item : this.grList) {
								String nextKey = item.getBUYER() + item.getLEGACY_PO_NO() +item.getLEGACY_GR_NO() + item.getREVISION();
								System.out.println("nextKey = " + nextKey);
								
								if(!prevKey.equals(nextKey)) {
									// if_progress 생성 및 반영
									if(!"".equals(prevKey)) {
									System.out.print( " item.getLEGACY_GR_NO() : " + gItem.getLEGACY_GR_NO() + "                  ");
									
									Map<String, String> lMap = new HashMap<String, String>();
									lMap.put("BUYER", gItem.getBUYER());
									lMap.put("GUBUN", "GR");
									lMap.put("LEGACY_NO", gItem.getLEGACY_GR_NO());
									lMap.put("LEGACY_GR_NO", gItem.getLEGACY_GR_NO());
									lMap.put("REVISION", gItem.getREVISION());
									lMap.put("FILE_NAME", gItem.getFILE_NAME());
									lMap.put("IF_CHK_FLAG", ifChkFlag);
									dao.logWrite(lMap);
									}
									gItem = item;
									prevKey = nextKey;									
								}
								// if_podt 생성 및 변경
								boolean bRtn = dao.insertSntdGr(item);
								
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+item.getLEGACY_PO_NO()+" / "+item.getLEGACY_PO_SEQ()+ " / " + item.getLEGACY_PO_NO()+" / "+item.getLEGACY_PO_SEQ() + " ]");
								}
								
							}
							
							Map<String, String> lMap = new HashMap<String, String>();
							lMap.put("BUYER", gItem.getBUYER());
							lMap.put("GUBUN", "GR");
							lMap.put("LEGACY_GR_NO", gItem.getLEGACY_GR_NO());
							lMap.put("LEGACY_NO", gItem.getLEGACY_GR_NO());
							lMap.put("REVISION", gItem.getREVISION());
							lMap.put("FILE_NAME", gItem.getFILE_NAME());
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
