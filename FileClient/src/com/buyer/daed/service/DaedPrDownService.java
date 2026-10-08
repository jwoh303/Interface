package com.buyer.daed.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.daed.dao.DaedPrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;


public class DaedPrDownService extends FileService implements Runnable{
	DaedPrDao dao = new DaedPrDao();
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {	
			int ret = 1;
			List<String> fData = new ArrayList<String>();
			SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			Date time = new Date();
			String ntime = dFormat.format(time);
			
			String filename = hdInfo.get("PREFIX")  + ntime +  ".txt";
			
			List <String> filelist = fUtil.getFileList(hdInfo.get("FOLDER"), hdInfo.get("PREFIX"));
			for(String list : filelist) {
				if(list.equals(filename)) {
					ret = -1;
					break;
				}
			}
			
			if(ret == 1) {
				List<Map<String, String>> lists = dao.selectDBDispatcher();
				if(lists.size() > 0) {
					for(Map<String,String> iMap : lists) {
						
						if("APPROVAL".equals(iMap.get("DOC_NAME"))){
							
							List<Map<String,String>> pMap = dao.PRDT_SELECT(iMap);
							dao.TRXL_Dequeue(iMap);

							for(Map<String,String> tMap : pMap) {
								Map<String,String> ifMap = new HashMap<String,String>();
								ifMap.put("BUYER" , tMap.get("BUYER"));
								ifMap.put("LEGACY_NO" , tMap.get("REF_NO"));
								ifMap.put("GUBUN" , "PX");
								ifMap.put("REVISION" , "00");
								ifMap.put("IF_FLAG" , "T");
								ifMap.put("STATUS" , "C");
								ifMap.put("ERR_MSG" , "청구자료 전송(SAP)!!!");
								ifMap.put("REMARK" , "BUDGET");
								
								dao.LogWrite(ifMap);

								String lData = convertMaptoString(tMap);
								fData.add(lData);
							}
						}
					}
					
					fUtil.setFileContent(this.tmpDir, filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));
					
					boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
					if (!isSuccess)  {
						// 에러 처리.
						logError("File Create Error ["+filename+"]" );
					}
				}			
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}
