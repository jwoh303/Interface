package com.koreab2b.inv.service;

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
import com.koreab2b.common.dao.UpdateIfStatus_Dao;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;
import com.koreab2b.inv.dao.GRP_MM0710_Dao;
import com.koreab2b.inv.dao.GRP_MM0710_DaoImpl;
import com.koreab2b.sapInterface.util.DateTimeUtil;

public class GRP_MM0710_PSC implements GRP_MM0710_PSI {
	
	private static 	Logger		log		= Logger.getLogger(GRP_MM0710_PSC.class);

	@SuppressWarnings("unchecked")
	@Override
	public void execute(String buyer, String inv_no, String process_type) throws Exception {
		GRP_MM0710_Dao dao	= new GRP_MM0710_DaoImpl();
		int idx = 0;
		
		HashMap<String, String>	paramMap	= new HashMap<String, String>();
		List<Map<String,String>> pMaps		= new ArrayList<Map<String,String>>();
		
		List<Map<String,String>> iHeader	= null;
		List<Map<String,String>> iDetail	= null;
		
		int i	= 0;

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
			 * 거래명세서 인터페이스 
			 * 1. SELECT INV_HD DATA
			 * 2. SELECT INV_DT DATA
			 * 3. SEND DATA
			 * 4. CHECK RESULT
			 *   4-1. IF SUCCESS 
			 *     4-1-1. UPDATE ICOMIVHD, WMSIVDT
			 *     4-1-2. INSERT IF_KOLON_....
			 *   4-2. IF_ FAIL
			 *     Throw Exception...
			 */

			if (process_type == null) {
				process_type = "ALL";
			}
			if (buyer == null) {
				buyer = " ";
			}

			paramMap.put("BUYER",buyer);
			paramMap.put("PROCESS_TYPE",process_type);

			dao.updateIF_KOLON_LIKP_ALL(paramMap);
			pMaps	= dao.selectSendList(paramMap);

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( pMaps.size() ));
			
			if (pMaps != null) {

				for(Map<String,String> tMap : pMaps) {
					
					log.info("INV - parameter -");
					log.info("INV -------------------------------------");
					log.info("INV - BUYER        : "+tMap.get("BUYER"));
					log.info("INV - INV_NO       : "+tMap.get("INV_NO"));
					log.info("INV - TYPE         : "+tMap.get("TYPE"));
					log.info("INV -------------------------------------");
					
					List<Map<String, String>> likps = dao.selectLikpList(tMap);
					List<Map<String, String>> lipss = dao.selectLipsList(tMap);
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
					log.info("KSI_GRP_MM0710_url : " + CommonProperty.getKSI_GRP_MM0710_url());
					SI_GRP_MM0710_SOProxy proxy = new SI_GRP_MM0710_SOProxy(CommonProperty.getKSI_GRP_MM0710_url());
					DT_GRP_MM0710_Con_response _res = proxy.SI_GRP_MM0710_SO(con);
					DT_GRP_MM0710_Con_responseBodyE_RETURN[] _returns = _res.getBody();
					for (DT_GRP_MM0710_Con_responseBodyE_RETURN tmp : _returns) {

						log.info("INV - Result invNo  : " + tmp.getLIFEX());
						log.info("INV - Result sapNo  : " + tmp.getVBELN());
						log.info("INV - Result CD     : " + tmp.getMSGTYPE());
						log.info("INV - Result Msg    : " + tmp.getMESSAGE());
						
						paramMap	= new HashMap<String, String>();

						paramMap.put("BUYER",tMap.get("BUYER"));
						paramMap.put("INV_NO",tMap.get("INV_NO"));
						paramMap.put("TYPE", tMap.get("TYPE"));
						
						if ("S".equals(tmp.getMSGTYPE())) {
							paramMap.put("LEGACY_IV_SERIAL",tmp.getVBELN());
							dao.updateIF_KOLON_LIKP_SUCCESS(paramMap);
							dao.updateIF_KOLON_LIPS(paramMap);
						} else {
							paramMap.put("IF_MSG", tmp.getMESSAGE());
							dao.updateIF_KOLON_LIKP_FAIL(paramMap);
						}
					}
				}
			}
			
			Map<String, String> tMap	= new HashMap<String, String>();
			tMap.put("COM_CODE", "KRKOLOG001");
			tMap.put("TASK_GUBUN","IV");
			tMap.put("TASK_ORDER","2");
			if_dao.updateIfStatus(tMap);

		} catch (Exception e) {
			e.printStackTrace();
			log.error("INV - Error : " + e.getMessage());
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}

	}

}
