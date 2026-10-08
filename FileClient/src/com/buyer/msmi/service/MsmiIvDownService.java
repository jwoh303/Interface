package com.buyer.msmi.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.buyer.msmi.dao.MsmiIvDownDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;

public class MsmiIvDownService extends FileService implements Runnable {

	MsmiIvDownDao dao = new MsmiIvDownDao();
	
	@Override
	public void run() {
		
		try {	
			int cnt = dao.Msmi_DBDispatcher();
			
			if (cnt > 0) {
				
				List<Map<String, String>> trxl = dao.Msmi_TRXL_Select();
				List<String> fData = new ArrayList<String>();
				
				for( Map<String, String> tMap : trxl) {
					Map<String, String> ifList = dao.Msmi_IVDT_Select(tMap);
					ifList.put("DATA_CLASSIFICATION","O");
					ifList.put("SUBSIDIARY_CODE","KOR");
					ifList.put("DATA_LINK_DIVISION","1");
					ifList.put("GLOBAL_NUMBER_FOR_BARCODE",ifList.get("GLOBAL_NUMBER"));
					
					
					dao.Msmi_TRXL_Dequeue(tMap);
					String lData = convertMaptoString_MSMI(ifList);
					fData.add(lData);
					
					SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
					Date time = new Date();
					String ntime = dFormat.format(time);
					
					String filename8 = "8" + ifList.get("REF_PR_NO")+"_SR_"+ ntime + ".dat";
					String filename = ifList.get("REF_PR_NO")+"_SR_"+ ntime + ".dat";
					
					String charset [] = hdInfo.get("CHARSET").split(",");
					
					fUtil.setFileContent(this.tmpDir, filename8, fData, charset[0], System.getProperty("line.separator"));
					fUtil.setFileContent(this.tmpDir, filename, fData, charset[1], System.getProperty("line.separator"));
					
					boolean isSuccess8 = fUtil.moveutil(this.tmpDir + "/" + filename8 , hdInfo.get("FOLDER") + "/" + filename8);
					boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/BACK/" + filename);
					if (!isSuccess || !isSuccess8)  {
						// 에러 처리.
						logError("File Create Error ["+filename+"]" );
						logError("File Create Error ["+filename8+"]" );
					}
					logInfo("file Success : " + filename);
					break;
				}
				
				
			}
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}
