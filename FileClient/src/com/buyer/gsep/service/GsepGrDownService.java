package com.buyer.gsep.service;

//import java.text.SimpleDateFormat;
import java.util.ArrayList;
//import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.gsep.dao.GsepGrDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class GsepGrDownService extends FileService implements Runnable {
	
	GsepGrDownDao dao = new GsepGrDownDao();

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
					int CheckCnt = 0;
					g_hd_srcnt = 0;
					fData.clear();
					if (CheckCnt == 0) {
						List<Map<String,String>> pMap = dao.GRDT_Select(iMap);
						
//						SimpleDateFormat dFormat = new SimpleDateFormat("yyMMdd");
//						Date time = new Date();
						
//						SimpleDateFormat dFormat2 = new SimpleDateFormat("yyyyMMddHHmmss");
						
						for (Map <String,String> tMap : pMap ) {
							if (g_hd_srcnt == 0) {
								dao.GRDT_Update(tMap);
																
								filename = "DELIVERY_" + tMap.get("GR_NO") +tMap.get("CUR_DATATIME") + ".txt";
							}									
							String str = dao.GRDT_Assign(tMap);
							fData.add(str);
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
