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
public class HkInnPoCancelServiceImpl implements HkInnPoCancelService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HkInnDao hkInnDao = new HkInnDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	ErrorLogMng_Dao errorLogMng_Dao = new ErrorLogMng_DaoImpl();
	

	@Override
	public void execute() {		
		
		/**
		 * HK이노엔 품목 발주 전체/부분 취소
		 */
		try {			
					
			// 주문 전체 취소시 건바이 건으로 발주 취소 데이터 전송 함 -> 전체 일때만이라 협의가 필요
			
			Map<String, Object> result = new HashMap<String,Object>();
			List<Map<String,Object>> itemLst = null;
            Map<String, Object> paramMap = null;
            Map<String, Object> itemIdxTmp = null;
            //CommonProperty에서 서버에 맞게 HKINN_NO 변경 
            //스마트잭 서버는 HTTP 호출이라 외부망에서 새로 토큰 호출해서 넘겨서 저장했음, 나머지는 HTTPS 토큰 유효날짜 수정해서 새로 발급받기
            String url = CommonProperty.getHkInnUrl() + "order/cancel";
            
            List<Map<String,Object>> poCancelIdx = hkInnDao.selectHkInnPoCancelIdx(); // 발주 번호, 회사코드 중복제거 조회
            if(poCancelIdx.size() > 0) {
            	String token = "";        		
        		token = AuthTokenUtil.getInnToken();
        		for(Map<String,Object> obj : poCancelIdx) {
                	List<Map<String,Object>> poCancelTmp = hkInnDao.selectHkInnPoCancelList(obj); // 해당 발주 조회
                	paramMap = new HashMap<String,Object>();
                	itemLst = new ArrayList<Map<String,Object>>();
                	if(poCancelTmp.size() > 0) {
                		paramMap.put("idx",poCancelTmp.get(0).get("IDX"));
                		paramMap.put("type",poCancelTmp.get(0).get("TYPE"));
                		if(poCancelTmp.get(0).get("TYPE").equals("P")) {
                			for(Map<String,Object> tmp : poCancelTmp) {
                				itemIdxTmp = new HashMap<String,Object>();
                				itemIdxTmp.put("itemIdx", tmp.get("ITEM_IDX"));
                				itemLst.add(itemIdxTmp);
                        	}            			
                		}
                		paramMap.put("items", itemLst);
                		//호출
                        log.info("##### HKINN 발주취소 전송 전 데이터  : "+ paramMap.toString());
                        
                        // 발주취소 데이터 전송
    			        result = HttpClientUtil.apiCallHttp("POST", "HKIN", url, paramMap, token);
            			
    			        if((boolean) result.get("result")) {
    			        	log.info("##### HK이노엔 발주취소 전송 성공 : ");
    			        	hkInnDao.updateHkInnPoCancel(obj);
    			        }else {
    			        	log.info("##### HK이노엔 발주취소 전송 실패  : "+ result.get("message"));
    			        	String msg = "";
    			        	if(result.get("message") != null) {    			        		
    			        		msg = (String) result.get("message");
    			        	}
    			        	obj.put("MSG", msg);
    			        	hkInnDao.updateHkInnPoCancelFail(obj);
    			        }
                	}
                }
        		log.info("##### HK이노엔 발주취소 완료");
            }
			
		} catch (Exception e) {
			log.error("HkInnPoCancelService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}

}
