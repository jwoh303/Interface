package com.koreab2b.dongwon.vo;

import com.koreab2b.common.CommonUtil;

public class POData {
	
	private String PLANT;
	private String LEGACY_PO_NO;
	private String LEGACY_PO_SEQ;
	private String BUYER_ITEM_NO;
	private String DESCRIPTION;
	private String SPECIFICATION;
	private String UNIT_MEASURE;
	private String UNIT_PRICE;
	private String ITEM_QTY;
	private String ITEM_AMT;
	private String ADD_DATE;
	private String RD_DATE;
	private String DELY_TO_LOCATION_TEXT;
	private String LEGACY_PR_NO;
	private String REQ_USER_ID;
	private String REQ_USER_DEPT_NAME;
	private String REQ_USER_NAME;
	private String TAX_EMAIL_ADD;
	private String TAX_EMAIL_NM;
	
	public String getPLANT() {
		return PLANT;
	}
	public void setPLANT(String pLANT) {
		PLANT = pLANT;
	}
	public String getLEGACY_PO_NO() {
		return LEGACY_PO_NO;
	}
	public void setLEGACY_PO_NO(String lEGACY_PO_NO) {
		LEGACY_PO_NO = lEGACY_PO_NO;
	}
	public String getLEGACY_PO_SEQ() {
		return LEGACY_PO_SEQ;
	}
	public void setLEGACY_PO_SEQ(String lEGACY_PO_SEQ) {
		LEGACY_PO_SEQ = lEGACY_PO_SEQ;
	}
	public String getBUYER_ITEM_NO() {
		return BUYER_ITEM_NO;
	}
	public void setBUYER_ITEM_NO(String bUYER_ITEM_NO) {
		BUYER_ITEM_NO = bUYER_ITEM_NO;
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
	public String getUNIT_MEASURE() {
		return UNIT_MEASURE;
	}
	public void setUNIT_MEASURE(String uNIT_MEASURE) {
		UNIT_MEASURE = uNIT_MEASURE;
	}
	public String getUNIT_PRICE() {
		return UNIT_PRICE;
	}
	public void setUNIT_PRICE(String uNIT_PRICE) {
		UNIT_PRICE = uNIT_PRICE;
	}
	public String getITEM_QTY() {
		return ITEM_QTY;
	}
	public void setITEM_QTY(String iTEM_QTY) {
		ITEM_QTY = iTEM_QTY;
	}
	public String getITEM_AMT() {
		return ITEM_AMT;
	}
	public void setITEM_AMT(String iTEM_AMT) {
		ITEM_AMT = iTEM_AMT;
	}
	public String getADD_DATE() {
		return ADD_DATE;
	}
	public void setADD_DATE(String aDD_DATE) {
		ADD_DATE = aDD_DATE;
	}
	public String getRD_DATE() {
		return RD_DATE;
	}
	public void setRD_DATE(String rD_DATE) {
		RD_DATE = rD_DATE;
	}
	public String getDELY_TO_LOCATION_TEXT() {
		return DELY_TO_LOCATION_TEXT;
	}
	public void setDELY_TO_LOCATION_TEXT(String dELY_TO_LOCATION_TEXT) {
		DELY_TO_LOCATION_TEXT = dELY_TO_LOCATION_TEXT;
	}
	public String getLEGACY_PR_NO() {
		return LEGACY_PR_NO;
	}
	public void setLEGACY_PR_NO(String lEGACY_PR_NO) {
		LEGACY_PR_NO = lEGACY_PR_NO;
	}
	public String getREQ_USER_ID() {
		return REQ_USER_ID;
	}
	public void setREQ_USER_ID(String rEQ_USER_ID) {
		REQ_USER_ID = rEQ_USER_ID;
	}
	public String getREQ_USER_DEPT_NAME() {
		return REQ_USER_DEPT_NAME;
	}
	public void setREQ_USER_DEPT_NAME(String rEQ_USER_DEPT_NAME) {
		REQ_USER_DEPT_NAME = rEQ_USER_DEPT_NAME;
	}
	public String getREQ_USER_NAME() {
		return REQ_USER_NAME;
	}
	public void setREQ_USER_NAME(String rEQ_USER_NAME) {
		REQ_USER_NAME = rEQ_USER_NAME;
	}
	public String getTAX_EMAIL_ADD() {
		return TAX_EMAIL_ADD;
	}
	public void setTAX_EMAIL_ADD(String tAX_EMAIL_ADD) {
		TAX_EMAIL_ADD = tAX_EMAIL_ADD;
	}
	public String getTAX_EMAIL_NM() {
		return TAX_EMAIL_NM;
	}
	public void setTAX_EMAIL_NM(String tAX_EMAIL_NM) {
		TAX_EMAIL_NM = tAX_EMAIL_NM;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append(CommonUtil.makeElement("PLANT", this.PLANT));
		xml.append(CommonUtil.makeElement("LEGACY_PO_NO", this.LEGACY_PO_NO));
		xml.append(CommonUtil.makeElement("LEGACY_PO_SEQ", this.LEGACY_PO_SEQ));
		xml.append(CommonUtil.makeElement("BUYER_ITEM_NO", this.BUYER_ITEM_NO));
		xml.append(CommonUtil.makeElement("DESCRIPTION", this.DESCRIPTION));
		xml.append(CommonUtil.makeElement("SPECIFICATION", this.SPECIFICATION));
		xml.append(CommonUtil.makeElement("UNIT_MEASURE", this.UNIT_MEASURE));
		xml.append(CommonUtil.makeElement("UNIT_PRICE", this.UNIT_PRICE));
		xml.append(CommonUtil.makeElement("ITEM_QTY", this.ITEM_QTY));
		xml.append(CommonUtil.makeElement("ITEM_AMT", this.ITEM_AMT));
		xml.append(CommonUtil.makeElement("ADD_DATE", this.ADD_DATE));
		xml.append(CommonUtil.makeElement("RD_DATE", this.RD_DATE));
		xml.append(CommonUtil.makeElement("DELY_TO_LOCATION_TEXT", this.DELY_TO_LOCATION_TEXT));
		xml.append(CommonUtil.makeElement("LEGACY_PR_NO", this.LEGACY_PR_NO));
		xml.append(CommonUtil.makeElement("REQ_USER_ID", this.REQ_USER_ID));
		xml.append(CommonUtil.makeElement("REQ_USER_DEPT_NAME", this.REQ_USER_DEPT_NAME));
		xml.append(CommonUtil.makeElement("REQ_USER_NAME", this.REQ_USER_NAME));
		xml.append(CommonUtil.makeElement("TAX_EMAIL_ADD", this.TAX_EMAIL_ADD));
		xml.append(CommonUtil.makeElement("TAX_EMAIL_NM", this.TAX_EMAIL_NM));
		
		return xml.toString();
	}
}
