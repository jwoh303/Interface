package com.koreab2b.dongwon.webservice;

import javax.jws.WebParam;
import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.dongwon.service.WsDongwonService;
import com.koreab2b.dongwon.service.WsDongwonServiceImpl;
import com.koreab2b.dongwon.vo.POData;
import com.koreab2b.dongwon.vo.Response;

@WebService(serviceName="WsDongwon")
public class WsDongwonImpl implements WsDongwon {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public Response savePo(
			@WebParam(name="PLANT") String PLANT,
			@WebParam(name="LEGACY_PO_NO") String LEGACY_PO_NO, 
			@WebParam(name="LEGACY_PO_SEQ") String LEGACY_PO_SEQ, 
			@WebParam(name="BUYER_ITEM_NO") String BUYER_ITEM_NO,
			@WebParam(name="DESCRIPTION") String DESCRIPTION, 
			@WebParam(name="SPECIFICATION") String SPECIFICATION, 
			@WebParam(name="UNIT_MEASURE") String UNIT_MEASURE, 
			@WebParam(name="UNIT_PRICE") String UNIT_PRICE, 
			@WebParam(name="ITEM_QTY") String ITEM_QTY,
			@WebParam(name="ITEM_AMT") String ITEM_AMT, 
			@WebParam(name="ADD_DATE") String ADD_DATE, 
			@WebParam(name="RD_DATE") String RD_DATE, 
			@WebParam(name="DELY_TO_LOCATION_TEXT") String DELY_TO_LOCATION_TEXT, 
			@WebParam(name="LEGACY_PR_NO") String LEGACY_PR_NO,
			@WebParam(name="REQ_USER_ID") String REQ_USER_ID, 
			@WebParam(name="REQ_USER_DEPT_NAME") String REQ_USER_DEPT_NAME, 
			@WebParam(name="REQ_USER_NAME") String REQ_USER_NAME,
			@WebParam(name="TAX_EMAIL_ADD") String TAX_EMAIL_ADD,
			@WebParam(name="TAX_EMAIL_NM") String TAX_EMAIL_NM) {
		
		WsDongwonService service	= new WsDongwonServiceImpl();
		Response rtn	= new Response();
		POData iMap	= new POData();
		try {
			iMap.setPLANT(PLANT);
			iMap.setLEGACY_PO_NO(LEGACY_PO_NO);
			iMap.setLEGACY_PO_SEQ(LEGACY_PO_SEQ);
			iMap.setBUYER_ITEM_NO(BUYER_ITEM_NO);
			iMap.setDESCRIPTION(DESCRIPTION);
			iMap.setSPECIFICATION(SPECIFICATION);
			iMap.setUNIT_MEASURE(UNIT_MEASURE);
			iMap.setUNIT_PRICE(UNIT_PRICE);
			iMap.setITEM_QTY(ITEM_QTY);
			iMap.setITEM_AMT(ITEM_AMT);
			iMap.setADD_DATE(ADD_DATE);
			iMap.setRD_DATE(RD_DATE);
			iMap.setDELY_TO_LOCATION_TEXT(DELY_TO_LOCATION_TEXT);
			iMap.setLEGACY_PR_NO(LEGACY_PR_NO);
			iMap.setREQ_USER_ID(REQ_USER_ID);
			iMap.setREQ_USER_DEPT_NAME(REQ_USER_DEPT_NAME);
			iMap.setREQ_USER_NAME(REQ_USER_NAME);
			iMap.setTAX_EMAIL_ADD(TAX_EMAIL_ADD);
			iMap.setTAX_EMAIL_NM(TAX_EMAIL_NM);
			
			rtn = service.savePO(iMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new Response();
			rtn.setTYPE("F");
			rtn.setMESSAGE(CommonUtil.printStackTraceToString(e));
		} finally {
			log.info("Dongwon setPo : " + rtn);
			try {service.saveLog(iMap, rtn);} catch (Exception e2) {}
		}
		return rtn;
	}
}
