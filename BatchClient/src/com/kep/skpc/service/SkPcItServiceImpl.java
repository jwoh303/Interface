/**
 * 
 */
package com.kep.skpc.service;

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
import com.kep.skpc.dao.SkPcDao;
import com.kep.skpc.dao.SkPcDaoImpl;

/**
 * @author jiwon
 *
 */
public class SkPcItServiceImpl implements SkPcItService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	SkPcDao skPcDao = new SkPcDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * SK피유코어 품목 추가/수정 정보 전송 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> paramMap = null;
			List<Map<String,Object>> paramLst = null;
            String url = CommonProperty.getSkPcUrl() + "recvItem.do";
            
            List<Map<String,Object>> itTmp = skPcDao.selectSkPcItList();
            
            if(!itTmp.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getSkPcToken();
            	for(Map<String,Object> it : itTmp) {
            		paramLst = new ArrayList<Map<String,Object>>();
            		paramLst.add(it);
            		paramMap = new HashMap<String,Object>();	                
            		paramMap.put("IT_ITEM", paramLst);
            		
	                log.info("##### SKPC IT 전송 전 데이터  : "+ paramMap.toString());
	       			result = HttpClientUtil.apiCallHttps("POST", "SKPC", url, paramMap, token);
	    			
	       			if(result.get("status").equals("S")) {
	       				log.info("##### SK피유코어 품목정보 전송 성공 : ");
	       				it.put("flag", "Y");	  
	       			}else {
	       				log.info("##### SK피유코어 품목정보 전송 실패  : "+ result.get("message"));
	       				it.put("flag", "E");	       				
	       			}
	       			it.put("msg", result.get("message"));
	       			skPcDao.updateSkPcItSend(it);
            	}
            	log.info("##### SK피유코어 품목정보 완료  : ");	
            }
            
		} catch (Exception e) {
			log.error("SKPCItService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				skPcDao.updateSkPcItErr();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}	
}
