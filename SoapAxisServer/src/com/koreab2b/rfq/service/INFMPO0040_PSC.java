package com.koreab2b.rfq.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.rfq.dao.INFMPO0040_Dao;
import com.koreab2b.rfq.dao.INFMPO0040_DaoImpl;
import com.koreab2b.rfq.vo.RFQ_HEADER;

public class INFMPO0040_PSC implements INFMPO0040_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO updateRFQ_HEADER(RFQ_HEADER obj) throws Exception {
		INFMPO0040_Dao dao	= new INFMPO0040_DaoImpl();
		WsPrimitiveVO rtn	= new WsPrimitiveVO();
		WsHeaderVO wsHeader	= null;
		int rtnValue		= 0;
		String CANCEL_TYP	= "";
		String CANCEL_CAUSE	= "";
		List<Map<String,String>> reQtList	= null;
		
		Map<String,String> pMap	= new HashMap<String,String>();
		Map<String,String> iMap	= new HashMap<String,String>();
		
		try {
			dao.getSqlMapClient().startTransaction();
			
			System.out.println("COMP_CD      : " + obj.getCOMP_CD());
			System.out.println("RFQ_NO       : " + obj.getRFQ_NO());
			System.out.println("RFQ_CNT      : " + obj.getRFQ_CNT());
			System.out.println("CANCEL_CAUSE : " + obj.getCANCEL_CAUSE());
			System.out.println("CANCEL_TYP   : " + obj.getCANCEL_TYP());	// C:유찰,R:재견적0
			

			iMap.put("QUOTATION_NO", obj.getRFQ_NO());					//QUOTATION_NO
			iMap.put("REVISION", Integer.toString(obj.getRFQ_CNT()));	//REVISION
			
			reQtList = dao.selectBuyer(iMap);

			pMap.put("BUYER",			reQtList.get(0).get("BUYER"));			//BUYER
			pMap.put("QUOTATION_NO",	reQtList.get(0).get("QUOTATION_NO"));	//QUOTATION_NO
			pMap.put("REVISION",		Integer.toString(obj.getRFQ_CNT()));	//REVISION
			pMap.put("REF_NO",			obj.getRFQ_NO());						//REF_NO
			
			CANCEL_TYP = obj.getCANCEL_TYP();
			
			if("R".equals(CANCEL_TYP)) {
				// 재견적
				CANCEL_CAUSE	= "재견적 : " + obj.getCANCEL_CAUSE();
				dao.insertRfqNegoRQDT(pMap);
				dao.insertRfqNegoQTDT(pMap);
			} else {
				CANCEL_CAUSE	= "유찰 : " + obj.getCANCEL_CAUSE();
			}
			
			pMap.put("CANCEL_REMARK", CANCEL_CAUSE);					//CANCEL_REMARK

			dao.updateRfqCancel(pMap);
			dao.updateQTDTClose(pMap);
			
			dao.getSqlMapClient().commitTransaction();
			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.OK);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.ERROR);
			rtn.setReturnString(e.getMessage());
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
				log.error(e2.getMessage());
			}
		}
		
		rtn.setWsHeader(wsHeader);
		
		return rtn;	
	}
}
