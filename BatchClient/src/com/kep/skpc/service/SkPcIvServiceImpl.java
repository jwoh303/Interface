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
public class SkPcIvServiceImpl implements SkPcIvService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	SkPcDao skPcDao = new SkPcDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * SK피유코어 납품정보 전송 
		 */
		Map<String, Object> errParam = null;
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> paramMap = null;	
			List<Map<String,Object>> paramLst = null;			
            String url = CommonProperty.getSkPcUrl() + "recvPo.do";
            
            List<Map<String,Object>> ivTmp = skPcDao.selectSkPcIvList();
            
            if(!ivTmp.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getSkPcToken();
            	for(Map<String,Object> iv : ivTmp) {
            		errParam = new HashMap<String,Object>();
            		errParam = iv;
            		Map<String, Object> ivParam = new HashMap<String,Object>(iv);
            		ivParam.remove("PO_NO");
            		paramLst = new ArrayList<Map<String,Object>>();
            		paramLst.add(ivParam);
            		paramMap = new HashMap<String,Object>();	                
            		paramMap.put("IV_ITEM", paramLst);
	                log.info("##### SKPC IV 전송 전 데이터  : "+ paramMap.toString());
	                
	       			result = HttpClientUtil.apiCallHttps("POST", "SKPC", url, paramMap, token);
	    			
	       			if(result.get("status").equals("S")) {
	       				log.info("##### SK피유코어 납품정보 전송 성공 : ");
	       				iv.put("flag", "Y");	  
	       			}else {
	       				log.info("##### SK피유코어 납품정보 전송 실패  : "+ result.get("message"));
	       				iv.put("flag", "E");	       				
	       			}
	       			iv.put("msg", result.get("message"));
	       			skPcDao.updateSkPcIvTrxl(iv);	       			
            	}
            	log.info("##### SK피유코어 납품정보 완료  : ");	
            }
            
		} catch (Exception e) {
			log.error("SKPCIvService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				errParam.put("flag", "E");	       		
				errParam.put("msg", e.getMessage());
				skPcDao.updateSkPcIvTrxl(errParam);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}	
}
