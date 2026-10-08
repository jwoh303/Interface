package com.koreab2b.rfq.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class ItemRequestVO {
	private String REQ_NO;
	private String PROCESS_TYPE;
	private String CATEGORY_ID;
	private String DESCRIPTION;
	private String SPECIFICATION;
	private String MANUFACTURER;
	private String MODEL_NO;
	private String BUYING_CURRENCY;
	private String DESIRED_UNIT_PRICE;
	private String DESIRED_ORDER_DT;
	private String DESIRED_ORDER_QTY;
	private String DESIRED_YEAR_QTY;
	private String UNIT_CODE;
	private String ITEM_CODE;
	private String COMPANY_CODE;
	private String INCOTERMS;
	private String REQ_EMP;
	private String REQ_TEL;
	private String REQ_MAIL;
	private String REQ_DESTINATION;
	private String REQ_COMMENTS;
	private String TARGET_DT;
	private String QUOT_PURPOSE;
	private String QUOT_PURPOSE_TXT;
	private String CM_ID_1;
	private String CM_ID_2;
	private String CM_ID_3;
	private String CM_ID_4;
	private String CM_ID_5;
	private String CM_ID_6;
	private String CM_ID_7;
	private String CM_ID_8;
	private String CM_ID_9;
	private String CM_ID_10;
	private WsHeaderVO wsHeader;
	
	public WsHeaderVO getWsHeader() {
		if(wsHeader == null) {
			return new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		return wsHeader;
	}
	public void setWsHeader(WsHeaderVO wsHeader) {
		if(wsHeader == null) {
			this.wsHeader = new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		this.wsHeader = wsHeader;
	}
	public String getREQ_NO() {
		return REQ_NO;
	}
	public void setREQ_NO(String rEQ_NO) {
		REQ_NO = rEQ_NO;
	}
	public String getPROCESS_TYPE() {
		return PROCESS_TYPE;
	}
	public void setPROCESS_TYPE(String pROCESS_TYPE) {
		PROCESS_TYPE = pROCESS_TYPE;
	}
	public String getCATEGORY_ID() {
		return CATEGORY_ID;
	}
	public void setCATEGORY_ID(String cATEGORY_ID) {
		CATEGORY_ID = cATEGORY_ID;
	}
	public String getDESCRIPTION() {
		return DESCRIPTION;
	}
	public void setDESCRIPTION(String dESCRIPTION) {
		DESCRIPTION = dESCRIPTION;
	}
	public String getSPECIFICATION() {
		return SPECIFICATION;
	}
	public void setSPECIFICATION(String sPECIFICATION) {
		SPECIFICATION = sPECIFICATION;
	}
	public String getMANUFACTURER() {
		return MANUFACTURER;
	}
	public void setMANUFACTURER(String mANUFACTURER) {
		MANUFACTURER = mANUFACTURER;
	}
	public String getMODEL_NO() {
		return MODEL_NO;
	}
	public void setMODEL_NO(String mODEL_NO) {
		MODEL_NO = mODEL_NO;
	}
	public String getBUYING_CURRENCY() {
		return BUYING_CURRENCY;
	}
	public void setBUYING_CURRENCY(String bUYING_CURRENCY) {
		BUYING_CURRENCY = bUYING_CURRENCY;
	}
	public String getDESIRED_UNIT_PRICE() {
		return DESIRED_UNIT_PRICE;
	}
	public void setDESIRED_UNIT_PRICE(String dESIRED_UNIT_PRICE) {
		DESIRED_UNIT_PRICE = dESIRED_UNIT_PRICE;
	}
	public String getDESIRED_ORDER_DT() {
		return DESIRED_ORDER_DT;
	}
	public void setDESIRED_ORDER_DT(String dESIRED_ORDER_DT) {
		DESIRED_ORDER_DT = dESIRED_ORDER_DT;
	}
	public String getDESIRED_ORDER_QTY() {
		return DESIRED_ORDER_QTY;
	}
	public void setDESIRED_ORDER_QTY(String dESIRED_ORDER_QTY) {
		DESIRED_ORDER_QTY = dESIRED_ORDER_QTY;
	}
	public String getDESIRED_YEAR_QTY() {
		return DESIRED_YEAR_QTY;
	}
	public void setDESIRED_YEAR_QTY(String dESIRED_YEAR_QTY) {
		DESIRED_YEAR_QTY = dESIRED_YEAR_QTY;
	}
	public String getUNIT_CODE() {
		return UNIT_CODE;
	}
	public void setUNIT_CODE(String uNIT_CODE) {
		UNIT_CODE = uNIT_CODE;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getCOMPANY_CODE() {
		return COMPANY_CODE;
	}
	public void setCOMPANY_CODE(String cOMPANY_CODE) {
		COMPANY_CODE = cOMPANY_CODE;
	}
	public String getINCOTERMS() {
		return INCOTERMS;
	}
	public void setINCOTERMS(String iNCOTERMS) {
		INCOTERMS = iNCOTERMS;
	}
	public String getREQ_EMP() {
		return REQ_EMP;
	}
	public void setREQ_EMP(String rEQ_EMP) {
		REQ_EMP = rEQ_EMP;
	}
	public String getREQ_TEL() {
		return REQ_TEL;
	}
	public void setREQ_TEL(String rEQ_TEL) {
		REQ_TEL = rEQ_TEL;
	}
	public String getREQ_MAIL() {
		return REQ_MAIL;
	}
	public void setREQ_MAIL(String rEQ_MAIL) {
		REQ_MAIL = rEQ_MAIL;
	}
	public String getREQ_DESTINATION() {
		return REQ_DESTINATION;
	}
	public void setREQ_DESTINATION(String rEQ_DESTINATION) {
		REQ_DESTINATION = rEQ_DESTINATION;
	}
	public String getREQ_COMMENTS() {
		return REQ_COMMENTS;
	}
	public void setREQ_COMMENTS(String rEQ_COMMENTS) {
		REQ_COMMENTS = rEQ_COMMENTS;
	}
	public String getTARGET_DT() {
		return TARGET_DT;
	}
	public void setTARGET_DT(String tARGET_DT) {
		TARGET_DT = tARGET_DT;
	}
	public String getQUOT_PURPOSE() {
		return QUOT_PURPOSE;
	}
	public void setQUOT_PURPOSE(String qUOT_PURPOSE) {
		QUOT_PURPOSE = qUOT_PURPOSE;
	}
	public String getQUOT_PURPOSE_TXT() {
		return QUOT_PURPOSE_TXT;
	}
	public void setQUOT_PURPOSE_TXT(String qUOT_PURPOSE_TXT) {
		QUOT_PURPOSE_TXT = qUOT_PURPOSE_TXT;
	}
	public String getCM_ID_1() {
		return CM_ID_1;
	}
	public void setCM_ID_1(String cM_ID_1) {
		CM_ID_1 = cM_ID_1;
	}
	public String getCM_ID_2() {
		return CM_ID_2;
	}
	public void setCM_ID_2(String cM_ID_2) {
		CM_ID_2 = cM_ID_2;
	}
	public String getCM_ID_3() {
		return CM_ID_3;
	}
	public void setCM_ID_3(String cM_ID_3) {
		CM_ID_3 = cM_ID_3;
	}
	public String getCM_ID_4() {
		return CM_ID_4;
	}
	public void setCM_ID_4(String cM_ID_4) {
		CM_ID_4 = cM_ID_4;
	}
	public String getCM_ID_5() {
		return CM_ID_5;
	}
	public void setCM_ID_5(String cM_ID_5) {
		CM_ID_5 = cM_ID_5;
	}
	public String getCM_ID_6() {
		return CM_ID_6;
	}
	public void setCM_ID_6(String cM_ID_6) {
		CM_ID_6 = cM_ID_6;
	}
	public String getCM_ID_7() {
		return CM_ID_7;
	}
	public void setCM_ID_7(String cM_ID_7) {
		CM_ID_7 = cM_ID_7;
	}
	public String getCM_ID_8() {
		return CM_ID_8;
	}
	public void setCM_ID_8(String cM_ID_8) {
		CM_ID_8 = cM_ID_8;
	}
	public String getCM_ID_9() {
		return CM_ID_9;
	}
	public void setCM_ID_9(String cM_ID_9) {
		CM_ID_9 = cM_ID_9;
	}
	public String getCM_ID_10() {
		return CM_ID_10;
	}
	public void setCM_ID_10(String cM_ID_10) {
		CM_ID_10 = cM_ID_10;
	}

	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();

		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("REQ_NO", this.REQ_NO));
		xml.append(CommonUtil.makeElement("PROCESS_TYPE", this.PROCESS_TYPE));
		xml.append(CommonUtil.makeElement("CATEGORY_ID", this.CATEGORY_ID));
		xml.append(CommonUtil.makeElement("DESCRIPTION", this.DESCRIPTION));
		xml.append(CommonUtil.makeElement("SPECIFICATION", this.SPECIFICATION));
		xml.append(CommonUtil.makeElement("MANUFACTURER", this.MANUFACTURER));
		xml.append(CommonUtil.makeElement("MODEL_NO", this.MODEL_NO));
		xml.append(CommonUtil.makeElement("BUYING_CURRENCY", this.BUYING_CURRENCY));
		xml.append(CommonUtil.makeElement("DESIRED_UNIT_PRICE", this.DESIRED_UNIT_PRICE));
		xml.append(CommonUtil.makeElement("DESIRED_ORDER_DT", this.DESIRED_ORDER_DT));
		xml.append(CommonUtil.makeElement("DESIRED_ORDER_QTY", this.DESIRED_ORDER_QTY));
		xml.append(CommonUtil.makeElement("DESIRED_YEAR_QTY", this.DESIRED_YEAR_QTY));
		xml.append(CommonUtil.makeElement("UNIT_CODE", this.UNIT_CODE));
		xml.append(CommonUtil.makeElement("ITEM_CODE", this.ITEM_CODE));
		xml.append(CommonUtil.makeElement("COMPANY_CODE", this.COMPANY_CODE));
		xml.append(CommonUtil.makeElement("INCOTERMS", this.INCOTERMS));
		xml.append(CommonUtil.makeElement("REQ_EMP", this.REQ_EMP));
		xml.append(CommonUtil.makeElement("REQ_TEL", this.REQ_TEL));
		xml.append(CommonUtil.makeElement("REQ_MAIL", this.REQ_MAIL));
		xml.append(CommonUtil.makeElement("REQ_DESTINATION", this.REQ_DESTINATION));
		xml.append(CommonUtil.makeElement("REQ_COMMENTS", this.REQ_COMMENTS));
		xml.append(CommonUtil.makeElement("TARGET_DT", this.TARGET_DT));
		xml.append(CommonUtil.makeElement("QUOT_PURPOSE", this.QUOT_PURPOSE));
		xml.append(CommonUtil.makeElement("QUOT_PURPOSE_TXT", this.QUOT_PURPOSE_TXT));
		xml.append(CommonUtil.makeElement("CM_ID_1", this.CM_ID_1));
		xml.append(CommonUtil.makeElement("CM_ID_2", this.CM_ID_2));
		xml.append(CommonUtil.makeElement("CM_ID_3", this.CM_ID_3));
		xml.append(CommonUtil.makeElement("CM_ID_4", this.CM_ID_4));
		xml.append(CommonUtil.makeElement("CM_ID_5", this.CM_ID_5));
		xml.append(CommonUtil.makeElement("CM_ID_6", this.CM_ID_6));
		xml.append(CommonUtil.makeElement("CM_ID_7", this.CM_ID_7));
		xml.append(CommonUtil.makeElement("CM_ID_8", this.CM_ID_8));
		xml.append(CommonUtil.makeElement("CM_ID_9", this.CM_ID_9));
		xml.append(CommonUtil.makeElement("CM_ID_10", this.CM_ID_10));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
