package com.kep.josu.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.josu.dao.JosuBudgetDao;
import com.kep.josu.dao.JosuBudgetDaoImpl;
import com.kep.josu.dao.JosuKepmpDao;
import com.kep.josu.dao.JosuKepmpDaoImpl;



public class FiCloseSendServiceImpl implements FiCloseSendService {
	private Logger log	= Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute(String GR_DATE, String ENTRY_DT) {
		//마감 내역 전송 kep - > 조선호텔
		JosuKepmpDao kepDao = new JosuKepmpDaoImpl();
		JosuBudgetDao josuDao = new JosuBudgetDaoImpl();
		
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
 		Map<String, String> bMap = new HashMap<String, String>();
 		bMap.put("PGM_ID", this.getClass().getName());
 		
 		try {
 			//마감 내역 select 
 			Map<String, String> map = new HashMap<String, String>();
 			
 			map.put("GR_DATE", GR_DATE);
 			map.put("ENTRY_DT", ENTRY_DT);
 			
 			List<Map<String, Object>> fiCloseList = kepDao.selectFiClose(map);
 			
 			if (fiCloseList != null && fiCloseList.size() > 0) {
 				for (int i = 0; i < fiCloseList.size(); i++) {
 					try {
 						int DEAL_AMT = Integer.parseInt(fiCloseList.get(i).get("DEAL_AMT").toString());
 	 					int TAX_AMT = Integer.parseInt(fiCloseList.get(i).get("TAX_AMT").toString());
 	 					
 	 					fiCloseList.get(i).put("DEAL_AMT", DEAL_AMT);
 	 					fiCloseList.get(i).put("TAX_AMT", TAX_AMT);
 	 					
 	 					if(fiCloseList.get(i).get("REMARK2") != null) {
 	 						fiCloseList.get(i).put("REMARK", fiCloseList.get(i).get("REMARK1").toString() + "외" + fiCloseList.get(i).get("REMARK2")+ "건");
 	 					}else {
 	 						fiCloseList.get(i).put("REMARK", fiCloseList.get(i).get("REMARK1").toString() + "건");
 	 					}
 	 					
 	 					int seqCnt = josuDao.selectSeqCnt();
 	 					fiCloseList.get(i).put("SEQ", seqCnt);
 	 					log.info("seqCnt:::::::"+seqCnt);
 	 					josuDao.insertFiClose(fiCloseList.get(i));
 					}catch (Exception e) {
 						e.printStackTrace();
 						log.error("josun !!!! insert errr!!!! : act_unit - "+ fiCloseList.get(i).get("ACT_UNIT") + e.getMessage());
					}
 					
 				}
 			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("josun or kep !!!! db conn errr!!!! : " + e.getMessage());
		}
		
	}

}