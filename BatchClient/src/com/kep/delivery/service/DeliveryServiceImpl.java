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
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.delivery.dao.DeliveryDao;
import com.kep.delivery.dao.DeliveryDaoImpl;

/**
 * @author jiwon
 *
 */
public class DeliveryServiceImpl implements DeliveryService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	DeliveryDao deliveryDao = new DeliveryDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환	
	
	@Override
	public void execute() {
		
		/**
		 * 택배 추적 API
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> deliInfo = CommonProperty.getDeliveryInfo();
			String url = (String) deliInfo.get("url");
			String callback_url = (String) deliInfo.get("callbackUrl");
			
			List<Map<String,Object>> itemTmp = deliveryDao.selectDeliveryItemList();
            Map<String,Object> _adata = new LinkedHashMap<String,Object>() ;
            _adata.put("callback_url", callback_url);
            _adata.put("callback_type", "json");            
            _adata.put("tier", "koreab2b"); //dev : testuser
            _adata.put("key", "NCY8DNLLZW3shzoJBL78JQ");  //dev : testuser
            _adata.put("list", itemTmp);
            
            if(!itemTmp.isEmpty()) {      
            	
        		//호출
                log.info("##### Delivery 추적 전송 전 데이터  : "+ _adata.toString());
                
//       			result = HttpClientUtil.apiCallHttp("POST", null, url, _adata, null); // DEV
       			result = HttpClientUtil.apiCallHttps("POST", null, url, _adata, null); // PRD
    			
       			if((boolean) result.get("success")) {
       				log.info("##### Delivery 추적 전송 성공 : ");
       				List<Map<String,Object>> resultLst = (List<Map<String, Object>>) result.get("list");       				
       				deliveryDao.updateDeliveryItem(resultLst); 
       			}else {
       				log.info("##### Delivery 추적 전송 실패  : "+ result.get("result_message"));
       				deliveryDao.updateDeliAllFail();	       				
       			}
        	
            	log.info("##### Delivery 추적 완료  : ");
            }	
            
		} catch (Exception e) {
			log.error("DeliveryService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				deliveryDao.updateDeliAllFail();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}

}
