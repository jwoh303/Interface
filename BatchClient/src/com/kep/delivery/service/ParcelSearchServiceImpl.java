/**
 * 
 */
package com.kep.delivery.service;

import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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
public class ParcelSearchServiceImpl implements ParcelSearchService {

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
			List<Map<String,Object>> itemTmp = null;
			String url = "";			
//			if ( "2".equals(CommonProperty.getDB_CONN()) ) {//								
//				callback_url = "http://eai.koreab2b.com:9191/parcel.do";
//			} else {				
//				callback_url = "http://eai.koreab2b.com:9192/parcel.do";
//			}			
			url = CommonProperty.getParcelUrl();
			String token = "";        		
    		token = AuthTokenUtil.getParcelToken();
//			List<Map<String,Object>> itemTmp = parcelDao.selectParcelSrchList();
			
    		itemTmp = parcelDao.selectParcelSrchList();		
    		
            if(!itemTmp.isEmpty()) {      
            	int cnt = 0;
            	for(Map<String,Object> item : itemTmp) {            		
            		tmp = new HashMap<String,Object>();
            		log.info("##### Parcel 조회 전송 전 데이터  : "+ item.toString());
            		result = HttpClientUtil.apiCallHttps("POST", "PARCEL_S", url, item, token); // DEV
//       			result = HttpClientUtil.apiCallHttps("POST", "PARCEL_S", url, item, token); // PRD
            		String deliStatus = "";
            		tmp = Optional.ofNullable(result)
            				.map(m -> (Map<String,Object>) m.get("data"))
            				.map(m -> (Map<String,Object>) m.get("track"))
            				.map(m -> (Map<String,Object>) m.get("lastEvent"))
            				.orElse(null);
            		
	       			if(tmp != null) {
	       				log.info("##### Parcel 조회 결과 O : ");	      
	       				deliStatus = (String) ((Map<String, Object>) tmp.get("status")).get("code");
	       				item.put("status",deliStatus);
	       				log.info("##### deliStatus : "+ deliStatus);
	       				if("DELIVERED".equals(deliStatus)) {	       					
	       					item.put("flag", "T");	       		
	       				}else if("UNKNOWN".equals(deliStatus)){
	       					item.put("flag", "Y");	
	       				}else {
	       					item.put("flag", "S");
	       				}
	       				OffsetDateTime odt = OffsetDateTime.parse((String) tmp.get("time"));
	       				String formatted = odt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	       				item.put("lastTime", formatted);
	       				item.put("details", deliStatus);
	       				log.info("##### item : "+ item.toString());
//	       				parcelDao.insertParcelSrchDt(item);
	       			}else {
	       				log.info("##### Parcel 조회 결과 X : ");
	       				item.put("flag", "E");	       				
	       			}	       		
	       			
	       			parcelDao.updateParcelSrch(item);
            		
	       			cnt++;
	       			if(cnt % 10 == 0 && cnt < itemTmp.size()) {
	       				Thread.sleep(10000);
	       			}
            	}
        	
            	log.info("##### Parcel 조회 완료  : ");
            }	
            
		} catch (Exception e) {
			Map<String, Object> errTmp = new HashMap<String,Object>();
			String msg = e.getMessage();
			if(msg != null && msg.length() > 500) {
				msg = msg.substring(0,500);
			}
			errTmp.put("err", msg);
			log.error("ParcelService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				parcelDao.updateParcelSrchAllFail(errTmp);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}
}
