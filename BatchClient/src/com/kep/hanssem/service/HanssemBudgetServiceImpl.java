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
public class HanssemBudgetServiceImpl implements HanssemBudgetService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanssemDao hanssemDao = new HanssemDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 한샘 예산내역 정보 수신 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> paramMap = null;
            String url = CommonProperty.getHanssemUrl() + "MRO_BUDGET_KEP_SC";
            
            // BUYER AS I_BUKRS --회사코드   '202501' AS I_YYYYMM --연월    COST_CENTER AS I_KOSTL --코스트센터
            List<Map<String,Object>> reqList = hanssemDao.selectHanssemBdgtParam();
            
            if(!reqList.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getHanssemToken();
        		
                log.info("##### 한샘 예산내역 전송 전 데이터  : "+ reqList.get(0).toString());
       			result = HttpClientUtil.apiCallHttps("POST", "HANSSEM", url, reqList.get(0), token);
    			
       			if(result.get("IFRESULT").equals("S")) {
       				log.info("##### 한샘 예산내역 전송 성공 : ");
       				hanssemDao.insertHanssemBdgt(result);
       				hanssemDao.insertHanssemDtoA();
       				hanssemDao.insertHanssemDtoD();
       			}else {
       				log.info("##### 한샘 예산내역 전송 실패  : "+ result.get("IFMSG"));
       			}
            	log.info("##### 한샘 예산내역 완료  : ");	
            }
            
		} catch (Exception e) {
			log.error("HanssemBudgetService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	
}
