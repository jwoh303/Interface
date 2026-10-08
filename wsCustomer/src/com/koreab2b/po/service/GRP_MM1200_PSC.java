package com.koreab2b.po.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_Con;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_ConBodyDELIVERY_INFO;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_Con_response;
import com.esp.grpeccmm.k2pkbb.DT_ReqHeader;
import com.esp.grpeccmm.k2pkbb.DT_ResHeader;
import com.esp.grpeccmm.k2pkbb.SI_GRP_MM1200_SOProxy;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.dao.UpdateIfStatus_Dao;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;
import com.koreab2b.po.dao.GRP_MM1200_Dao;
import com.koreab2b.po.dao.GRP_MM1200_DaoImpl;
import com.koreab2b.sapInterface.util.DateTimeUtil;

@SuppressWarnings("unchecked")
public class GRP_MM1200_PSC implements GRP_MM1200_PSI {
	
	private static 	Logger		log		= Logger.getLogger(GRP_MM1200_PSC.class);
	
	@Override
	public void execute() throws Exception {
		
		GRP_MM1200_Dao dao	= new GRP_MM1200_DaoImpl();
		int idx = 0;
		
		Map<String, String> pMap	= new HashMap<String,String>();
		
		List<Map<String, String>> pMaps	= new ArrayList<Map<String,String>>();

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			/**
			 * Process
			 * 1. 작업대기 항목 업데이터 : update if_delivery_info set if_flag = 'T'
			 * 2. 전송대상 조회
			 * 3. 전송처리
			 * 4. 전송대상 완료처리
			 **/
			
			dao.updateReadyData();
			pMaps	= dao.selectDeliveryList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( pMaps.size() ));

			log.info("JOB_CNT : " + pMaps.size());
			if (pMaps != null && pMaps.size() > 0) {
				DT_GRP_MM1200_ConBodyDELIVERY_INFO[] bodys = new DT_GRP_MM1200_ConBodyDELIVERY_INFO[pMaps.size()];
				for(Map<String,String> tMap : pMaps) {
					bodys[idx++] = new DT_GRP_MM1200_ConBodyDELIVERY_INFO(
							tMap.get("EBELN"), tMap.get("EBELP"), tMap.get("SEQ"), tMap.get("NAME1"), tMap.get("STCD2"), 
							tMap.get("DELIVERY_DATE"), tMap.get("MENGE"), tMap.get("MEINS"), tMap.get("NAME2"), tMap.get("TEL_NUMBER"), 
							tMap.get("MOBILE_NUMBER"), tMap.get("SMTP_ADDR"), tMap.get("STATUS"), tMap.get("CHAR1"), tMap.get("CHAR2"), 
							tMap.get("CHAR3"), tMap.get("CHAR4"), tMap.get("CHAR5"), tMap.get("CHAR6"), tMap.get("CHAR7"), 
							tMap.get("CHAR8"), tMap.get("CHAR9"), tMap.get("CHAR10") 
							); 
				}
				DT_ReqHeader header = new DT_ReqHeader();
				header.setZConSysId("K2P_KBB");
				header.setZInterfaceId("GRP_MM1200");
				header.setZPiUser("IF_K2PKBB");
				header.setZProSysId("GRP_ECC_MM");
				header.setZTimeId(DateTimeUtil.getFormatString("yyyyMMddHHmmssSSS"));
				header.setZUserId("koreab2b");
				
				DT_GRP_MM1200_Con con = new DT_GRP_MM1200_Con(header, bodys);
				log.debug("KSI_GRP_MM1200_url : " + CommonProperty.getKSI_GRP_MM1200_url());
				SI_GRP_MM1200_SOProxy proxy = new SI_GRP_MM1200_SOProxy(CommonProperty.getKSI_GRP_MM1200_url());
				DT_GRP_MM1200_Con_response _res = proxy.SI_GRP_MM1200_SO(con);
				log.debug("_res : " + _res);
				
				DT_ResHeader _resHeader = _res.getHeader();
				log.debug("ResultCd : " + _resHeader.getZResultCd());
				pMap = new HashMap<String, String>();
				
				if("S".equals(_resHeader.getZResultCd())) {
					pMap.put("IF_FLAG", "Y");
					dao.updateSendData(pMap);
				} else {
					pMap.put("IF_FLAG", "E");
					dao.updateSendData(pMap);
				}
			}
			
			Map<String, String> tMap	= new HashMap<String, String>();
			tMap.put("COM_CODE", "KRKOLOG001");
			tMap.put("TASK_GUBUN","DS");
			tMap.put("TASK_ORDER","2");
			if_dao.updateIfStatus(tMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("DS - Error : " + e.getMessage());
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}