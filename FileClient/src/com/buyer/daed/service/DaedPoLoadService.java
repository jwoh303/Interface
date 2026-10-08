package com.buyer.daed.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daed.dao.DaedPoDao;
import com.kep.common.CommonUtil;
import com.kep.common.dao.FileDao;
import com.kep.common.service.FileService;
import com.kep.common.vo.PodtVo;
import com.kep.common.vo.PrdtVo;

public class DaedPoLoadService extends FileService implements Runnable{
	
	private DaedPoDao dao = new DaedPoDao();
	@Override
	public void run() {
		// TODO Auto-generated method stub
		boolean isBreak = false;
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					logInfo("file info : " + fName);
					List<String> fContent = fUtil.getFileContent(path, fName, charset);
					int lineCnt = 0;
					int totCnt = 0;
					int eCnt = 0;
					this.prList.clear();
				
					for(String line : fContent) {
						
						String status = line.substring(0, 1);
						PrdtVo item = (PrdtVo) convertStringToVo(line, new PrdtVo());
						
						if ("C".equals(item.getSTATUS()) || "D".equals(item.getSTATUS()) ||"P".equals(item.getSTATUS()) ||"U".equals(item.getSTATUS())) {
						lineCnt++;
							
						item.setBUYER("KRDAED0079");
						item.setREVISION("1");
						item.setFILE_NAME(fName);
						
						String [] arr = item.getKEP_PR().split("-");
						item.setPR_NO(arr[0]);
						item.setPR_SEQ(arr[1].trim());
						
						this.prList.add(item);
						
						}
					}
					
					if (lineCnt > 0) {
						String ifChkFlag = "N";
						String prevKey = "";
						PrdtVo pItem = null;
						
						for(PrdtVo item : this.prList) {
							String nextKey = item.getBUYER() + item.getLEGACY_PR_NO() + item.getREVISION();
							if(  !prevKey.equals(nextKey)) {
								if(!"".equals(prevKey)) {
									Map<String, String> lMap = new HashMap<String, String>();
									lMap.put("BUYER", pItem.getBUYER());
									lMap.put("GUBUN", "PR");
									lMap.put("LEGACY_NO", pItem.getLEGACY_PR_NO());
									lMap.put("LEGACY_PR_NO", pItem.getLEGACY_PR_NO());
									
									lMap.put("REVISION", pItem.getREVISION());
									lMap.put("FILE_NAME", pItem.getFILE_NAME());
									lMap.put("IF_CHK_FLAG", ifChkFlag);
									dao.logWrite(lMap);
									
									}
									pItem = item;
									prevKey = nextKey;
							}
							 dao.DaedPrdtLegacyUpdate(item);
							 
							boolean bRtn = dao.mergeDaedIfPrdt(item);
							if (bRtn == false ) {
								ifChkFlag = "E";
								eCnt++;
								logError("ICOMTRXL_InsertFile Insert Error [ "+item.getLEGACY_PR_NO()+" / "+item.getLEGACY_PR_SEQ()+ " ]");
							}	
						}
						Map<String, String> lMap = new HashMap<String, String>();
						lMap.put("BUYER", pItem.getBUYER());
						lMap.put("GUBUN", "PR");
						lMap.put("LEGACY_NO", pItem.getLEGACY_PR_NO());
						lMap.put("LEGACY_PR_NO", pItem.getLEGACY_PR_NO());
						lMap.put("REVISION", pItem.getREVISION());
						lMap.put("FILE_NAME", pItem.getFILE_NAME());
						lMap.put("IF_CHK_FLAG", ifChkFlag);
						dao.logWrite(lMap);
						
						logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
						
					} else {
						// 비정상 처리.
						logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
						isBreak = true;
					}
					// move back
					fUtil.moveBack_DAED(path, fName);
					// 정지여부.
					if (isBreak) break;
				}
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
		}
		
	}

}
