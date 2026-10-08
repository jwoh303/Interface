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
import com.kep.amorepacific.dao.AmorepacificDao;
import com.kep.amorepacific.dao.AmorepacificDaoImpl;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;

/**
 * @author jiwon
 *
 */
public class AmorepacificFiOrderServiceImpl implements AmorepacificFiOrderService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	AmorepacificDao amorepacificDao = new AmorepacificDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 아모레퍼시픽 주문완료 전송
		 */
		Map<String, Object> result = new HashMap<String,Object>();
		try {		
			List<Map<String,String>> reqPrList = amorepacificDao.selectAmorepacificPrList();
			if(reqPrList.size() > 0) {     
				String token = "";
	            String url = CommonProperty.getAmorepacificUrl() + "ZFI_KEP_ORDER:svcFMI0068_KEP_SAP"; //FMI0068 FMI0028	            
            	for(Map<String,String> pr : reqPrList) {            	
            		result = new HashMap<String,Object>();
					Map<String,ArrayList<String>> _adata = new LinkedHashMap<String,ArrayList<String>>() ;
					String [] amoreKeys = {"GUBUN","BUKRS","ORDDT","ORD01","ORD02","ITEMC","ZITEMCT","ZSPEC","WAERS","POQTY","PRICE",
							"SALAMT","ORDNM","ORDNMN","TAKNM","TAKNMN","LIFNR","LIFNRT","DEPT2","KOSTL","FISTL","HKONT","LOGID"};
					for(String key : amoreKeys) {
						_adata.put(key, new ArrayList<String>()); 
					};
					
		            List<Map<String,String>> reqList = amorepacificDao.selectAmorepacificOrderParam(pr);            
		            List<Map<String,String>> reqTmp = new ArrayList<Map<String,String>>(reqList);    		
		            
		            log.info("##### reqTmp  : "+ reqTmp.toString());
		            if(reqList.size() > 0) {  // 조회되는거 있을때만 호출 추가           	
		            	for(Map<String,String> item : reqList) {
		            		_adata.get("GUBUN").add(item.get("GUBUN"));
		            		_adata.get("BUKRS").add(item.get("BUKRS"));
		            		_adata.get("ORDDT").add(item.get("ORDDT"));
		            		_adata.get("ORD01").add(item.get("ORD01"));
		            		_adata.get("ORD02").add(item.get("ORD02"));
		            		_adata.get("ITEMC").add(item.get("ITEMC"));
		            		_adata.get("ZITEMCT").add(item.get("ZITEMCT"));
		            		_adata.get("ZSPEC").add(item.get("ZSPEC"));
		            		_adata.get("WAERS").add(item.get("WAERS"));
		            		_adata.get("POQTY").add(String.valueOf(item.get("POQTY")));
		            		_adata.get("PRICE").add(String.valueOf(item.get("PRICE")));
		            		_adata.get("SALAMT").add(String.valueOf(item.get("SALAMT")));
		            		_adata.get("ORDNM").add(item.get("ORDNM"));
		            		_adata.get("ORDNMN").add(item.get("ORDNMN"));
		            		_adata.get("TAKNM").add(item.get("TAKNM"));
		            		_adata.get("TAKNMN").add(item.get("TAKNMN"));
		            		_adata.get("LIFNR").add(item.get("LIFNR"));
		            		_adata.get("LIFNRT").add(item.get("LIFNRT"));
		            		_adata.get("DEPT2").add(item.get("DEPT2"));
		            		_adata.get("KOSTL").add(item.get("KOSTL"));
		            		_adata.get("FISTL").add(item.get("FISTL"));
		            		_adata.get("HKONT").add(item.get("HKONT"));
		            		_adata.get("LOGID").add(item.get("LOGID"));
		            	}
		            	
		            	log.info("##### 아모레퍼시픽 주문완료 전송 전 데이터  : "+ _adata.toString());
		            	
		            	result = HttpClientUtil.apiCallHttpArr("POST", "AMOREPACIFIC", url, _adata, token);
		            	result = (Map<String, Object>) ((Map<String, Object>) result.get("RESPONSE")).get("OUTPUT");
		            	
		            	log.info("##### 아모레퍼시픽 주문완료 전송 완료  : "+ result.toString());
		            	
		            	//예산체크 결과 확인  
		            	if(result.get("PE_CHKYN").equals("Y - 성공")) {
		            		result.put("IFRESULT", "Y");
		            		amorepacificDao.insertAmorepacificOrderProgress(reqTmp);
		            	}else {
		            		result.put("IFRESULT", "E");
		            		amorepacificDao.updateAmorepacificOrderPrdt(reqTmp, result);  
		            	}
		            	
		            	amorepacificDao.updateAmorepacificOrderParam(reqTmp, result);
		            }
		    	}
			}

            log.info("##### 아모레퍼시픽 주문완료 DONE  ");
			
		} catch (Exception e) {
			result.put("IFMSG", e.getMessage());
			try {
				amorepacificDao.updateAmorepacificError(result);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			log.error("AmorepacificFiOrderService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	

}
