package com.master.mall.service;

import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtVo;
import com.master.mall.dao.WmsBarDao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.sntd.dao.SntdGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.FileUtil;
 
public class WmsBarLoadService extends FileService implements Runnable{

	private WmsBarDao dao = new WmsBarDao();
	
	@Override
	public void run() {
		boolean isBreak = false;
		
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			System.out.println(path);
			List<String> fList = fUtil.getFileList(path, prefix);
			System.out.println(fList);
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
								
								this.rMaps.add(iMap);
								
							} else if ("T".equals(iMap.get("TYPE"))) {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
							
						}
						
						if (lineCnt == totCnt && lineCnt > 0) {
	//						// 정상 처리
							
							for(Map<String, String> item : this.rMaps) {
								// if_podt 생성 및 변경
								String ifChkFlag = "N";
								
								boolean bRtn = dao.insertWmsBar(item);
								
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error / " + fName);
									System.out.println("비정상처리");
									Map<String, String> lMap = new HashMap<String, String>();
									lMap.put("BUYER", "KRKORE0001");
									lMap.put("REVISION", "00");
									lMap.put("GUBUN", "XX");
									lMap.put("IF_CHK_FLAG", "E");
									lMap.put("FILE_NAME", fName);
									lMap.put("LEGACY_NO", item.get("LEGACY_PO_NO"));
									dao.logWrite(lMap); 
									logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
									isBreak = true;
								}
							}
							logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
	
						} else {
							// 비정상 처리.
							System.out.println("비정상처리2");
						
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
