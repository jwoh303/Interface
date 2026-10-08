/**
 * 
 */
package com.kep.amorepacific.service;

import java.util.ArrayList;
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
import com.kep.amorepacific.dao.AmorepacificDao;
import com.kep.amorepacific.dao.AmorepacificDaoImpl;

/**
 * @author jiwon
 *
 */
public class AmorepacificFiCheckServiceImpl implements AmorepacificFiCheckService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	AmorepacificDao amorepacificDao = new AmorepacificDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 아모레퍼시픽 예산 통제 사전 검토
		 */
		Map<String, Object> result = new HashMap<String,Object>();
		try {
			Map<String,ArrayList<String>> _adata = new LinkedHashMap<String,ArrayList<String>>() ;
			String [] amoreKeys = {"BUKRS","ORDDT","AMT01","DEPT2","KOSTL","FISTL","HKONT"};
			 for(String key : amoreKeys) {
				 _adata.put(key, new ArrayList<String>()); 
			 };
            String url = CommonProperty.getAmorepacificUrl() + "ZFI_KEP_CHECK:svcFMI0067_KEP_SAP"; //FMI0067 FMI0027
            List<Map<String,String>> reqList = amorepacificDao.selectAmorepacificCheckParam();
            
        	String token = "";
        	for(Map<String,String> item : reqList) {
				 _adata.get("BUKRS").add(item.get("BUKRS"));
				 _adata.get("ORDDT").add(item.get("ORDDT"));
				 _adata.get("AMT01").add(item.get("AMT01"));
				 _adata.get("DEPT2").add(item.get("DEPT2"));
				 _adata.get("KOSTL").add(item.get("KOSTL"));
				 _adata.get("FISTL").add(item.get("FISTL"));
				 _adata.get("HKONT").add(item.get("HKONT"));
			 }
        	
            log.info("##### 아모레퍼시픽 예산통제사전검토 전송 전 데이터  : "+ _adata.toString());
   			result = HttpClientUtil.apiCallHttpArr("POST", "AMOREPACIFIC", url, _adata, token);
			
        	log.info("##### 아모레퍼시픽 예산통제사전검토 완료  : ");	
            
		} catch (Exception e) {
			result.put("IFRESULT", "E");
			result.put("IFMSG", e.getMessage());
			try {
//				amorepacificDao.updateAmorepacificCheckParam(result);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			log.error("AmorepacificFiCheckService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	
}
