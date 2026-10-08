/**
 * 
 */
package com.kep.skmw.service;

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
import com.kep.skmw.dao.SkMwDao;
import com.kep.skmw.dao.SkMwDaoImpl;

/**
 * @author jiwon
 *
 */
public class SkMwItemServiceImpl implements SkMwItemService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	SkMwDao skMwDao = new SkMwDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환	
	
	@Override
	public void execute() {
		
		/**
		 * SK마이크로웍스 품목 전송 
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			String url = "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				url = CommonProperty.getSkMwLiveUrl() + "item";
			} else {
				url = CommonProperty.getSkMwDevUrl() + "item";
			}
			
            List<Map<String,Object>> itemTmp = skMwDao.selectSkMwItemList();            
            
            if(!itemTmp.isEmpty()) {
            	String token = "";            	    		
        		token = AuthTokenUtil.getSkMwToken();
            	for(Map<String,Object> item : itemTmp) {
	        		//호출
	                log.info("##### SKMW ITEM 전송 전 데이터  : "+ item.toString());
	                
	       			result = HttpClientUtil.apiCallHttps("POST", "SKMW", url, item, token);
	    			
	       			if(result.get("result_status").equals("S")) {
	       				log.info("##### SK마이크로웍스 품목 전송 성공 : ");
	       				item.put("flag", "T");	  
	       			}else {
	       				log.info("##### SK마이크로웍스 품목 전송 실패  : "+ result.get("result_message"));
	       				item.put("flag", "E");	       				
	       			}
	       			item.put("msg", result.get("result_message"));
	       			skMwDao.updateSkMwItem(item);
            	}
            	log.info("##### SK마이크로웍스 품목 완료  : ");
            }	
            
		} catch (Exception e) {
			log.error("SkMwItemService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				skMwDao.updateSkMwErr();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}		
	}	
}
