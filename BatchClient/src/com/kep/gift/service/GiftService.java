package com.kep.gift.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.gift.dao.KepGiftDao;
import com.kep.gift.dao.kepLinkDao;

public class GiftService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	public void createGift() {
		KepGiftDao giftDao = new KepGiftDao();
		kepLinkDao linkDao = new kepLinkDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String resultFlag = "";
		String resultMsg = "";
		String errApNo = "";
		try {
			List<Map<String,String>> linkList = linkDao.selectLinkList();
			
			if (linkList.size() > 0) {
				for (Map<String, String> iMap : linkList) {
					int cnt = 0;
					errApNo = iMap.get("AP_NO");
					
					try {
						List<Map<String,String>> cntList = giftDao.selectLinkData(iMap);
						String cntSt = String.valueOf(cntList.get(0).get("CNT"));
						cnt = Integer.parseInt(cntSt);
						
						if(cnt > 0) {
							giftDao.updateLinkData(iMap);
						}else {
							giftDao.insertLinkData(iMap);
						}	
						resultFlag = "Y";
					} catch (Exception e) {
						resultFlag = "E";
						resultMsg = "판촉 디비 연결 실패";
						log.error("Error : " + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("IF_FLAG", resultFlag);
					iMap.put("IF_MSG", resultMsg);
					linkDao.updateLinkFlag(iMap);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			//빈값 시 링크디비 selectLinkList 조회 시 에러 
			log.error("now errApNo!!"+ errApNo); 
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
		}
		
		
	}
}
