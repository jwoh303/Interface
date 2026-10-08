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
public class HkInnItemServiceImpl implements HkInnItemService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HkInnDao hkInnDao = new HkInnDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	ErrorLogMng_Dao errorLogMng_Dao = new ErrorLogMng_DaoImpl();
	

	@Override
	public void execute() {
		
		Map<String, Object> successMap = new HashMap<String,Object>();
		successMap.put("result_flag", "Y");
		/**
		 * HK이노엔 품목 등록/수정
		 */
		try {			
					
			Map<String, Object> result = new HashMap<String,Object>();
			List<Map<String,Object>> itemLst = new ArrayList<Map<String,Object>>();
            Map<String, Object> paramMap = new HashMap<String,Object>();
            
            //CommonProperty에서 서버에 맞게 HKINN_NO 변경 
            //스마트잭 서버는 HTTP 호출이라 외부망에서 새로 토큰 호출해서 넘겨서 저장했음, 나머지는 HTTPS 토큰 유효날짜 수정해서 새로 발급받기
            String url = CommonProperty.getHkInnUrl() + "product";
            int end = 299;
            int total = 0;            
            hkInnDao.updateItemFlag();
            List<Map<String,Object>> itemTmp = hkInnDao.selectHkInnItemList(); // 품목 브랜드 리스트 조회
            total = itemTmp.size();
            if(total > 0) {
            	String token = "";        		
        		token = AuthTokenUtil.getInnToken();
            	for(int i = 0 ; i < itemTmp.size(); i++ ) {
                	itemLst.add(itemTmp.get(i));
                	if(i == end || i == itemTmp.size()-1) {
                		//호출
                		paramMap.put("total", itemLst.size());
                        paramMap.put("items", itemLst);
                        log.info("##### HKINN ITEM 전송 전 데이터  : "+ paramMap.toString());
                        
                		// 품목 데이터 전송
            			result = HttpClientUtil.apiCallHttp("POST", "HKIN", url, paramMap, token);
            			if((boolean) result.get("result")) {
            				log.info("##### HK이노엔 품목 전송 성공 : ");
            			}else {
            				log.info("##### HK이노엔 품목 전송 실패  : "+ result.get("message"));
            				successMap.put("result_flag", "E");
            			}
            			
            			paramMap = new HashMap<String,Object>();	
            			itemLst = new ArrayList<Map<String,Object>>();
                		end += 300;
                		Thread.sleep(1000);
                	}
                }                
                hkInnDao.updateItemRslt(successMap);
                log.info("##### HK이노엔 품목 등록/수정 완료");
            }
			
		} catch (Exception e) {
			log.error("HkInnItemService Error : " + CommonUtil.printStackTraceToString(e));
			try {
				hkInnDao.updateItemRslt(successMap);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}

}
