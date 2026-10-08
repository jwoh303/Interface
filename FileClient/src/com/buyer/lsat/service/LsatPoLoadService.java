/**
 * 
 */
package com.buyer.lsat.service;

import java.util.List;
import java.util.Map;

import com.buyer.lsat.dao.LsatPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

/**
 * @author jiwon
 *
 */
public class LsatPoLoadService extends FileService implements Runnable {
	private LsatPoDao dao = new LsatPoDao();
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
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						int eCnt = 0;
						this.rMaps.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
//							if ("C".equals(iMap.get("STATUS"))) {
								lineCnt++;
								//KRLS-A0001
//								iMap.put("BUYER", "LSAT");
								iMap.put("FILE_NAME", fName);
								
								this.rMaps.add(iMap);
//							}
							
						}
						if(lineCnt > 0 ) {
							for(Map<String, String> item : this.rMaps) {
								boolean bRtn = dao.insertPodtLSAT(item);
								if (bRtn == false ) {
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+item.get("BANFN")+" / "+item.get("BNFPO")+" ]");
									dao.LsatMailSend(item);
								}
							}
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