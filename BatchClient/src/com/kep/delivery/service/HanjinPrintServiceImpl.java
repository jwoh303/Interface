/**
 * 
 */
package com.kep.delivery.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.common.AuthTokenUtil;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.delivery.dao.HanjinDao;
import com.kep.delivery.dao.HanjinDaoImpl;

/**
 * @author jiwon
 *
 */
public class HanjinPrintServiceImpl implements HanjinPrintService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanjinDao hanjinDao = new HanjinDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환	
	
	@Override
	public void execute() {
		
		/**
		 * 한진 택배 운송장 출력
		 */
		try {			
			//출력 파라미터 받을 때마다 호출 후 저장 -> for문 X, Flag X, 기존에 있는지 확인해보고 있으면 호출 X 조회만  		
			Map<String, Object> result = new HashMap<String,Object>();
			String url = CommonProperty.getHanjinPrintUrl();					
			List<Map<String,Object>> itemTmp = hanjinDao.selectHanjinPrintList();                    
            
            if(!itemTmp.isEmpty()) {      
            	//HMAC Signature 생성
//            	String HMAC = "";        		
//            	HMAC = AuthTokenUtil.getHanjinHMAC();
            	
            	for(Map<String,Object> item : itemTmp) {     
	        		//호출
            		log.info("##### Hanjin 택배 Order 전 데이터  : "+ item.toString());
	                
	                try {			
	                	
	                	result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, item, null); // DEV
//    	       			result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, _adata, null); // PRD
	                	
	                	if("OK".equals(result.get("resultCode"))) {
	                		log.info("##### Hanjin 한진 택배 운송장 출력 성공 : ");
		       				result.put("flag", "Y");
//		       				hanjinDao.insertHanjinPrint(result);
		       			}else {
		       				log.info("##### Hanjin 한진 택배 운송장 출력 실패  : "+ result.get("message"));
		       				result.put("flag", "E");
		       				result.put("result_message", result.get("message"));
		       			}		       			 
	                }catch (Exception e) {
	                	result.put("flag", "E");
	                	result.put("result_message", e.getMessage());
					}finally {
//						hanjinDao.updateHanjinPrint(result);
					}
	       			
            	}
        	
            	log.info("##### Hanjin 한진 택배 운송장 출력 완료  : ");
            }	
            
		} catch (Exception e) {
			log.error("HanjinPrintService Error : " + CommonUtil.printStackTraceToString(e));
			try {
//				hanjinDao.updateHanjinPrintAllFail();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}

}
