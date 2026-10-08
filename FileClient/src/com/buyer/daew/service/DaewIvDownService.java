package com.buyer.daew.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.daew.dao.DaewIvDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class DaewIvDownService extends FileService implements Runnable {
	
	DaewIvDownDao dao = new DaewIvDownDao();
	
	@Override
	public void run() {
		try {
			int cnt = dao.DBDispatcher();
			int g_hd_srcnt = 0;
			String filename = "";
			if (cnt > 0) {
				List<Map<String, String>> ifList = dao.DBDispatcherList();
				List<String> fData = new ArrayList<String>();
				
				for( Map<String, String> iMap : ifList) {
					int CheckCnt = dao.SEND_Check(iMap);
					g_hd_srcnt = 0;
					fData.clear();
					if (CheckCnt == 0) {
						List<Map<String,String>> pMap = dao.IVDT_Select(iMap);
						
//						SimpleDateFormat dFormat = new SimpleDateFormat("yyMMdd");
//						Date time = new Date();
						String ntime = "";
						String seq = "";
						
						SimpleDateFormat dFormat2 = new SimpleDateFormat("yyyyMMddHHmmss");
						Date time2 = new Date();
						String ntime2 = dFormat2.format(time2);
						
						for (Map <String,String> tMap : pMap ) {
							
							if (g_hd_srcnt == 0) {
								dao.IVHD_Update(tMap);
								
							    seq = tMap.get("LEGACY_IV_SERIAL").substring(0,3);
								ntime = tMap.get("LEGACY_IV_SERIAL").substring(5);
							    
								tMap.put("DATE",ntime);
								tMap.put("SEQ",seq);
								
								filename = "DL" + ntime + "DL" + seq + "_" + tMap.get("STATUS"); 
								
								String str = dao.IVDT_Assign(tMap);
								fData.add(str);
							} else {
								
								tMap.put("DATE",ntime);
								tMap.put("SEQ",seq);
								
								String str = dao.IVDT_Assign(tMap);
								fData.add(str);
								
							}
							g_hd_srcnt++;
						}
						if(g_hd_srcnt > 0) {
							
							fUtil.setFileContent(this.tmpDir, filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));
							
							boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
							if (!isSuccess)  {
								// 에러 처리.
								logError("File Create Error ["+filename+"]" );
							}
							logInfo("file Success : " + filename);
						}
						dao.TRXL_Dequeue(iMap);
						
					} else {
						dao.TrxlUpdate(iMap);
					}
//					break;
				}
				
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
		
	}
}
