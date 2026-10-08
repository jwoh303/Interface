package com.kep.aeky.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.aeky.dao.AekyDao;
import com.kep.aeky.dao.AekyDaoImpl;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;


/**
 * @author jiwon
 *
 */
public class AekySendBdgtServiceImpl implements AekySendBdgtService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	AekyDao aekyDao = new AekyDaoImpl();
	
	@SuppressWarnings("unchecked")
	@Override
	public void execute() {
		
		/**
		 * 애경케미칼 예산 마감 전송 
		 */
		
		try {			
			List<Map<String, String>> paramTmp	= new ArrayList<Map<String,String>>();
			String paramKey	= "";
			String paramDate = "";
			String ifDate = "";
			String ifTime = "";
			List<Map<String, Object>> hMaps	= new ArrayList<Map<String,Object>>();
			List<Map<String, Object>> dMaps	= new ArrayList<Map<String,Object>>();						
			Map<String,Object> paramMap = new HashMap<String,Object>();
			Map<String, Object> resultMap = new HashMap<String,Object>();
			Map<String,String> keyMap = new HashMap<String,String>();
            // REST 호출 URL
//            String apiUrl = "https://devexeai.akc.co.kr/eai/rest2rfc/IF_MRO_SAPFI_001"; // 개발(품질) URL 443 포트사용
            String apiUrl = "https://eai.akc.co.kr/eai/rest2rfc/IF_MRO_SAPFI_001"; // 운영 443 포트사용
            // 예산 마감 헤더 조회
            hMaps = aekyDao.selectAekyArSendHd();            
            // 예산 마감 아이템 조회
            for(Map<String,Object> iMap : hMaps) {            	
            	dMaps.addAll(aekyDao.selectAekyArSend(iMap)); 
            }
            // 파라미터 키 조회
            paramTmp = aekyDao.selectParamKey();			
			paramKey = paramTmp.get(0).get("PARAM_KEY");
			keyMap.put("IV_EAI_KEY", paramKey);
			paramDate = paramKey.substring(paramKey.length()-14);
			ifDate = paramDate.substring(0,8);
			ifTime = paramDate.substring(8);
			
            if(!paramTmp.isEmpty() && !hMaps.isEmpty() && !dMaps.isEmpty()) {
            	paramMap.put("Parameter", keyMap);
    			paramMap.put("IT_HEADER", hMaps);
    			paramMap.put("IT_ITEM", dMaps);
            	log.info("################# AEKY BD 전송 전 데이터  #################"+ paramMap.toString());
            	
        		// 예산 마감 데이터 전송
    			resultMap = HttpClientUtil.apiCallHttps("POST", "AEKY", apiUrl, paramMap, null);
    			
    			log.info("################# AEKY BD result #################"+ resultMap.toString());
    			
    			// 결과 업데이트
    			if(((Map<String, Object>)resultMap.get("Parameter")).get("TYPE").equals("S")) {    				
    				resultMap.put("TYPE","Y");		    	
			    }else {
			    	resultMap.put("TYPE","E");
			    }
    			for(Map<String,Object> iMap : hMaps) {
    				iMap.put("TYPE", resultMap.get("TYPE"));
    				iMap.put("IF_DATE", ifDate);
    				iMap.put("IF_TIME", ifTime);
    				aekyDao.updateAekyArSend(iMap);    		
    			}
    			log.info("################# AEKY UPDATE BD DONE #################");
            }			
            
		} catch (Exception e) {
			log.error("AekyService Error : " + CommonUtil.printStackTraceToString(e));
		}				
	}	
}
