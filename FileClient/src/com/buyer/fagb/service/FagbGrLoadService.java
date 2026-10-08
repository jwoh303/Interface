package com.buyer.fagb.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.buyer.fagb.dao.FagbGrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class FagbGrLoadService extends FileService implements Runnable {
	
	private FagbGrDao dao = new FagbGrDao();
	
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
						String gubun = line.substring(0, 1);
						if ("D".equals(gubun)) {
							Map<String, String> iMap = convertStringToMap(line);
							lineCnt++;
							/**
							 * 체크로직 및 데이터 세팅
							 */
							iMap.put("BUYER","FAGB");
							iMap.put("FILE_NAME",fName);
							iMap.put("STATUS","C");
							iMap.put("REVISION","00");
							iMap.put("LEGACY_INV_NO"," ");
							iMap.put("ERROR_MSG"," ");
							iMap.put("IF_FLAG","N");
							this.rMaps.add(iMap);
						} else if ("T".equals(gubun)) {
							Map<String, String> iMap = convertStringToMap(line);
							totCnt = Integer.parseInt(iMap.get("TOT_CNT"));
						}
					}
					/**
					 * tCnt(데이터실 개수), totCnt(체크섬 개수) 가 같은지 확인한다.
					 */
					if (lineCnt == totCnt && lineCnt > 0) {
						// 정상 처리
						for(Map<String, String> item : this.rMaps) {
							dao.insertFagbGr(item);
						}
						logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
					} else {
						// 비정상 처리.
						logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
						isBreak = true;
					}
					// move back
					fUtil.moveBack(path, fName);
					// 정지여부.
					if (isBreak) break;
				}
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
	}
}