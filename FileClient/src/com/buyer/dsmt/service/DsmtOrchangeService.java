package com.buyer.dsmt.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.dsmt.dao.DsmtOrchangeDao;
import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.IvdtUCVo;

public class DsmtOrchangeService extends FileService implements Runnable{
	private DsmtOrchangeDao dao = new DsmtOrchangeDao();
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
						int eCnt = 0;
						int ret = 0;
						this.rMaps.clear();
						SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
						Date time = new Date();
						String ntime = dFormat.format(time);
						
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							
							if ("D".equals(iMap.get("TYPE"))) {
								lineCnt++;
								iMap.put("PO_CREATE_DATE",ntime);
								iMap.put("PO_CREATE_SEQ",Integer.toString(lineCnt));
								this.rMaps.add(iMap);
								
							} else if ("T".equals(iMap.get("TYPE"))) {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
							
						}
						
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							
							for(Map<String, String> item : this.rMaps) {
								String ifChkFlag = "N";
								// if_podt 생성 및 변경
								item.put("FILE_NAME",fName);
								boolean bRtn = dao.DI_ORDER_CHANGE_INSERT(item);
								
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error / " + fName);
								} else {
									ret = 0;
									// TODO : 두산공작기계 로직 확인 중. 해당 코드는 일단 주석 처리한다.
	//								if("D".equals(item.get("TYPE")) && Double.valueOf(item.get("MENGE_GR")) == 0.000) {
	//									item.put("STATUS","D");
	//									ret = 1;
	//								} else 
									if ("D".equals(item.get("TYPE")) && Double.valueOf(item.get("MENGE_GR")) != 0.000) {
										item.put("STATUS","R");
										item.put("ITEM_QTY",item.get("MENGE_GR"));
										ret = 1;
									} else if ("C".equals(item.get("TYPE"))) {
										item.put("STATUS","R");
										double total = Double.valueOf(item.get("MENGE_GR")) +  Double.valueOf(item.get("MENGE_N"));
										item.put("ITEM_QTY", Double.toString(total));
										ret = 1;
									}
									if (ret == 1) {
										dao.IF_PODT_Update(item);
									}
								}
							}
							logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
							
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
