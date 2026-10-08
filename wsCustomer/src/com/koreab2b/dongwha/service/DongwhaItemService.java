package com.koreab2b.dongwha.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.dongwha.ECC_MM.MM50.MM50_MRO_REQROW;
import com.dongwha.ECC_MM.MM51.MM51_MRO_REQROW;
import com.dongwha.ECC_MM.MM51.MM51_REQ_SOProxy;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.dongwha.dao.MM51_MRO_REQROW_Dao;

/**
 * 자재정보 IF
 * @author JINSOO-OUT
 *
 */
public class DongwhaItemService {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	public void execute() throws Exception {

		MM51_MRO_REQROW_Dao dao = new MM51_MRO_REQROW_Dao();
		List<Map<String,String>> pMaps = dao.selectItemList();
		int cnt = 0;
		int size = pMaps.size();
		String [] buyer = new String[size];
		try {
			
			com.dongwha.ECC_MM.MM51.MM51_MRO_REQROW[] arrReq = new MM51_MRO_REQROW[size];
			
			if(size > 0) {
			for ( Map<String,String> iMap : pMaps) {
				
				arrReq[cnt++] = new MM51_MRO_REQROW(iMap.get("IF_NO"),
													iMap.get("CATEGORY_NO"),
													iMap.get("DESCRIPTION_ENG"),
													iMap.get("DESCRIPTION_LOC"),
													iMap.get("SPECIFICATION_ENG"),
													iMap.get("DATA01"),
													iMap.get("MAKER_NAME"),
													iMap.get("ADD_USER_ID"),
													iMap.get("UNIT_MEASURE"));
				
				log.info("iMap : " + iMap);
			}
			
			MM51_REQ_SOProxy proxy = new MM51_REQ_SOProxy( CommonProperty.getMM51_HTTP_url());
			com.dongwha.ECC_MM.MM51.MM51_MRO_RESPROW[] arrRes = proxy.MM51_REQ_SO(arrReq);
			
			log.info("arrReq.length : " + arrReq.length);
			log.info("arrRes.length : " + arrRes.length);
			
				for (int i = 0 ; i<arrReq.length; i++) {
					Map<String, String> pMap = new HashMap<String, String>();
					
					log.info("getIF_NO : " + arrRes[i].getIF_NO());
					log.info("getRESULT_FLAG : " + arrRes[i].getRESULT_FLAG());
					log.info("getRESULT_MSG : " + arrRes[i].getRESULT_MSG());
					
					pMap.put("QUOTATION_NO", arrRes[i].getIF_NO());
					
					if ("C".equals(arrRes[i].getRESULT_FLAG())) {
						pMap.put("IF_FLAG", "Y");
						pMap.put("IF_MSG", arrRes[i].getRESULT_MSG());
						
					} else {
						pMap.put("IF_FLAG", "E");
						pMap.put("IF_MSG", arrRes[i].getRESULT_MSG());
					}
					
					log.info("pMap : " + pMap );
					dao.UpdateItemList(pMap);
					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}