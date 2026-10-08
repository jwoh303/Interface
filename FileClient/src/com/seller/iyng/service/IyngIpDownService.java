package com.seller.iyng.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.iyng.dao.IyngIpDao;

public class IyngIpDownService extends FileService implements Runnable {

	IyngIpDao dao = new IyngIpDao();
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {	
			dao.updateDBDispatcher();
			
			List<Map<String, String>> ifList = dao.selectIyngLogisCur();
			int read_cnt = 0;
			List<String> fData = new ArrayList<String>();
			
			for( Map<String, String> iMap : ifList) {
				read_cnt++;
				iMap.put("READ_CNT",Integer.toString(read_cnt));
				List<Map<String, String>> Ips = dao.DATA_Assign(iMap);
				System.out.println(Ips);
				dao.DATA_Update(iMap);
				for(Map<String, String> dMap : Ips) {
					String lData = convertMaptoString(dMap);
					fData.add(lData);
				}
			}
			System.out.println(fData);
			if(ifList.size() > 0) {
				SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				Date time = new Date();
				String ntime = dFormat.format(time);
				
				String filename = hdInfo.get("PREFIX") + ntime + "_" +ifList.size() + ".TXT";
				
				boolean rtn = fUtil.setFileContent(this.tmpDir, filename, fData, hdInfo.get("CHARSET"), System.getProperty("line.separator"));
				
				
				boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/" + filename);
//				boolean isSuccess = fUtil.move(hdInfo.get("FOLDER") + "/" + filename , hdInfo.get("FOLDER") + "/BACK/" + filename);
				
				
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
