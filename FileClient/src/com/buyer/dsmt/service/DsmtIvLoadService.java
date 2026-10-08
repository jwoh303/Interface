package com.buyer.dsmt.service;

import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtUCVo;
import com.kep.common.vo.IvdtUCVo;

public class DsmtIvLoadService extends FileService implements Runnable{
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
						this.ivUcList.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							IvdtUCVo tVo = (IvdtUCVo) convertStringToVo(line, new IvdtUCVo());
							String gubun = iMap.get("TYPE");
							
							if ("D".equals(gubun)) {
								lineCnt++;
								
								tVo.setBUYER("DSMT");
								tVo.setSITE("KA");
								tVo.setREVISION("00");
								tVo.setSTATUS("C");
								this.ivUcList.add(tVo);
								
							}else {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
							
						}
						
						if (lineCnt == totCnt && lineCnt > 0) {
							// 정상 처리
							for(IvdtUCVo item : this.ivUcList) {
								dao.insertIvdtUC(item);
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
