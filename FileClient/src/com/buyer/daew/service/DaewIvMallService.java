package com.buyer.daew.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewIvMailDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class DaewIvMallService extends FileService implements Runnable {

	DaewIvMailDao dao = new DaewIvMailDao();
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
					int page_cnt = 0;
					String inv_no = "";
					this.rMaps.clear();
					String str = "";
					
					for(String line : fContent) {
						Map<String, String> iMap = convertStringToMap(line);
						
						if (lineCnt == 0) {
							str += "<br><BODY><TABLE border='1'><TR>";
							str += "<TH>납품 번호</TH>";
							str += "<TH>순번</TH>";
							str += "<TH>주문번호</TH>";
							str += "<TH>주문순번</TH>";
							str += "<TH>납품일</TH>";
							str += "<TH>납품수량</TH>";
							str += "<TH>오류메세지</TH></TR>";
							
							inv_no = iMap.get("INV_NO");
							
						} 
						
						str += "<TR>";
						str += "<TD>";
						str += iMap.get("INV_NO");
						str += "</TD>";
						str += "<TD align='right'>";
						str += iMap.get("INV_SEQ");
						str += "</TD>";
						str += "<TD>";
						str += iMap.get("LEGACY_PO_NO");
						str += "</TD>";
						str += "<TD align='center'>";
						str += iMap.get("LEGACY_PO_SEQ");
						str += "</TD>";
						str += "<TD>";
						str += iMap.get("INV_DATE");
						str += "</TD>";
						str += "<TD align='right'>";
						str += iMap.get("INV_QTY");
						str += "</TD>";
						str += "<TD>";
						str += iMap.get("ERR_MSG");
						str += "</TD>";
						
						lineCnt++;
						
						if (lineCnt >= 10) {
							str += "</TR></TABLE></BODY>";
							page_cnt ++;
							Map<String,String> pMap = new HashMap<String,String>();
							
							pMap.put("MAIL_CONTENT",str);
							pMap.put("FILE_NAME", fName);
							pMap.put("PAGE_CNT", Integer.toString(page_cnt));
							
							dao.Mail_Send(pMap);
						}
						
						this.rMaps.add(iMap);
						
					}
					
					Map<String,String> tMap = new HashMap<String,String>();
					
					tMap.put("BUYER", "KRDAEW0016");
					tMap.put("LEGACY_NO", inv_no);
					tMap.put("REVISION", "1");
					tMap.put("STATUS", "C");
					tMap.put("REMARK", fName);
					tMap.put("ERR_MSG", "I/F 파일 오류입니다 (전산실 문의)!!!");
					tMap.put("IF_FLAG", "A");
					
					
					dao.logwrite(tMap);
					logInfo("file Success : " + fName);
					// move back
					fUtil.moveBack(path, fName);
					// 정지여부.
					if (isBreak) break;
					
				}
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}
