package com.kep.woojin.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.woojin.dao.KepAppStatusDao;
import com.kep.woojin.dao.KepAppStatusDaoImpl;
import com.kep.woojin.dao.WoojinAppStatusDao;
import com.kep.woojin.dao.WoojinAppStatusDaoImpl;

public class AppStatusServiceImpl implements AppStatusService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private WoojinAppStatusDao	wDao	= new WoojinAppStatusDaoImpl();
	private KepAppStatusDao	kDao	= new KepAppStatusDaoImpl();

	@Override
	public void executeBatch() {
		/**
		 * 1. SELECT KEP APP LIST
		 * 2. LOOP 
		 * 3. UPDATE KEP APP_STATUS
		 * 4. UPDATE WOOJIN IF_FLAG
		 */
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			List<Map<String, String>> appList	= kDao.selectAppTargetList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( appList.size() ));
			
			for(Map<String, String> iMap : appList) {
				
				kDao.updateAppTargetInfo(iMap);
				Map<String, String> tMap = wDao.selectBuyerAppInfo(iMap);

				if (tMap != null) {
					tMap.put("BUYER", iMap.get("BUYER"));
					kDao.updateAppTargetInfo(tMap);
					kDao.updateAppStatus(tMap);	
				} else {
					log.error("BuyerAppInfo Not Found : " + iMap.get("BUYER") + " / " + iMap.get("DOC_NO"));
				}
			}
		} catch (Exception e) {
			log.error("AppStatusService error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}