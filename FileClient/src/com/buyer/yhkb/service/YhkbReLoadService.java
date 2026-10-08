package com.buyer.yhkb.service;

import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.RedtUCVo;

public class YhkbReLoadService extends FileService implements Runnable{
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
					try{
						logInfo("file info : " + path + "/" + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						this.reUcList.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap(line);
							RedtUCVo tVo = (RedtUCVo) convertStringToVo(line, new RedtUCVo());
							String gubun = iMap.get("QUOTATION_NO");
							String quotation = gubun.substring(0, 1);
							System.out.println("quotation = " + quotation);
							System.out.println("iMap = " + iMap);
							if ("6".equals(quotation)) {
								lineCnt++;
								
								tVo.setBUYER("YHKB");
								tVo.setSITE("KA");
								tVo.setREVISION("1");
								tVo.setFILE_NAME(fName);
								tVo.setSTATUS("C");
								if ("".equals(iMap.get("BUYER_ITEM_NO")) || " ".equals(iMap.get("BUYER_ITEM_NO"))) {
									tVo.setBUYER_ITEM_NO("NO_CODE");
								}else {
									Map<String, String> tMap = dao.YHKB_getBuyerItemNo(iMap);
									tVo.setBUYER_ITEM_NO(String.valueOf(tMap.get("BUYER_ITEM_NO")));
								}
								
	//							tVo.setQUOTATION_NO(tVo.getQUOTATION_NO().substring(1, 11));
								this.reUcList.add(tVo);
							} else {
	//							totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
							}
							
						}
						
						if (lineCnt > 0) {
							
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
