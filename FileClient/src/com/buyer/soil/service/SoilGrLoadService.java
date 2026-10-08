package com.buyer.soil.service;

import java.util.List;

import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtUCVo;

public class SoilGrLoadService extends FileService implements Runnable {
	
	private FileDao dao = new FileDao();

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
						this.poUcList.clear();
	
						for(String line : fContent) {
							GrdtUCVo tVo = (GrdtUCVo) convertStringToVo(line, new GrdtUCVo());
							tVo.setBUYER("SOIL");
							tVo.setSITE("KA");
							tVo.setREVISION("00");
							tVo.setFILE_NAME(fName);
							tVo.setSTATUS("C");
							
							String tLegacyGrNo = tVo.getREF_IF_NO() + tVo.getLEGACY_GR_NO();
							tVo.setREF_IF_NO("");
							tVo.setLEGACY_GR_NO(tLegacyGrNo);
							
							this.grUcList.add(tVo);
							
							lineCnt++;
						}
						
						totCnt = lineCnt;
	
						/**
						 * 데이터 세팅 및 저장.
						 */
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							for(GrdtUCVo item : this.grUcList) {
								dao.insertGrdtUC(item);
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
