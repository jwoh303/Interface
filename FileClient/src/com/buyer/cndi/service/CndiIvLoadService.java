package com.buyer.cndi.service;

import java.util.List;
import java.util.Map;

import com.buyer.cndi.dao.CndiIvDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class CndiIvLoadService extends FileService implements Runnable {
	
	private CndiIvDao dao = new CndiIvDao();

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
					logInfo("file info : " + path + "/" + fName);
					List<String> fContent = fUtil.getFileContent(path, fName, charset);
					int lineCnt = 0;
					int totCnt = 0;
					int eCnt = 0;
					this.rMaps.clear();

					for(String line : fContent) {
						Map<String, String> iMap = convertStringToMap(line);
						if ("D".equals(iMap.get("TYPE"))) {
							iMap.put("SITE", "KA");
							iMap.put("BUYER", "CNDI");
							iMap.put("REVISION", "01");
							iMap.put("STATUS", "C");
							iMap.put("IF_FLAG", "N");
							iMap.put("FILE_NAME", fName);
							
							lineCnt++;
							this.rMaps.add(iMap);
						} else if ("T".equals(iMap.get("TYPE"))) {
							totCnt = Integer.parseInt(iMap.get("TOT_CNT"));
						}
					}
					
					/**
					 * 데이터 세팅 및 저장.
					 */
					if (lineCnt == totCnt && lineCnt > 0) {
						// 정상 처리
						for(Map<String, String> item : this.rMaps) {
							try {
								dao.insertCndiIv(item);
								
							} catch (Exception e) {
								logError(CommonUtil.printStackTraceToString(e));
							}
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
				}
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
	}
}