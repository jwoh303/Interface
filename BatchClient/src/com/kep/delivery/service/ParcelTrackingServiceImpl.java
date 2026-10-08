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
import com.kep.delivery.dao.ParcelDao;
import com.kep.delivery.dao.ParcelDaoImpl;

/**
 * @author jiwon
 *
 */
public class ParcelTrackingServiceImpl implements ParcelTrackingService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	ParcelDao parcelDao = new ParcelDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 택배 추적 Open API
		 */
		try {			
			
			Map<String, Object> result = new HashMap<String,Object>();
			Map<String, Object> tmp = null;
			String url = "";			
//			if ( "2".equals(CommonProperty.getDB_CONN()) ) {//								
//				callback_url = "http://eai.koreab2b.com:9191/parcel.do";
//			} else {				
//				callback_url = "http://eai.koreab2b.com:9192/parcel.do";
//			}			
			url = CommonProperty.getParcelUrl();
			String token = "";        		
    		token = AuthTokenUtil.getParcelToken();
			List<Map<String,Object>> itemTmp = parcelDao.selectParcelTrkgList();		
            
            if(!itemTmp.isEmpty()) {      
            	for(Map<String,Object> item : itemTmp) {
            		tmp = new HashMap<String,Object>();
            		log.info("##### Parcel 추적 전송 전 데이터  : "+ item.toString());
            		result = HttpClientUtil.apiCallHttps("POST", "PARCEL_T", url, item, token); // DEV
//       			result = HttpClientUtil.apiCallHttps("POST", "PARCEL_T", url, item, token); // PRD
            		tmp = (Map<String, Object>) result.get("data");
            		log.info("##### tmp  : "+ tmp.toString());
	       			if((boolean)tmp.get("registerTrackWebhook")) {
	       				log.info("##### Parcel 추적 전송 성공 : ");    		
	       				item.put("flag", "Y");	       				 
	       			}else {
	       				log.info("##### Parcel 추적 전송 실패  : ");
	       				item.put("flag", "E");	       					       				
	       			}
	       			parcelDao.updateParcelTrkg(item);
            		
            	}
        	
            	log.info("##### Parcel 추적 완료  : ");
            }	
            
		} catch (Exception e) {
			log.error("ParcelService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				parcelDao.updateParcelTrkgAllFail();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}

}
