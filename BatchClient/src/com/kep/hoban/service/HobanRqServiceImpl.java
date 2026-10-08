/**
 * 
 */
package com.kep.hoban.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.hoban.dao.HobanRqDao;
import com.kep.hoban.dao.HobanRqDaoImpl;

/**
 * @author jiwon
 *
 */
public class HobanRqServiceImpl implements HobanRqService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HobanRqDao hobanRqDao = new HobanRqDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute(String SERVER_CHK) {
		
		/**
		 * 호반 견적 호출 
		 */
		
		try {			
			Map<String, Object> result = new HashMap<String,Object>();
			List<Map<String,Object>> resultLstMap = new ArrayList<Map<String,Object>>();
			String apiUrl = "";
			
			if("2".equals(SERVER_CHK)) {
				//운영
				apiUrl = "https://pms.resom.co.kr/api/pms/itf/mate/savequo";				
			}else {
				//개발
	            apiUrl = "https://dev-pms.resom.co.kr/api/pms/itf/mate/savequo";
			}
			
            
			// 견적 데이터 조회
			List<Map<String,Object>> rqLstMap = hobanRqDao.selectHobanRqData(); 
			
            if(!rqLstMap.isEmpty()) {
            	int tmpCnt = 0;
            	for(Map<String, Object> obj : rqLstMap) {            		
            		//For Test
//            		obj.put("plant", "0" + ++tmpCnt);
	            	log.info("################# HOBAN RQ 전송 전 데이터  #################"+ obj.toString());
	            	
	        		// 견적 데이터 전송
	    			result = HttpClientUtil.apiCallHttps("POST", "HOBAN", apiUrl, obj, null);
	    			
	    			log.info("################# HOBAN RQ result #################"+ result.toString());
	    			
	    			obj.put("resultCode", result.get("resultCode"));
	    			obj.put("message", result.get("message"));
	    			if(result.get("buyerItemNo") != null) {
	    				obj.put("buyerItemNo", result.get("buyerItemNo"));
	    			}
	    			
	    			// 견적 회신 후 처리
	    			hobanRqDao.insertRqResultData(obj);
	    			
            	}
            }
            
			log.info("################# HOBAN UPDATE RQ DONE #################");
		} catch (Exception e) {
			log.error("HobanRqService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
}
