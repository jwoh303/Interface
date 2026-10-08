package com.kep.duzon.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.duzon.dao.ErpDuzonDao;
import com.kep.duzon.dao.ErpKepconDao;
import com.kep.duzon.dao.ErpKepmpDao;

public class CreditService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public void getCredit() {
		
		ErpDuzonDao dzDao = new ErpDuzonDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpKepconDao conDao = new ErpKepconDao();
		
		try {
			List<Map<String, String>> creditList = dzDao.selectCredit();
			// 여신 데이터 초기화
			if (creditList.size() > 0) {
				mpDao.deleteCredit();
				conDao.deleteCredit();
				
				// KEPMP
				for ( Map<String, String> iMap : creditList) {
					mpDao.insertCredit(iMap);
				}
				// KEPCON
				for ( Map<String, String> iMap : creditList) {
					conDao.insertCredit(iMap);
				}
			} else {
				throw new Exception("여신 데이터 조회 안됨.");
			}
		} catch (Exception e) {
			log.error("getCredit Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void getCreditAging() {
		
		ErpDuzonDao dzDao = new ErpDuzonDao();
		ErpKepconDao conDao = new ErpKepconDao();
		
		try {
			List<Map<String, String>> tList = conDao.selectCreditAgingTargetList();
			
			if (tList.size() > 0) {
				conDao.deleteCreditAging();
				
				for ( Map<String, String> iMap : tList ) {
					List<Map<String, String>> tAgingList = dzDao.selectCreditAging(iMap);
					
					for (Map<String, String> jMap : tAgingList) {
						conDao.insertCreditAging(jMap);
					}
				}
			}
		} catch (Exception e) {
			log.error("getCreditAging Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
}