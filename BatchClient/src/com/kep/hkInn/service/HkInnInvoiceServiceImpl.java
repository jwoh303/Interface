/**
 * 
 */
package com.kep.hkInn.service;

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
import com.kep.common.dao.ErrorLogMng_Dao;
import com.kep.common.dao.ErrorLogMng_DaoImpl;
import com.kep.hkInn.dao.HkInnDao;
import com.kep.hkInn.dao.HkInnDaoImpl;

/**
 * @author jiwon
 *
 */
public class HkInnInvoiceServiceImpl implements HkInnInvoiceService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HkInnDao hkInnDao = new HkInnDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	ErrorLogMng_Dao errorLogMng_Dao = new ErrorLogMng_DaoImpl();
	

	@Override
	public void execute() {
		
		
		/**
		 * HK이노엔 납품 전송 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();			
            Map<String, Object> paramMap = null;
            //CommonProperty에서 서버에 맞게 HKINN_NO 변경 
            //스마트잭 서버는 HTTP 호출이라 외부망에서 새로 토큰 호출해서 넘겨서 저장했음, 나머지는 HTTPS 토큰 유효날짜 수정해서 새로 발급받기
            String url = CommonProperty.getHkInnUrl() + "order/invoice";
            
            List<Map<String,Object>> ivList = hkInnDao.selectHkInnIvList(); // 납품 리스트 조회
            
            
            if(ivList.size() > 0) {
            	String token = "";        		
        		token = AuthTokenUtil.getInnToken();
        		for(int i = 0 ; i < ivList.size(); i++ ) {        			
            		//호출
        			paramMap = new HashMap<String,Object>();
            		paramMap = ivList.get(i);
                    log.info("##### HKINN INVOICE 전송 전 데이터  : "+ paramMap.toString());
                    
           			result = HttpClientUtil.apiCallHttp("POST", "HKIN", url, paramMap, token);        			
        			
           			if((boolean) result.get("result")) {
           				log.info("##### HK이노엔 납품 전송 성공 : ");
           				paramMap.put("result_flag", "Y");
           			}else {
           				log.info("##### HK이노엔 납품 전송 실패  : "+ result.get("message"));			
           				paramMap.put("result_flag", "E");
           			}
           			hkInnDao.updateHkInnIvData(paramMap);
                }
                
                log.info("##### HK이노엔 납품 완료  : ");	
            }
            
		} catch (Exception e) {
			log.error("HkInnInvoiceService Error : " + CommonUtil.printStackTraceToString(e));			
		}
	}
}
