/**
 * 
 */
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
public class AekyGetBdgtServiceImpl implements AekyGetBdgtService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	AekyDao aekyDao = new AekyDaoImpl();
	
	@SuppressWarnings("unchecked")
	@Override
	public void execute() {
		
		/**
		 * 애경케미칼 예산 정보 수신 
		 */
		
		try {			
			List<Map<String, String>> paramTmp	= new ArrayList<Map<String,String>>();
			String paramKey	= "";
			Map<String,Object> paramMap = new HashMap<String,Object>();
			Map<String, Object> resultMap = new HashMap<String,Object>();
			Map<String,String> keyMap = new HashMap<String,String>();
			List<Map<String, Object>> resultLst	= new ArrayList<Map<String,Object>>();
            // REST 호출 URL
//            String apiUrl = "https://devexeai.akc.co.kr/eai/rest2rfc/IF_MRO_SAPCO_001"; // 개발 URL 443 포트사용
            String apiUrl = "https://eai.akc.co.kr/eai/rest2rfc/IF_MRO_SAPCO_001"; // 운영 URL 443 포트사용
            
            // 파라미터 키 조회
            paramTmp = aekyDao.selectParamMroKey();			
			paramKey = paramTmp.get(0).get("PARAM_KEY");
			keyMap.put("IV_EAI_KEY", paramKey);
			if(!paramTmp.isEmpty()) {
				paramMap.put("Parameter", keyMap);
				// 예산 마감 데이터 조회 호출
				resultMap = HttpClientUtil.apiCallHttps("POST", "AEKY", apiUrl, paramMap, null);
				
				log.info("################# AEKY 예산정보 수신 결과 #################"+ resultMap.toString());
				
				// 결과 업데이트
				if(((Map<String, Object>)resultMap.get("Parameter")).get("TYPE").equals("S")) {    				
					resultLst = (List<Map<String, Object>>) resultMap.get("ET_RESULT");
					
					for(Map<String,Object> iMap : resultLst) {
						aekyDao.insertAekyBdgt(iMap);    		
					}
			    }
				log.info("################# AEKY 예산정보 수신  DONE #################");
			}
			
		} catch (Exception e) {
			log.error("AekyService Error : " + CommonUtil.printStackTraceToString(e));
		}			
	}
}
