/**
 * 
 */
package com.kep.hanssem.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.common.AuthTokenUtil;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.hanssem.dao.HanssemDao;
import com.kep.hanssem.dao.HanssemDaoImpl;

/**
 * @author jiwon
 *
 */
public class HanssemCloseServiceImpl implements HanssemCloseService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanssemDao hanssemDao = new HanssemDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 한샘 월정산내역 정보 수신 
		 */
		Map<String, Object> result = new HashMap<String,Object>();
		try {
			Map<String, Object> paramMap = null;
			List<Map<String,Object>> paramLst = null;
            String url = CommonProperty.getHanssemUrl() + "MRO_CLOSE_KEP_SC";            

            List<Map<String,Object>> reqList = hanssemDao.selectHanssemArSend();
            
            if(!reqList.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getHanssemToken();
        		paramMap = new HashMap<String,Object>();
        		List<Map<String,Object>> arDateList = hanssemDao.selectHanssemArDate(); 
        		String yyyyMm = arDateList.get(0).get("I_YYYYMM").toString();
        		paramMap.put("I_BUKRS", "HS01");
        		paramMap.put("I_YYYYMM", yyyyMm);     
        		paramMap.put("IT_TAB", reqList);
        		
                log.info("##### 한샘 월정산내역 전송 전 데이터  : "+ paramMap.toString());
       			result = HttpClientUtil.apiCallHttps("POST", "HANSSEM", url, paramMap, token);
    			
       			if(result.get("IFRESULT").equals("S")) {
       				log.info("##### 한샘 월정산내역 전송 성공 : ");       				
       			}else {
       				log.info("##### 한샘 월정산내역 전송 실패  : "+ result.get("IFMSG"));
       			}
       			hanssemDao.updateHanssemArSend(result);
            	log.info("##### 한샘 월정산내역 완료  : ");            	
            }
            
		} catch (Exception e) {
			result.put("IFRESULT", "E");
			result.put("IFMSG", e.getMessage());
			try {
				hanssemDao.updateHanssemArSend(result);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			log.error("HanssemCloseService Error : " + CommonUtil.printStackTraceToString(e));
		}	
	}	
}
