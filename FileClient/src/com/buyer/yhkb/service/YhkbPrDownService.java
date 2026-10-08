package com.buyer.yhkb.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.yhkb.dao.YhkbPrDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class YhkbPrDownService extends FileService implements Runnable {

	YhkbPrDownDao dao = new YhkbPrDownDao();
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {	
			int cnt = dao.DBDispatcher();
			
			if (cnt > 0) {
				List<Map<String, String>> ifList = dao.PRDT_Select();
				int read_cnt = 0;
				List<String> fData = new ArrayList<String>();
				
				String PRHD = dao.PRHD_Assign();
				
				fData.add(PRHD);
				
				for( Map<String, String> iMap : ifList) {
					String PRDT = dao.PRDT_Assign(iMap);
					dao.TRXL_Dequeue(iMap);
					dao.YhkbConfirmUser_update(iMap);
					fData.add(PRDT);
				}
				
				SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				Date time = new Date();
				String ntime = dFormat.format(time);
				
				String filename = hdInfo.get("PREFIX") + ntime + ".idoc.txt";
				
				fUtil.setFileContent(this.tmpDir, filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));
				
				boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
				if (!isSuccess)  {
					// 에러 처리.
					logError("File Create Error ["+filename+"]" );
				}
				logInfo("file Success : " + filename );
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}	
}
