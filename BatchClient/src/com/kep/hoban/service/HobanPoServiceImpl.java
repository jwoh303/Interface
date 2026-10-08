package com.kep.hoban.service;

import java.text.SimpleDateFormat;
/**
 * 
 */
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.hoban.dao.HobanPoDao;
import com.kep.hoban.dao.HobanPoDaoImpl;

/**
 * @author jiwon
 *
 */
public class HobanPoServiceImpl implements HobanPoService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HobanPoDao hobanPoDao = new HobanPoDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute(String SERVER_CHK, String dtFrom, String dtTo) {
		
		/**
		 * 호반 발주 호출 
		 */

		try {			
			Map<String, Object> result = new HashMap<String,Object>();
			String apiUrl = "";
			
			if("2".equals(SERVER_CHK)) {
				//운영
				apiUrl = "https://pms.resom.co.kr/api/pms/itf/mate/kpdelinfo"+"?dtFrom="+dtFrom.trim()+"&dtTo="+dtTo.trim()+"&vcode="+"06724";				
			}else {
				//개발
				apiUrl = "https://dev-pms.resom.co.kr/api/pms/itf/mate/kpdelinfo"+"?dtFrom="+dtFrom.trim()+"&dtTo="+dtTo.trim()+"&vcode="+"06724";
			}
            
			
    		// 발주 데이터 전송 
			result = HttpClientUtil.apiCallHttps("GET", "HOBAN", apiUrl, null, null);
			
			log.info("################# HOBAN PO result #################"+ result.toString());
			
			hobanPoDao.mergeHobanPoData(result);
        	
			log.info("################# HOBAN UPDATE PO DONE #################");
		} catch (Exception e) {
			log.error("HobanPoService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}

}



