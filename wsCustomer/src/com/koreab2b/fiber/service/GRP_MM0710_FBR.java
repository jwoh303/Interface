package com.koreab2b.fiber.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_Con;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_ConBody;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_ConBodyLIKP;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_ConBodyLIPS;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_Con_response;
import com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_Con_responseBodyE_RETURN;
import com.esp.grpeccmm.k2pkbb.DT_ReqHeader;
import com.esp.grpeccmm.k2pkbb.SI_GRP_MM0710_SOProxy;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.UpdateIfStatus_Dao;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;
import com.koreab2b.fiber.dao.GRP_MM0710_FBR_Dao;
import com.koreab2b.sapInterface.util.DateTimeUtil;

public class GRP_MM0710_FBR {
	private Logger log = Logger.getLogger(this.getClass());
	
	public void execute() throws Exception {
		
		GRP_MM0710_FBR_Dao dao = new GRP_MM0710_FBR_Dao();
		List<Map<String,String>> pMaps		= new ArrayList<Map<String,String>>();
		int idx = 0;

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			dao.updateIF_KOLON_LIKP_FBR();
			pMaps = dao.selectFBRInvoiceList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( pMaps.size() ));
			
			if (pMaps != null) {
				
				for(Map<String, String> tMap : pMaps) {
					
					log.info("INV - parameter -");
					log.info("INV -------------------------------------");
					log.info("INV - BUYER        : "+tMap.get("BUYER"));
					log.info("INV - INV_NO       : "+tMap.get("INV_NO"));
					log.info("INV - TYPE         : "+tMap.get("TYPE"));
					log.info("INV -------------------------------------");
					
					List<Map<String, String>> likps = dao.selectFBRInvoiceHeader(tMap);
					List<Map<String, String>> lipss = dao.selectFBRInvoiceDetails(tMap);

					DT_GRP_MM0710_ConBodyLIKP[] invHeaders = new DT_GRP_MM0710_ConBodyLIKP[1];
					DT_GRP_MM0710_ConBodyLIPS[] invDetails = new DT_GRP_MM0710_ConBodyLIPS[lipss.size()];
					idx = 0;
					for(Map<String, String> iMap : likps) {
						invHeaders[idx++] = new DT_GRP_MM0710_ConBodyLIKP( iMap.get("LIFEX"), iMap.get("VBELN"), iMap.get("LIFNR"), iMap.get("LFDAT"), iMap.get("TYPE") );
						break;
					}
					idx = 0;
					for(Map<String, String> iMap : lipss) {
						invDetails[idx++] = new DT_GRP_MM0710_ConBodyLIPS(
								iMap.get("VBELN"), iMap.get("LIFEX"), iMap.get("POSNR"), 
								iMap.get("EBELN"), iMap.get("EBELP"), iMap.get("MATNR"), 
								iMap.get("MENGE"), iMap.get("MEINS"), iMap.get("LICHN"), 
								iMap.get("SPE_HERKL"), iMap.get("HSDAT"), iMap.get("STCD2"), 
								iMap.get("NAME1"), iMap.get("TEXT1"), iMap.get("TEXT2") );
					}

					DT_GRP_MM0710_ConBody body = new DT_GRP_MM0710_ConBody();
					body.setLIKP(invHeaders); //LIKP
					body.setLIPS(invDetails); //LIPS
					
					DT_ReqHeader header = new DT_ReqHeader();
					header.setZConSysId("K2P_KBB");
					header.setZInterfaceId("GRP_MM0710");
					header.setZPiUser("IF_K2PKBB");
					header.setZProSysId("GRP_ECC_MM");
					header.setZTimeId(DateTimeUtil.getFormatString("yyyyMMddHHmmssSSS"));
					header.setZUserId("koreab2b");

					DT_GRP_MM0710_Con con = new DT_GRP_MM0710_Con(header, body);
					log.debug("SI_GRP_MM0710_url : " + CommonProperty.getSI_GRP_MM0710_url());
					SI_GRP_MM0710_SOProxy proxy = new SI_GRP_MM0710_SOProxy(CommonProperty.getSI_GRP_MM0710_url());
					DT_GRP_MM0710_Con_response _res = proxy.SI_GRP_MM0710_SO(con);
					DT_GRP_MM0710_Con_responseBodyE_RETURN[] _returns = _res.getBody();
					for (DT_GRP_MM0710_Con_responseBodyE_RETURN tmp : _returns) {
						Map<String, String> pMap = new HashMap<String, String>();
						pMap.put("BUYER", tMap.get("BUYER"));
						pMap.put("INV_NO", tMap.get("INV_NO"));
						pMap.put("TYPE", tMap.get("TYPE"));

						log.info("INV VBELN      : " + tmp.getVBELN());
						log.info("INV RESULT CD  : " + tmp.getMSGTYPE());
						log.info("INV RESULT MSG : " + tmp.getMESSAGE());
						log.info("INV -------------------------------------");
						if ("S".equals(tmp.getMSGTYPE())) {
							pMap.put("VBELN", tmp.getVBELN());
							pMap.put("IF_FLAG", "Y");
							dao.updateLIPSResult(pMap);
						} else {
							pMap.put("IF_FLAG", "E");
							pMap.put("IF_MSG", tmp.getMESSAGE());
						}
						dao.updateLIKPResult(pMap);
					}
				}
			}
		} catch (Exception e) {
			log.error("GRP_MM0710_FBR Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}