package com.koreab2b.dongwha.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import com.dongwha.ECC_MM.MM50.MM50_MRO_REQROW;
import com.dongwha.ECC_MM.MM50.MM50_REQ_SOProxy;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.dongwha.dao.MM50_MRO_REQROW_Dao;

/**
 * 주문정보 IF
 * @author JINSOO-OUT
 *
 */
public class DongwhaPRService {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	public void execute() throws Exception {
		
		MM50_MRO_REQROW_Dao dao = new MM50_MRO_REQROW_Dao();
		List<Map<String,String>> pMaps = dao.selectPrList();
		int cnt = 0;
		int size = pMaps.size();
		
		try {
			
			com.dongwha.ECC_MM.MM50.MM50_MRO_REQROW[] arrReq = new MM50_MRO_REQROW[size]; 
			
			if(size > 0) {
			for ( Map<String,String> iMap : pMaps) {
				
				log.debug(iMap);
				arrReq[cnt++] = new MM50_MRO_REQROW(iMap.get("IF_NO")
												   ,iMap.get("IF_SEQ")
												   ,iMap.get("BUYER_ITEM_NO")
												   ,iMap.get("UNIT_MEASURE")
												   ,String.valueOf(iMap.get("UNIT_PRICE"))
												   ,String.valueOf(iMap.get("ITEM_QTY"))
												   ,String.valueOf(iMap.get("ITEM_AMT"))
												   ,iMap.get("CURRENCY_CODE")
												   ,iMap.get("BUDGET_DEPT")
												   ,iMap.get("ASSET")
												   ,iMap.get("PLANT")
												   ,iMap.get("COMPANY")
												   ,iMap.get("RD_DATE")
												   ,iMap.get("ADD_USER")
												   ,iMap.get("KNTTP")
												   ,iMap.get("ABRAD")
												   ,iMap.get("WEMPF")
												   ,iMap.get("ACCOUNT_TYPE")
												   ,iMap.get("LGORT")
												   ,iMap.get("BUYER")
												   ,iMap.get("PR_NO")
												   ,iMap.get("PR_SEQ")
												   ,iMap.get("DOC_TYPE"));
		
			}

			MM50_REQ_SOProxy proxy = new MM50_REQ_SOProxy( CommonProperty.getMM50_HTTP_url() );
			com.dongwha.ECC_MM.MM50.MM50_MRO_RESPROW[] arrRes = proxy.MM50_REQ_SO(arrReq);
			

				for (int i = 0 ; i< arrReq.length ; i++ ) {
					Map<String, String> pMap = new HashMap<String, String>();

					String p = get_Split(arrRes[i].getRESULT_MSG());

					String []arr_if = p.split("-");
							
					pMap.put("IF_NO", arr_if[0]);
					pMap.put("IF_SEQ", arr_if[1]);
							
					log.debug("getIF_NO() : " + arr_if[0]);        // IF_NO
					log.debug("getIF_SEQ() : " + arr_if[1]);		  // IF_SEQ	
					
					
					log.debug("pMap() : " + pMap);
					
					if ("C".equals(arrRes[i].getRESULT_FLAG())) {
						pMap.put("IF_FLAG", "Y");
						pMap.put("IF_MSG", arrRes[i].getRESULT_MSG());
												
					} else {

						pMap.put("IF_FLAG", "E");
						pMap.put("IF_MSG", arrRes[i].getRESULT_MSG());
					}
					log.debug("pMap : " + pMap);
					dao.UpdatePrList(pMap);
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("DongWhaPrService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public String get_Split (String if_msg) throws Exception {
		String if_key = "";
		int end = if_msg.indexOf("]");
		
		if (end >= 0) {
			if_key = if_msg.substring(1,end);
		} else {
			if_key = if_msg;
		}
		return if_key;
	}
}