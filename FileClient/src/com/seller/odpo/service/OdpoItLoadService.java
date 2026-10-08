package com.seller.odpo.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.odpo.dao.OdpoItDao;

public class OdpoItLoadService extends FileService implements Runnable {
	private Logger log = Logger.getLogger(this.getClass());
	private OdpoItDao dao = new OdpoItDao();

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
							for(Map<String, String> item : this.rMaps) {
								try {
									dao.mergeOdpoItemInfo(item);	
								} catch (Exception e) {
									dao.logWrite(item);
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
						logInfo("file Success : " + fName );
						// 정지여부.
						if (isBreak) break;
					} catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
						e.printStackTrace();
					}
				}
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}