/**
 * 
 */
package com.kep.hanssem.service;

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
import com.kep.hanssem.dao.HanssemDao;
import com.kep.hanssem.dao.HanssemDaoImpl;

/**
 * @author jiwon
 *
 */
public class HanssemPoListServiceImpl implements HanssemPoListService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanssemDao hanssemDao = new HanssemDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 한샘 주문내역대사 정보 수신 
		 */
		Map<String, Object> result = new HashMap<String,Object>();
		try {		
			
			Map<String, Object> paramMap = null;
			List<Map<String,Object>> paramLst = null;
            String url = CommonProperty.getHanssemUrl() + "MRO_ORDLIST_KEP_SC";
            
            // BUYER AS I_BUKRS --회사코드     '입고예정일 시작' AS I_RGRDT_FR --입고예정일 시작     '입고예정일 종료' AS I_RGRDT_TO --입고예정일 종료
//            List<Map<String,Object>> reqList = hanssemDao.selectHanssemTrxlPol();
//            
//            if(!reqList.isEmpty()) {
            	String token = "";
            	token = AuthTokenUtil.getHanssemToken();
        		paramMap = new HashMap<String,Object>();
//        		paramMap = reqList.get(0);
        		paramMap.put("I_BUKRS", "HS01");
        		paramMap.put("I_RGRDT_FR", "20250401");  
        		paramMap.put("I_RGRDT_TO", "20250430");  
        		
                log.info("##### 한샘 주문내역대사 전송 전 데이터  : "+ paramMap.toString());
       			result = HttpClientUtil.apiCallHttps("POST", "HANSSEM", url, paramMap, token);
    			
       			if(result.get("IFRESULT").equals("S")) {
       				log.info("##### 한샘 주문내역대사 전송 성공 : ");
       				hanssemDao.insertHanssemPoList(result);
       			}else {
       				log.info("##### 한샘 주문내역대사 전송 실패  : "+ result.get("IFMSG"));
       			}
       			// 테이블 생성되면 넣기
//       			hanssemDao.updateHanssemTrxlPol(result);
            	log.info("##### 한샘 주문내역대사 완료  : ");	
//            }
            
		} catch (Exception e) {
			result.put("IFRESULT", "E");
			result.put("IFMSG", e.getMessage());
			try {
				hanssemDao.updateHanssemTrxlPol(result);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			log.error("HanssemPoListService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	
}
