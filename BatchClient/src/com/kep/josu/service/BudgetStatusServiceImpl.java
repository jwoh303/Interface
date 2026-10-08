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

public class BudgetStatusServiceImpl implements BudgetStatusService {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() {
		JosuBudgetDao josuDao = new JosuBudgetDaoImpl();
		JosuKepmpDao kepDao = new JosuKepmpDaoImpl();
		
		//기본세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
 		Map<String, String> bMap = new HashMap<String, String>();
 		bMap.put("PGM_ID", this.getClass().getName());

 		
 		try {
 			List<Map<String,String>> bdgtList = kepDao.selectbdgtList();  
 			log.info(bdgtList.size());
 			if (bdgtList != null && bdgtList.size() > 0) {
 				for(int i = 0 ; i < bdgtList.size(); i++ ) {
 					int result = 0;
 					
 					Map<String, Object> paramMap = new HashMap<String, Object>();
 		 			paramMap.put("IUNIT", bdgtList.get(i).get("ACT_UNIT"));     	//회계단위
 		 			paramMap.put("IMK_DT", bdgtList.get(i).get("TERM")); 			//예산년월
 		 			paramMap.put("IDEPT",  bdgtList.get(i).get("DEPT"));        	//예산부서
 		 			paramMap.put("IBGT_BG", "08");    			       				//예산구분
 		 			paramMap.put("IACC_CD", bdgtList.get(i).get("ACCOUNT_TYPE"));   //계정코드
 		 			
 		 			josuDao.selectBudget(paramMap);
 		 			
 		 			result = kepDao.insertBdgt(paramMap);
 		 			
 		 			if(result != 1) {
 		 				log.error("josun !!!! kepDao.insertBdgt errr!!!! : " + paramMap);
 		 			}
 				}
 				
 				 kepDao.callProcBdgt();
 			}
 			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("josun !!!! db conn errr!!!! : " + e.getMessage());
		}
	}

}
