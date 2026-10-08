package com.kep.josu.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.josu.dao.JosuBudgetDao;
import com.kep.josu.dao.JosuBudgetDaoImpl;
import com.kep.josu.dao.JosuKepmpDao;
import com.kep.josu.dao.JosuKepmpDaoImpl;

public class BudgetTestServiceImpl implements BudgetTestService {
	private Logger log	= Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception{
		//db con 모니터링
		JosuBudgetDao josuDao = new JosuBudgetDaoImpl();
		JosuKepmpDao kepDao = new JosuKepmpDaoImpl();
		
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
 		Map<String, String> bMap = new HashMap<String, String>();
 		bMap.put("PGM_ID", this.getClass().getName());

 		Map<String, Object> selectMap = new HashMap<String, Object>();
 		try {
 			selectMap.put("IUNIT", "000001");     	//회계단위
 			selectMap.put("IMK_DT", "202303"); 			//예산년월
 			selectMap.put("IDEPT",  "001001");        	//예산부서
 			selectMap.put("IBGT_BG", "08");    			//예산구분
	 		selectMap.put("IACC_CD","519210000");   //계정코드
	 			
	 		josuDao.selectBudget(selectMap);
	 			
	 		log.info("DB CONN OK!");
		} catch (Exception e) {
			selectMap.put("title", "조선호텔 DB접속오류");  
			selectMap.put("content", "확인일시:");  
			kepDao.insertJosuDbChk(selectMap);
			log.error("josunHotel DB CONN errr! CHK VPN : " + e.getMessage());
			e.printStackTrace();
		}
	}
}
