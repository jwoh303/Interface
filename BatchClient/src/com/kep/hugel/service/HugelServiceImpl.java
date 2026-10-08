package com.kep.hugel.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.common.CommonUtil;
import com.kep.common.HttpClientUtil;
import com.kep.common.dao.ErrorLogMng_Dao;
import com.kep.common.dao.ErrorLogMng_DaoImpl;
import com.kep.hugel.dao.HugelDao;
import com.kep.hugel.dao.HugelDaoImpl;

/**
 * @author jiwon
 *
 */
public class HugelServiceImpl implements HugelService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HugelDao hugelDao = new HugelDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	ErrorLogMng_Dao errorLogMng_Dao = new ErrorLogMng_DaoImpl();
	
	@Override
	public void execute() {
		
		/**
		 * 휴젤 구매오더 전송 
		 */
		
		Map<String, Object> eMap = new HashMap<String,Object>();
		
		try {			
			Map<String, Object> result = new HashMap<String,Object>();			
            // REST 호출 URL
            String apiUrl = "https://is-dev.it-cpi015-rt.cfapps.ap12.hana.ondemand.com/http/MM0035";
            
            Map<String,Object> resultMap = new HashMap<String,Object>(); // 전송객체            
            List<Map<String,String>> prLstMap = hugelDao.selectHugelPrList(); // 구매 리스트 조회
            
            log.info("################# prLstMap  : "+ prLstMap);
            
            if(!prLstMap.isEmpty()) {
            	for(Map<String,String> obj : prLstMap) {
            		Map<String,Object> hMap = hugelDao.selectHugelPrHeader(obj); // 휴젤 헤더 조회
                    List<Map<String,Object>> iMaps = hugelDao.selectHugelPrItemList(obj); // 휴젤 아이템 조회
                    
                    if(!hMap.isEmpty() && !iMaps.isEmpty()) {
                    
	                	resultMap.put("IS_POHEADER", hMap);            
	                	resultMap.put("IT_POITEM", iMaps);
	                	
	                	log.info("################# HUGEL PO 전송 전 데이터  #################"+ resultMap.toString());
	                	
	            		// 구매오더 데이터 전송
	        			result = HttpClientUtil.apiCallHttps("POST", "HUGEL", apiUrl, resultMap, null);
	        			
	        			log.info("################# HUGEL PO result #################"+ result.toString());
	        			result.put("BUYER", obj.get("BUYER"));
	        			
	        			// 하나씩 업데이트 처리
	        			Integer updateNum = hugelDao.updatePrData(result);
	        			
	        			obj.put("IS_SUCCESS", updateNum.toString());
	        			
	                	updateProgress(obj);
            		}
            	}            		
            }			
			log.info("################# HUGEL UPDATE PO DONE #################");
		} catch (Exception e) {
			log.error("HugelService Error : " + CommonUtil.printStackTraceToString(e));			
			try {
				eMap.put("PGM_ID", "HugelServiceImpl");
				eMap.put("PGM_NAME", "구매오더 전송");				
				eMap.put("ERR_NOTE", e.toString());
				errorLogMng_Dao.saveErrLog(eMap);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		
		
		/**
		 * 휴젤 수정, 삭제 전송 
		 */

		try {			
			Map<String, Object> result = null;
            // REST 호출 URL
            String apiUrl = "https://is-dev.it-cpi015-rt.cfapps.ap12.hana.ondemand.com/http/MM0036";
            
            Map<String,Object> resultMap = null; // 전송객체            
            List<Map<String,Object>> chgDelLstMap = hugelDao.selectHugelChgDelList(); // 수정,삭제 리스트 조회   -> 추가 컬럼 JOIN해서 가져와야 함
            
            if(!chgDelLstMap.isEmpty()) {
            	for(Map<String,Object> obj : chgDelLstMap) {
            		result = new HashMap<String,Object>();
            		resultMap = new HashMap<String,Object>();
            		resultMap.put("EBELN", obj.get("EBELN"));
            		resultMap.put("IT_POITEM", obj);
            		
            		log.info("################# HUGEL CHG,DEL 전송 전 데이터  #################");
            		log.info(resultMap.toString());
            		
            		
            		if(Integer.parseInt((String)obj.get("MENGE")) < 1) {
            			result.put("ZSTATUS", "E");
            			result.put("ZMESSAGE", "구매 수량이 부족합니다.");
            		}else if(Integer.parseInt((String)obj.get("MENGE")) > Integer.parseInt((String)obj.get("EX_MENGE"))) {            			
            			result.put("ZSTATUS", "E");
            			result.put("ZMESSAGE", "기존보다 높은 수량으로 변경할 수 없습니다.");
            		}else {
                		// 수정,삭제 데이터 전송
            			result = HttpClientUtil.apiCallHttps("POST", "HUGEL", apiUrl, resultMap, null);
            		}
        			if("S".equals(result.get("ZSTATUS"))) {
        				log.info("################# HUGEL CHG,DEL SUCCESS #################");
        			}else {
        				log.info("################# HUGEL CHG,DEL FAIL #################");
        				resultMap.put("ZMESSAGE", result.get("ZMESSAGE"));
        				// 에러 전송 / 임시적으로 사내 이메일전송 PROC로 적어 뒀음 -> 휴젤 담당자 전송 PROC 개발해서 변경 필요
        				hugelDao.callProcHuglErr(resultMap);
        			}
        			result.put("IT_POITEM", resultMap.get("IT_POITEM"));
        			hugelDao.updateResultData(result);
            	}
            }			
		} catch (Exception e) {
			log.error("HugelService CHG,DEL Error : " + CommonUtil.printStackTraceToString(e));
		} 
	}
	
	// IF_PROGRESS 업데이트
	private boolean updateProgress(Map<String, String> pMap) throws Exception {
		
		Boolean isSuccess = new Boolean(false);
		
		isSuccess = hugelDao.updateProgress(pMap);
		
		return isSuccess;
	}
}
