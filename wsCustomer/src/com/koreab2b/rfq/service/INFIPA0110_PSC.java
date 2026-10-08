/**
 * 
 */
package com.koreab2b.rfq.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.esp.infipa.k2pkbb.DT_INFIPA0110_Con;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBody;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyQTA_HEADER;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyQTA_ITEM;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyQTA_REF_VENDOR;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyRFQ_HEADER;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyRFQ_ITEM;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_ConBodyRFQ_VENDOR;
import com.esp.infipa.k2pkbb.DT_INFIPA0110_Con_response;
import com.esp.infipa.k2pkbb.SI_INFIPA0110_SOProxy;
import com.esp.infipa.k2pkbb.DT_ReqHeader;
import com.esp.infipa.k2pkbb.DT_ResHeader;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.UpdateIfStatus_Dao;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;
import com.koreab2b.rfq.dao.INFIPA0110_Dao;
import com.koreab2b.rfq.dao.INFIPA0110_DaoImpl;
import com.koreab2b.sapInterface.util.DateTimeUtil;

/**
 * @author jiwon
 *
 */
public class INFIPA0110_PSC implements INFIPA0110_PSI {
	
	private static 	Logger		log		= Logger.getLogger(INFIPA0110_PSC.class);
	@Override
	public void execute(String buyer, String quotation_no, String revision) throws Exception {
		INFIPA0110_Dao dao	= new INFIPA0110_DaoImpl();
		int idx = 0;

		Map<String, String>	paramMap	= new HashMap<String, String>();
		List<Map<String,String>> pMaps	= new ArrayList<Map<String,String>>();
		List<Map<String,String>> infipaMaps	= new ArrayList<Map<String,String>>();
		
		List<Map<String,String>> rHeaders	= null;
		List<Map<String,String>> rItems		= null;
		List<Map<String,String>> rVendors	= null;
		List<Map<String,String>> qHeaders	= null;
		List<Map<String,String>> qItems		= null;
		List<Map<String,String>> qRefs		= null;
		
		String returnMsg	= "";
		
		try {
			/**
			 * 견적제출
			 * 1. SELECT DATA....
			 * 2. SEND
			 * 3. CHECK RESULT
			 *  3-1. IF SUCCESS
			 *    - UPDATE KEPRQDT
			 *    - INSERT HISTORY
			 *  3-2. IF FAILURE
			 *    - 
			 */
			paramMap	= new HashMap<String, String>();
			
			paramMap.put("NEXT_ST", "T");
			paramMap.put("PREV_ST", "N");

			int rtnCnt	= dao.updateIpaIF_KOLON_RFQ_HEADER(paramMap);
			pMaps	= dao.selectIpaRFQSendList();			
			
			log.info("IPA_RFQ -  * Count : " + pMaps.size() );
			
			for(Map<String,String> tMap : pMaps) {
				returnMsg	= "";
				
				try {
					log.info("IPA_RFQ - -----------------------------------");
					log.info("IPA_RFQ - - BUYER        : " + tMap.get("BUYER"));
					log.info("IPA_RFQ - - QUOTATION_NO : " + tMap.get("QUOTATION_NO"));
					log.info("IPA_RFQ - - REF_NO       : " + tMap.get("REF_NO"));
					log.info("IPA_RFQ - -----------------------------------");
					

					rHeaders	= dao.selectIpaRfqHeaderList(tMap);
					rItems		= dao.selectIpaRfqItemList(tMap);
					rVendors	= dao.selectIpaRfqVendorList(tMap);
					qHeaders	= dao.selectIpaQtaHeaderList(tMap);
					qItems		= dao.selectIpaQtaItemList(tMap);
					qRefs		= dao.selectIpaQtaRefVendorList(tMap);

					idx = 0;
					DT_INFIPA0110_ConBodyRFQ_HEADER[] rfqHeaders = new DT_INFIPA0110_ConBodyRFQ_HEADER[1];
					for(Map<String, String> rHeader : rHeaders) {
						rfqHeaders[idx++] = new DT_INFIPA0110_ConBodyRFQ_HEADER(rHeader.get("BIZ_CLS"), rHeader.get("COMP_CD"), rHeader.get("RFQ_NO"), rHeader.get("RFQ_CNT"), rHeader.get("RFQ_TIT"), rHeader.get("RFQ_REQ_TYP"), rHeader.get("RFX_TYP"), rHeader.get("BID_TYP"), rHeader.get("CPT_TYPE_CD"), rHeader.get("VD_STL_TYP"), rHeader.get("PRC_STL_TYP"), rHeader.get("RFQ_DATE"), rHeader.get("RFQ_START_DT"), rHeader.get("RFQ_CLOSE_DT"), rHeader.get("RFQ_MOD_CLOSE_DT"), rHeader.get("PURC_GRP_CD"), rHeader.get("RFQ_CUR"), rHeader.get("SHIPPER_TYPE"), rHeader.get("PURC_TYP"), rHeader.get("RFQ_PROG_STS"), rHeader.get("RFQ_END_STS"), rHeader.get("DELAY_RATE"));
						break;	
					}

					
					idx = 0;
					DT_INFIPA0110_ConBodyRFQ_ITEM[] rfqItems = new DT_INFIPA0110_ConBodyRFQ_ITEM[rItems.size()];
					for(Map<String, String> rItem : rItems) {
						rfqItems[idx++] = new DT_INFIPA0110_ConBodyRFQ_ITEM(rItem.get("COMP_CD"), rItem.get("RFQ_NO"), rItem.get("RFQ_CNT"), rItem.get("RFQ_LNO"), rItem.get("PURC_TYP"), rItem.get("PLT_CD"), rItem.get("ITEM_CD"), rItem.get("ITEM_NM"), rItem.get("CHEM_MATL_YN"), rItem.get("SPEC"), rItem.get("UNIT_CD"), rItem.get("ITEM_QTY"), rItem.get("RFQ_PRICE"), rItem.get("TGT_PRICE"), rItem.get("LMT_PRICE"), rItem.get("WH_CD"), rItem.get("RD_DATE"), rItem.get("PRD_SD"), rItem.get("PRD_ED"), rItem.get("STL_YN"), rItem.get("STL_QTY"), rItem.get("PRICE_UNIT"), rItem.get("CUR"), rItem.get("PR_NO"), rItem.get("PR_LNO"), rItem.get("PR_REQ_DATE"), rItem.get("KAMS_PR_NO"), rItem.get("ITEM_CATE"), rItem.get("REG_ID"), rItem.get("WBS"), rItem.get("WBS_DESC"), rItem.get("ZZAFNAM"));
					}					

					idx = 0;
					DT_INFIPA0110_ConBodyRFQ_VENDOR[] rfqVendors = new DT_INFIPA0110_ConBodyRFQ_VENDOR[rVendors.size()];
					for(Map<String, String> rVendor : rVendors) {
						rfqVendors[idx++] = new DT_INFIPA0110_ConBodyRFQ_VENDOR(rVendor.get("COMP_CD"), rVendor.get("RFQ_NO"), rVendor.get("RFQ_CNT"), rVendor.get("VD_CD"), rVendor.get("VD_CHR_PHONE_NO"), rVendor.get("VD_CHR_EMAIL"), rVendor.get("VD_STL_CAUSE"), rVendor.get("QTA_SBMT_DATE"), rVendor.get("QTA_ABD_YN"), rVendor.get("QTA_ABD_CAUSE"));
					}

					idx = 0;
					DT_INFIPA0110_ConBodyQTA_HEADER[] qtaHeaders = new DT_INFIPA0110_ConBodyQTA_HEADER[1];
					for(Map<String, String> qHeader : qHeaders) {
						qtaHeaders[idx++] = new DT_INFIPA0110_ConBodyQTA_HEADER(qHeader.get("COMP_CD"), qHeader.get("VD_CD"), qHeader.get("QTA_NO"), qHeader.get("QTA_CNT"), qHeader.get("RFQ_NO"), qHeader.get("RFQ_CNT"), qHeader.get("QTA_EFF_DATE"), qHeader.get("QTA_AMT"), qHeader.get("CUR"), qHeader.get("PROG_STS"), qHeader.get("REM"), qHeader.get("STL_YN"), qHeader.get("ATT_GRP_NO"));
					}

					idx = 0;
					DT_INFIPA0110_ConBodyQTA_ITEM[] qtaItems = new DT_INFIPA0110_ConBodyQTA_ITEM[qItems.size()];
					for(Map<String, String> qItem : qItems) {
						qtaItems[idx++] = new DT_INFIPA0110_ConBodyQTA_ITEM(qItem.get("COMP_CD"), qItem.get("VD_CD"), qItem.get("QTA_NO"), qItem.get("QTA_CNT"), qItem.get("QTA_LNO"), qItem.get("RFQ_NO"), qItem.get("RFQ_CNT"), qItem.get("RFQ_LNO"), qItem.get("ITEM_CD"), qItem.get("ITEM_NM"), qItem.get("SPEC"), qItem.get("UNIT_CD"), qItem.get("ITEM_QTY"), qItem.get("ITEM_PRICE"), qItem.get("ITEM_AMT"), qItem.get("STL_QTY"), qItem.get("STL_YN"), qItem.get("REM"), qItem.get("PR_NO"), qItem.get("PR_LNO"), qItem.get("LEAD_TIME"));
					}

					idx = 0;
					DT_INFIPA0110_ConBodyQTA_REF_VENDOR[] qtaRefs = null;
					if (qRefs.size() > 0) {
						qtaRefs = new DT_INFIPA0110_ConBodyQTA_REF_VENDOR[qRefs.size()];
						for(Map<String, String> qRef : qRefs) {
							qtaRefs[idx++] = new DT_INFIPA0110_ConBodyQTA_REF_VENDOR(qRef.get("COMP_CD"), qRef.get("VD_CD"), qRef.get("QTA_NO"), qRef.get("QTA_CNT"), qRef.get("QTA_LNO"), qRef.get("REF_BIZ_NO"), qRef.get("REF_VD_NM"), qRef.get("REF_ITEM_QTY"), qRef.get("REF_ITEM_PRICE_F"), qRef.get("REF_ITEM_PRICE"), qRef.get("REF_REM"));
						}	
					}

					DT_INFIPA0110_ConBody body = new DT_INFIPA0110_ConBody();
					body.setRFQ_HEADER(rfqHeaders);
					body.setRFQ_ITEM(rfqItems);
					body.setRFQ_VENDOR(rfqVendors);
					body.setQTA_HEADER(qtaHeaders);
					body.setQTA_ITEM(qtaItems);
					body.setQTA_REF_VENDOR(qtaRefs);
					body.setRFQ_ATTACH(null);
					String callUrl = "";
					DT_ReqHeader header = new DT_ReqHeader();
					header.setZConSysId("K2P_KBB");
					header.setZInterfaceId("INFIPA0110");
					header.setZPiUser("INF_IPA");
					header.setZProSysId("INF_IPA");
					header.setZTimeId(DateTimeUtil.getFormatString("yyyyMMddHHmmssSSS"));
					header.setZUserId("koreab2b");
					callUrl = CommonProperty.getKSI_INFIPA0110_url();	
					
					DT_INFIPA0110_Con con = new DT_INFIPA0110_Con(header, body);
					log.info("KSI_INFIPA0110_url : " + callUrl);
					SI_INFIPA0110_SOProxy proxy = new SI_INFIPA0110_SOProxy(callUrl);
					log.info("KSI_INFIPA0110_proxy : " + proxy);
					DT_INFIPA0110_Con_response _res = proxy.SI_INFIPA0110_SO(con);
					DT_ResHeader _resHeader = _res.getHeader();
					
					returnMsg	= _resHeader.getZResultMsg();

					paramMap	= new HashMap<String, String>();
					if ("S".equals(_resHeader.getZResultCd())) {
						paramMap.put("NEXT_ST", "Y");
					} else {
						paramMap.put("NEXT_ST", "E");
					}
					
					log.info(_resHeader.getZResultMsg());
					
					paramMap.put("PREV_ST", 		"T");
					paramMap.put("IF_MSG", 			returnMsg);
					paramMap.put("BUYER", 			tMap.get("BUYER"));
					paramMap.put("QUOTATION_NO", 	tMap.get("QUOTATION_NO"));
					paramMap.put("REVISION", 		tMap.get("REVISION"));
					paramMap.put("REF_NO", 			tMap.get("REF_NO"));
					
					dao.updateResultIpaIF_KOLON_RFQ_HEADER(paramMap);
				} catch (Exception e) {
					e.printStackTrace();
					log.error(CommonUtil.printStackTraceToString(e));
					
					paramMap	= new HashMap<String, String>();
					paramMap.put("NEXT_ST", 		"E");
					paramMap.put("PREV_ST", 		"T");
					paramMap.put("IF_MSG", 			returnMsg);
					paramMap.put("BUYER", 			tMap.get("BUYER"));
					paramMap.put("BUYER", 			tMap.get("BUYER"));
					paramMap.put("QUOTATION_NO", 	tMap.get("QUOTATION_NO"));
					paramMap.put("REVISION", 		tMap.get("REVISION"));
					paramMap.put("REF_NO", 			tMap.get("REF_NO"));
					
					dao.updateResultIpaIF_KOLON_RFQ_HEADER(paramMap);
					
					break;
				}
			}
			UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
			Map<String, String> tMap	= new HashMap<String, String>();
			tMap.put("COM_CODE", "KRKOLOG001");
			tMap.put("TASK_GUBUN","RE");
			tMap.put("TASK_ORDER","2");
			if_dao.updateIfStatus(tMap);

			log.info("IPA_RFQ - * 작업이 완료되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			 
			log.error("IPA_RFQ - Error : " + e.getMessage());
		}
	}
}
