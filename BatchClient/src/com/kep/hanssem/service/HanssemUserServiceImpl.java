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
public class HanssemUserServiceImpl implements HanssemUserService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanssemDao hanssemDao = new HanssemDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 한샘 회원 정보 수신 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> paramMap = null;
			List<Map<String,Object>> paramLst = null;
            String url = CommonProperty.getHanssemUrl() + "MRO_MEMBER_KEP_SC";
            
            // BUYER AS I_BUKRS --회사코드
//            List<Map<String,Object>> reqList = hanssemDao.selectHanssemItList();            
            
//            if(!reqList.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getHanssemToken();
        		paramMap = new HashMap<String,Object>();
        		paramMap.put("I_BUKRS", "HS01");
        		
                log.info("##### 한샘 회원정보 전송 전 데이터  : "+ paramMap.toString());
       			result = HttpClientUtil.apiCallHttps("POST", "HANSSEM", url, paramMap, token);
    			
       			if(result.get("IFRESULT").equals("S")) {
       				log.info("##### 한샘 회원정보 전송 성공 : " + result.toString());
       				hanssemDao.insertHanssemUser(result);
       				hanssemDao.execHanssemUserProc();
       			}else {
       				log.info("##### 한샘 회원정보 전송 실패  : "+ result.get("IFMSG"));
       			}
            	log.info("##### 한샘 회원정보 완료  : ");	
//            }
            
		} catch (Exception e) {
			log.error("HanssemUserService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	
}
