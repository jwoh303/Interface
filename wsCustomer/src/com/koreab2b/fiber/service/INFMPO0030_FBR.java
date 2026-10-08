package com.koreab2b.fiber.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.esp.infmpo.fiber.DT_INFMPO0030_Con;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBody;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM;
import com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR;
import com.esp.infmpo.fiber.DT_INFMPO0030_Con_response;
import com.esp.infmpo.fiber.DT_ReqHeader;
import com.esp.infmpo.fiber.DT_ResHeader;
import com.esp.infmpo.fiber.SI_INFMPO0030_SOProxy;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.UpdateIfStatus_Dao;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;
import com.koreab2b.fiber.dao.INFMPO0030_FBR_Dao;
import com.koreab2b.sapInterface.util.DateTimeUtil;

public class INFMPO0030_FBR {
	private Logger log = Logger.getLogger(this.getClass());

	public void execute() throws Exception {
		
		INFMPO0030_FBR_Dao dao = new INFMPO0030_FBR_Dao();
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
			
			dao.updateIF_RfqTarget_FBR();
			List<Map<String,String>> pMaps	= dao.selectSendList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( pMaps.size() ));
			
			if (pMaps.size() > 0) {
				for (Map<String, String> iMap : pMaps) {
					List<Map<String,String>> rHeaders = dao.selectRfqHeaderList(iMap);
					List<Map<String,String>> rItems = dao.selectRfqItemList(iMap);
					List<Map<String,String>> rVendors = dao.selectRfqVendorList(iMap);
					List<Map<String,String>> qHeaders = dao.selectQtaHeaderList(iMap);
					List<Map<String,String>> qItems = dao.selectQtaItemList(iMap);
					List<Map<String,String>> qRefs = dao.selectQtaRefVendorList(iMap);
					
					idx = 0;
					DT_INFMPO0030_ConBodyRFQ_HEADER[] rfqHeaders = new DT_INFMPO0030_ConBodyRFQ_HEADER[1];
					for(Map<String, String> rHeader : rHeaders) {
						rfqHeaders[idx++] = new DT_INFMPO0030_ConBodyRFQ_HEADER(rHeader.get("BIZ_CLS"), rHeader.get("COMP_CD"), rHeader.get("RFQ_NO"), rHeader.get("RFQ_CNT"), rHeader.get("RFQ_TIT"), rHeader.get("RFQ_REQ_TYP"), rHeader.get("RFX_TYP"), rHeader.get("BID_TYP"), rHeader.get("CPT_TYPE_CD"), rHeader.get("VD_STL_TYP"), rHeader.get("PRC_STL_TYP"), rHeader.get("RFQ_DATE"), rHeader.get("RFQ_START_DT"), rHeader.get("RFQ_CLOSE_DT"), rHeader.get("RFQ_MOD_CLOSE_DT"), rHeader.get("PURC_GRP_CD"), rHeader.get("RFQ_CUR"), rHeader.get("SHIPPER_TYPE"), rHeader.get("PURC_TYP"), rHeader.get("RFQ_PROG_STS"), rHeader.get("RFQ_END_STS"), rHeader.get("DELAY_RATE"));
						break;	
					}
					
					idx = 0;
					DT_INFMPO0030_ConBodyRFQ_ITEM[] rfqItems = new DT_INFMPO0030_ConBodyRFQ_ITEM[rItems.size()];
					for(Map<String, String> rItem : rItems) {
						rfqItems[idx++] = new DT_INFMPO0030_ConBodyRFQ_ITEM(rItem.get("COMP_CD"), rItem.get("RFQ_NO"), rItem.get("RFQ_CNT"), rItem.get("RFQ_LNO"), rItem.get("PURC_TYP"), rItem.get("PLT_CD"), rItem.get("ITEM_CD"), rItem.get("ITEM_NM"), rItem.get("CHEM_MATL_YN"), rItem.get("SPEC"), rItem.get("UNIT_CD"), rItem.get("ITEM_QTY"), rItem.get("RFQ_PRICE"), rItem.get("TGT_PRICE"), rItem.get("LMT_PRICE"), rItem.get("WH_CD"), rItem.get("RD_DATE"), rItem.get("PRD_SD"), rItem.get("PRD_ED"), rItem.get("STL_YN"), rItem.get("STL_QTY"), rItem.get("PRICE_UNIT"), rItem.get("CUR"), rItem.get("PR_NO"), rItem.get("PR_LNO"), rItem.get("PR_REQ_DATE"), rItem.get("KAMS_PR_NO"), rItem.get("ITEM_CATE"), rItem.get("REG_ID"), rItem.get("WBS"), rItem.get("WBS_DESC"), rItem.get("ZZAFNAM"));
					}					

					idx = 0;
					DT_INFMPO0030_ConBodyRFQ_VENDOR[] rfqVendors = new DT_INFMPO0030_ConBodyRFQ_VENDOR[rVendors.size()];
					for(Map<String, String> rVendor : rVendors) {
						rfqVendors[idx++] = new DT_INFMPO0030_ConBodyRFQ_VENDOR(rVendor.get("COMP_CD"), rVendor.get("RFQ_NO"), rVendor.get("RFQ_CNT"), rVendor.get("VD_CD"), rVendor.get("VD_CHR_PHONE_NO"), rVendor.get("VD_CHR_EMAIL"), rVendor.get("VD_STL_CAUSE"), rVendor.get("QTA_SBMT_DATE"), rVendor.get("QTA_ABD_YN"), rVendor.get("QTA_ABD_CAUSE"));
					}

					idx = 0;
					DT_INFMPO0030_ConBodyQTA_HEADER[] qtaHeaders = new DT_INFMPO0030_ConBodyQTA_HEADER[1];
					for(Map<String, String> qHeader : qHeaders) {
						qtaHeaders[idx++] = new DT_INFMPO0030_ConBodyQTA_HEADER(qHeader.get("COMP_CD"), qHeader.get("VD_CD"), qHeader.get("QTA_NO"), qHeader.get("QTA_CNT"), qHeader.get("RFQ_NO"), qHeader.get("RFQ_CNT"), qHeader.get("QTA_EFF_DATE"), qHeader.get("QTA_AMT"), qHeader.get("CUR"), qHeader.get("PROG_STS"), qHeader.get("REM"), qHeader.get("STL_YN"), qHeader.get("ATT_GRP_NO"));
					}

					idx = 0;
					DT_INFMPO0030_ConBodyQTA_ITEM[] qtaItems = new DT_INFMPO0030_ConBodyQTA_ITEM[qItems.size()];
					for(Map<String, String> qItem : qItems) {
						qtaItems[idx++] = new DT_INFMPO0030_ConBodyQTA_ITEM(qItem.get("COMP_CD"), qItem.get("VD_CD"), qItem.get("QTA_NO"), qItem.get("QTA_CNT"), qItem.get("QTA_LNO"), qItem.get("RFQ_NO"), qItem.get("RFQ_CNT"), qItem.get("RFQ_LNO"), qItem.get("ITEM_CD"), qItem.get("ITEM_NM"), qItem.get("SPEC"), qItem.get("UNIT_CD"), qItem.get("ITEM_QTY"), qItem.get("ITEM_PRICE"), qItem.get("ITEM_AMT"), qItem.get("STL_QTY"), qItem.get("STL_YN"), qItem.get("REM"), qItem.get("PR_NO"), qItem.get("PR_LNO"));
					}

					idx = 0;
					DT_INFMPO0030_ConBodyQTA_REF_VENDOR[] qtaRefs = null;
					if (qRefs.size() > 0) {
						qtaRefs = new DT_INFMPO0030_ConBodyQTA_REF_VENDOR[qRefs.size()];
						for(Map<String, String> qRef : qRefs) {
							qtaRefs[idx++] = new DT_INFMPO0030_ConBodyQTA_REF_VENDOR(qRef.get("COMP_CD"), qRef.get("VD_CD"), qRef.get("QTA_NO"), qRef.get("QTA_CNT"), qRef.get("QTA_LNO"), qRef.get("REF_BIZ_NO"), qRef.get("REF_VD_NM"), qRef.get("REF_ITEM_QTY"), qRef.get("REF_ITEM_PRICE_F"), qRef.get("REF_ITEM_PRICE"), qRef.get("REF_REM"));
						}	
					}

					DT_INFMPO0030_ConBody body = new DT_INFMPO0030_ConBody();
					body.setRFQ_HEADER(rfqHeaders);
					body.setRFQ_ITEM(rfqItems);
					body.setRFQ_VENDOR(rfqVendors);
					body.setQTA_HEADER(qtaHeaders);
					body.setQTA_ITEM(qtaItems);
					body.setQTA_REF_VENDOR(qtaRefs);
					body.setRFQ_ATTACH(null);
					
					DT_ReqHeader header = new DT_ReqHeader();
					header.setZConSysId("K2P_KBB");
					header.setZInterfaceId("INFMPO0030");
					header.setZPiUser("IF_K2PKBB");
					header.setZProSysId("INF_MPO");
					header.setZTimeId(DateTimeUtil.getFormatString("yyyyMMddHHmmssSSS"));
					header.setZUserId("koreab2b");
					
					DT_INFMPO0030_Con con = new DT_INFMPO0030_Con(header, body);
					log.debug("SI_INFMPO0030_url : " + CommonProperty.getSI_INFMPO0030_url());
					SI_INFMPO0030_SOProxy proxy = new SI_INFMPO0030_SOProxy(CommonProperty.getSI_INFMPO0030_url());
					DT_INFMPO0030_Con_response _res = proxy.SI_INFMPO0030_SO(con);
					DT_ResHeader _resHeader = _res.getHeader();
					
					if ("S".equals(_resHeader.getZResultCd())) {
						iMap.put("IF_FLAG", "Y");
					} else {
						iMap.put("IF_FLAG", "E");
					}
					dao.updateIF_RfqResult_FBR(iMap);
				}
			}
		} catch (Exception e) {
			log.error("INFMPO0030_FBR Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}