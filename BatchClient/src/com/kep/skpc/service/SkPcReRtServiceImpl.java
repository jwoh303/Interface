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
public class SkPcReRtServiceImpl implements SkPcReRtService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	SkPcDao skPcDao = new SkPcDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
				
		/**
		 * SK피유코어 견적회신 전송 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> paramMap = null;	
            String url = CommonProperty.getSkPcUrl() + "recvRfx.do";
            
            List<Map<String,Object>> reQuo = skPcDao.selectSkPcReQuoList(); // 계약서 번호 중복제거 조회
            
            if(!reQuo.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getSkPcToken();
            	int batchSize = 5;
            	boolean isSuccess;
            	for(Map<String,Object> quo : reQuo) {
            		List<Map<String,Object>> reList = skPcDao.selectSkPcReRtList(quo);
            		for(int i=0; i<reList.size(); i+=batchSize) {
            			List<Map<String,Object>> batchList = reList.subList(i, Math.min(i+batchSize, reList.size()));
            		
	            		paramMap = new HashMap<String,Object>();
	            		paramMap.put("RE_ITEM", batchList);
		                log.info("##### SKPC RERT 전송 전 데이터  : "+ paramMap.toString());
		                
		       			result = HttpClientUtil.apiCallHttps("POST", "SKPC", url, paramMap, token);
		    			
		       			if(result.get("status").equals("S")) {
		       				log.info("##### SK피유코어 견적회신 전송 성공 : ");
		       				isSuccess = true;		       				
		       			}else {
		       				log.info("##### SK피유코어 견적회신 전송 실패  : "+ result.get("message"));
		       				isSuccess = false;		       					       				
		       			}
		       			String resultMsg = (String) result.get("message");
		       			for(Map<String,Object> item : batchList) {
		       				if(isSuccess) {
		       					item.put("flag", "Y");	  
		       				}else {
		       					item.put("flag", "E");	  
		       				}
		       				item.put("msg", resultMsg);
		       				skPcDao.updateSkPcReRt(item);
		       			}
            		}
            	}
            	log.info("##### SK피유코어 견적회신 완료  : ");	
            }
            
		} catch (Exception e) {
			log.error("SKPCReRtService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				skPcDao.updateSkPcReRtErr();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}
}
