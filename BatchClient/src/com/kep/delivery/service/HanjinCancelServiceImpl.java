/**
 * 
 */
package com.kep.delivery.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
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
public class HanjinCancelServiceImpl implements HanjinCancelService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanjinDao hanjinDao = new HanjinDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환	
	
	@Override
	public void execute() {
		
		/**
		 * 한진 택배 주문 취소 API
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			String url = CommonProperty.getHanjinUrl() + "/parcel-delivery/v1/order/cancel-order";						
			List<Map<String,Object>> itemTmp = hanjinDao.selectHanjinCancelList();
            
            if(!itemTmp.isEmpty()) {      
            	//HMAC Signature 생성
            	String HMAC = "";        		
            	HMAC = AuthTokenUtil.getHanjinHMAC();
            	
            	for(Map<String,Object> item : itemTmp) {     
	        		//호출
	                log.info("##### Hanjin 택배 Cancel 전 데이터  : "+ item.toString());
	                
	                try {			
	                	
	                	result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, item, HMAC); // DEV
//	       				result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, _adata, HMAC); // PRD
	                	
	                	if("OK".equals(result.get("resultCode"))) {
		       				log.info("##### Hanjin 택배 Cancel 성공 : "); 
		       				result.put("flag", "Y");
		       			}else {
		       				log.info("##### Hanjin 택배 Cancel 실패  : "+ result.get("resultMessage"));
		       				result.put("flag", "E");
		       			}		       			 
	                }catch (Exception e) {
	                	result.put("flag", "E");
	                	result.put("resultCode", null);
	                	result.put("resultMessage", e.getMessage());
					}finally {
						hanjinDao.updateHanjinCancel(result);
					}	       			
	       			
            	}
            	log.info("##### Hanjin 택배 Cancel 완료  : ");
            }	
            
		} catch (Exception e) {
			log.error("HanjinCancelService Error : " + CommonUtil.printStackTraceToString(e));
			try {							
				hanjinDao.updateHanjinCancelAllFail();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}
}
