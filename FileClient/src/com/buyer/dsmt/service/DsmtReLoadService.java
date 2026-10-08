package com.buyer.dsmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.dsmt.dao.DsmtReLoadDao;
import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.IvdtUCVo;
import com.kep.common.vo.RedtUCVo;

public class DsmtReLoadService extends FileService implements Runnable{

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
						this.reUcList.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							RedtUCVo tVo = (RedtUCVo) convertStringToVo(line, new RedtUCVo());
							String gubun = iMap.get("TYPE");
							if ("D".equals(gubun) || "C".equals(gubun)) {
								lineCnt++;
								
								tVo.setBUYER("DSMT");
								tVo.setSITE("KA");
								tVo.setREVISION("00");
								tVo.setREF_IF_NO( iMap.get("PLANT") + "_" + iMap.get("PR_NO") + "_" + iMap.get("PR_SEQ"));		
								// 250416 규격, 비고(제조사+재질), 재견적 시 이전 견적번호,항번   추가 
								tVo.setSPECIFICATION(tVo.getATWRT_THREAD());
								tVo.setHD_REMARK(tVo.getATWRT_MANUFACTURER() + ";" + tVo.getMATERIAL());
								tVo.setCATEG_NAME1(tVo.getPRE_RFX_NO());
								tVo.setCATEG_NAME2(tVo.getPRE_RFX_SEQ());
								
								this.reUcList.add(tVo);
							} else {
								totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
						}
						if (lineCnt == totCnt && lineCnt > 0) {
							
							for(RedtUCVo item : this.reUcList) {
								dao.insertRedtUC(item);
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
