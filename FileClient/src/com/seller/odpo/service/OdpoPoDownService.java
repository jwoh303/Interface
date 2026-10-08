package com.seller.odpo.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.odpo.dao.OdpoPoDao;

public class OdpoPoDownService extends FileService implements Runnable {
	
	OdpoPoDao dao = new OdpoPoDao();

	@Override
	public void run() {
		try {
			List<Map<String, String>> ifList = dao.selectOdpoPoEventList();
			System.out.println(ifList);
			for( Map<String, String> iMap : ifList) {
				try {
					List<Map<String, String>> poDts = dao.setectOdpoPoDetail(iMap);
					List<String> fData = new ArrayList<String>();
					for(Map<String, String> dMap : poDts) {
						String lData = convertMaptoString(dMap);
						fData.add(lData);
					}
					String tail = "T" + hdInfo.get("SPLIT_TYPE") + fData.size() + hdInfo.get("SPLIT_TYPE");
					fData.add(tail);
	
					SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
					Date time = new Date();
					String ntime = dFormat.format(time);
					
					String filename = hdInfo.get("PREFIX") + iMap.get("BUYER") + iMap.get("PO_NO") + ntime;
					fUtil.setFileContent(hdInfo.get("FOLDER"), filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));
					boolean isSuccess = fUtil.move(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
					
					System.out.println("isSuccess : " + isSuccess);
					dao.executeOdpoPoComplte(iMap);
					logInfo("file Success : " + filename );
				} catch (Exception e) {
					logError(CommonUtil.printStackTraceToString(e));
					e.printStackTrace();
				}
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}