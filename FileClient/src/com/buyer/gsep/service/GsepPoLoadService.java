package com.buyer.gsep.service;

import java.util.List;

import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.PodtUCVo;
import java.util.Date;
import java.text.SimpleDateFormat;

public class GsepPoLoadService extends FileService implements Runnable {
	
	private FileDao dao = new FileDao();

	@Override
	public void run() {
		boolean isBreak = false;
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			SimpleDateFormat toDateFormat = new SimpleDateFormat("yyyyMMdd");
			Date curDate = new Date();
			String toDate = toDateFormat.format(curDate);
			if (fList.size() > 0) {

				for(String fName : fList) {
					try {
						logInfo("file info : " + path + "/" + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						this.poUcList.clear();
	
						for(String line : fContent) {
							PodtUCVo tVo = (PodtUCVo) convertStringToVo(line, new PodtUCVo());
							tVo.setBUYER("GSEP");
							tVo.setSITE("KA");
							tVo.setREVISION("00");
							tVo.setFILE_NAME(fName);
							tVo.setSTATUS("C");
							tVo.setADD_DATE(toDate);
							String delyToAddress = tVo.getDELY_TO_LOCATION() + " " + tVo.getDELY_TO_LOCATION_TEXT();
							tVo.setDELY_TO_LOCATION_TEXT(delyToAddress);
							tVo.setDELY_TO_LOCATION("");
							
							this.poUcList.add(tVo);
							
							lineCnt++;
						}
						
						totCnt = lineCnt;
						/**
						 * 데이터 세팅 및 저장.
						 */
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							for(PodtUCVo item : this.poUcList) {
								dao.insertPodtUC(item);
							}
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
					}
				}
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
	}
}
