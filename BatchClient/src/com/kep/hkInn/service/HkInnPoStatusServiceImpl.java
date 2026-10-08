/**
 * 
 */
package com.kep.hkInn.service;

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
import com.kep.common.dao.ErrorLogMng_Dao;
import com.kep.common.dao.ErrorLogMng_DaoImpl;
import com.kep.hkInn.dao.HkInnDao;
import com.kep.hkInn.dao.HkInnDaoImpl;

/**
 * @author jiwon
 *
 */
public class HkInnPoStatusServiceImpl implements HkInnPoStatusService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HkInnDao hkInnDao = new HkInnDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	ErrorLogMng_Dao errorLogMng_Dao = new ErrorLogMng_DaoImpl();
	

	@Override
	public void execute() {		
				
		/**
		 * HK이노엔 발주 상태 전송
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			List<Map<String,Object>> itemLst = null;
            Map<String, Object> paramMap = null;	
            Map<String, Object> itemIdxTmp = null;
            //CommonProperty에서 서버에 맞게 HKINN_NO 변경 
            //스마트잭 서버는 HTTP 호출이라 외부망에서 새로 토큰 호출해서 넘겨서 저장했음, 나머지는 HTTPS 토큰 유효날짜 수정해서 새로 발급받기
            String url = CommonProperty.getHkInnUrl() + "order/status";
            
            hkInnDao.updateHkInnDelNotInterPo(); // MRO 사이트 발주 제외 처리
            List<Map<String,Object>> poStatusIdx = hkInnDao.selectHkInnPoStatusIdx(); // 발주 번호, 회사코드 중복제거 조회            
            if(poStatusIdx.size() > 0) {
            	String token = "";        		
        		token = AuthTokenUtil.getInnToken();
        		for(Map<String,Object> obj : poStatusIdx) {
        			List<Map<String,Object>> legacyTmp = hkInnDao.selectHkInnPoStatusItem(obj); // 해당 발주 조회
        			log.info("#####  legacyTmp  : "+ legacyTmp.toString());
        			paramMap = new HashMap<String,Object>();
        			itemLst = new ArrayList<Map<String,Object>>();
        			if(legacyTmp.size() > 0) {
        				paramMap.put("idx",legacyTmp.get(0).get("IDX"));
        				for(Map<String,Object> tmp : legacyTmp) {
        					itemIdxTmp = new HashMap<String,Object>();
        					itemIdxTmp.put("itemIdx", tmp.get("ITEM_IDX"));
        					itemIdxTmp.put("status", tmp.get("STATUS"));
        					itemIdxTmp.put("dueDate", tmp.get("DUE_DATE"));
        					itemLst.add(itemIdxTmp);
        				}      
        			}
        			paramMap.put("items", itemLst);
        			
        			log.info("##### HKINN 발주상태 전송 전 데이터  : "+ paramMap.toString());
        			
        			// 품목 데이터 전송
        			result = HttpClientUtil.apiCallHttp("POST", "HKIN", url, paramMap, token);
        			
        			if((boolean) result.get("result")) {
        				log.info("##### HK이노엔 발주상태 전송 성공 : ");
        				hkInnDao.updateHkInnPoStatus(obj);
        			}else {
        				log.info("##### HK이노엔 발주상태 전송 실패  : "+ result.get("message"));				
        			}
        		}
        		log.info("##### HK이노엔 발주상태 완료");
            }
			
		} catch (Exception e) {
			log.error("HkInnPoStatusService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}

}
