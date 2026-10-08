package com.kep.hancom.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.hancom.dao.HanComDao;
import com.kep.hancom.dao.HanComDaoImpl;
import com.kep.hancom.dao.HanComKepIfDao;
import com.kep.hancom.dao.HanComKepIfDaoImpl;



public class HanComServiceImpl implements HanComService{
	
	private Logger log	= Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() {		
		HanComDao dao = new HanComDaoImpl();
		HanComKepIfDao kepdao = new HanComKepIfDaoImpl();
		//기본세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
 		Map<String, String> bMap = new HashMap<String, String>();
 		bMap.put("PGM_ID", this.getClass().getName());
 		
 		try {
 			List<Map<String,String>> codeList = dao.selectIfCode();  
 			log.info("codeList.size() = " + codeList.size());
 			if (codeList != null && codeList.size() > 0) {
 				for(int i = 0 ; i < codeList.size(); i++ ) {
 					int result = 0; 					
 					Map<String, Object> paramMap = new HashMap<String, Object>();
 					
 					paramMap.put("TYPE", codeList.get(i).get("TYPE"));
 					paramMap.put("CODE", codeList.get(i).get("CODE"));
 					paramMap.put("NAME", codeList.get(i).get("NAME"));
 					paramMap.put("CD_REF1", codeList.get(i).get("CD_REF1"));
 					paramMap.put("CD_REF2", codeList.get(i).get("CD_REF2"));
 					
 					result = kepdao.insertIfCode(paramMap);
 		 			
 		 			if(result != 1) {
 		 				log.error("hancom !!!! HanComKepIfDao.insertIfCode errr!!!! : " + paramMap);
 		 			}
 				}
 				kepdao.execProcIf();
 			}
 			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("hancom !!!! db conn errr!!!! : " + e.getMessage());
		}
	}

}
