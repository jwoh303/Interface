/**
 * 
 */
package com.kep.hanssem.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
public class HanssemAvailBudgetServiceImpl implements HanssemAvailBudgetService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	HttpClientUtil httpClient = new HttpClientUtil();
	HanssemDao hanssemDao = new HanssemDaoImpl();
	ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
	
	@Override
	public void execute() {
		
		/**
		 * 한샘 예산가용성 정보 수신 
		 */
		Map<String, Object> result = new HashMap<String,Object>();
		try {		
			Map<String, Object> paramMap = null;
            String url = CommonProperty.getHanssemUrl() + "MRO_AVAILBUDG_KEP_SC";
            
            // BUYER AS I_BUKRS --회사코드  '202501' AS YYYYMM --연월   COST_CENTER AS KOSTL --코스트센터   '계정'  AS SAKNR
            List<Map<String,Object>> reqList = hanssemDao.selectHanssemAvailBdgtParam();            
            
            if(!reqList.isEmpty()) {
            	List<Map<String,Object>> sendList = new ArrayList<Map<String,Object>>();
                List<Map<String,Object>> trxlList = new ArrayList<Map<String,Object>>();
                Map<String, Object> sendTmp = null;
                Map<String, Object> trxlTmp = null;
                for(Map<String,Object> req : reqList) {
                	sendTmp = new HashMap<String, Object>();
                	trxlTmp = new HashMap<String, Object>();
                	sendTmp.put("YYYYMM", req.get("YYYYMM"));
                	sendTmp.put("KOSTL", req.get("KOSTL"));
                	sendTmp.put("SAKNR", req.get("SAKNR"));
					sendList.add(sendTmp);
					trxlTmp.put("TARGET", req.get("TARGET"));
					trxlTmp.put("MYID", req.get("MYID"));
					trxlTmp.put("YYYYMM", req.get("YYYYMM"));
					trxlList.add(trxlTmp);
				}	
                Set<Map<String,Object>> trxlSet = new HashSet<Map<String,Object>>(trxlList);
                List<Map<String,Object>> disTrxlList = new ArrayList<Map<String,Object>>(trxlSet);
                log.info("##### sendList : "+ sendList.toString());
                log.info("##### disTrxlList : "+ disTrxlList.toString());
                
            	String token = "";
            	token = AuthTokenUtil.getHanssemToken();
        		paramMap = new HashMap<String,Object>();
        		paramMap.put("I_BUKRS", "HS01");
        		paramMap.put("IT_TAB", sendList);
        		
                log.info("##### 한샘 예산가용성 전송 전 데이터  : "+ paramMap.toString());
       			result = HttpClientUtil.apiCallHttps("POST", "HANSSEM", url, paramMap, token);
    			
       			if(result.get("IFRESULT").equals("S")) {       				
       				hanssemDao.insertHanssemAvailBdgt(result);
       				hanssemDao.execHanssemAvailBdgtProc();
       				log.info("##### 한샘 예산가용성 전송 성공 : ");
       			}else {
       				log.info("##### 한샘 예산가용성 전송 실패  : "+ result.get("IFMSG"));
       			}
       			result.put("TRXL", disTrxlList);
       			hanssemDao.updateHanssemTrxlAvailBdgt(result);
            	log.info("##### 한샘 예산가용성 완료  : ");	
            }
            
		} catch (Exception e) {
			result.put("IFRESULT", "E");
			result.put("IFMSG", e.getMessage());
			try {
				hanssemDao.updateHanssemTrxlAvailBdgt(result);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			log.error("HanssemAvailBudgetService Error : " + CommonUtil.printStackTraceToString(e));
		}		
	}	
}
