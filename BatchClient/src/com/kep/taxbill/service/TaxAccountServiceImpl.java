package com.kep.taxbill.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.taxbill.dao.TaxAccountDao;
import com.kep.taxbill.dao.TaxAccountDaoImpl;
import com.kep.taxbill.dao.TaxAccountErpDao;
import com.kep.taxbill.dao.TaxAccountErpDaoImpl;

public class TaxAccountServiceImpl implements TaxAccountService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void executeBatch() {
		/**
		 * 부가새 대상 리스트 IF
		 * 1. 부가세 대상을 ERP에서 조회한다. (ACCNO, ACCSEQ)
		 * 2. IF 전체 데이터 조회
		 * 3. TACCOUNT_TAX_IF 테이블에 저장.
		 * 4. 저장 완료 후 삭제 데이터건에 대해서 매핑 삭제 처리함.
		 */
		
		TaxAccountDao mpDao	= new TaxAccountDaoImpl();
		TaxAccountErpDao erpDao	= new TaxAccountErpDaoImpl();
		List<Map<String, Object>> pList	= new ArrayList<Map<String, Object>>();

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			log.info("TaxAccountService Start...");

			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			List<Map<String, String>> iList	= erpDao.selectTargetList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( iList.size() ));
			
			for(Map<String, String> iMap : iList) {
				
				pList.clear();
				
				log.info("TaxAccount : " + iMap.get("ACCNO") + " / " + iMap.get("ACCSEQ") + " / " + iMap.get("STATUS") );
				
				if ("C".equals(iMap.get("STATUS"))) {
					pList = erpDao.selectTaccountIfGLList(iMap);	
				} else {
					pList = erpDao.selectTaccountIfHisList(iMap);
				}
				
				for(Map<String, Object> pMap : pList) {
					log.debug("mergeTaccountData : " + pMap);
					mpDao.mergeTaccountData(pMap);
				}
			}
			
			mpDao.deleteMappingDataForTaccountCancel();
			
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
		log.info("TaxAccountService Finish...");
	}

}