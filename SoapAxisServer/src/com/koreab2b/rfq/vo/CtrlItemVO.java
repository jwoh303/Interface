package com.koreab2b.rfq.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;

public class CtrlItemVO {
	private String IF_DATE;
	private String IF_TIME;
	private String COMPANY_CODE;
	private String SITE_CODE;
	private String ITEM_CODE;
	private String SP_CODE;
	private String ITEM_NAME;
	private String CATEGORY4_CODE;
	private String COLUMN6;
	private String UNIT_ISO_STD_CODE;
	private String CTR_RSP_PS_EP_ID;
	private String MODEL_NAME;
	private String CTR_END_DATE;
	private String LEAD_TIME;
	private String MIN_SALES_QTY;
	private String PO_UNIT_QTY;
	private String BUYING_PRICE;
	private String ITEM_SPEC;
	private WsHeaderVO wsHeader;
	public String getIF_DATE() {
		return IF_DATE;
	}
	public void setIF_DATE(String iF_DATE) {
		IF_DATE = iF_DATE;
	}
	public String getIF_TIME() {
		return IF_TIME;
	}
	public void setIF_TIME(String iF_TIME) {
		IF_TIME = iF_TIME;
	}
	public String getCOMPANY_CODE() {
		return COMPANY_CODE;
	}
	public void setCOMPANY_CODE(String cOMPANY_CODE) {
		COMPANY_CODE = cOMPANY_CODE;
	}
	public String getSITE_CODE() {
		return SITE_CODE;
	}
	public void setSITE_CODE(String sITE_CODE) {
		SITE_CODE = sITE_CODE;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getSP_CODE() {
		return SP_CODE;
	}
	public void setSP_CODE(String sP_CODE) {
		SP_CODE = sP_CODE;
	}
	public String getITEM_NAME() {
		return ITEM_NAME;
	}
	public void setITEM_NAME(String iTEM_NAME) {
		ITEM_NAME = iTEM_NAME;
	}
	public String getCATEGORY4_CODE() {
		return CATEGORY4_CODE;
	}
	public void setCATEGORY4_CODE(String cATEGORY4_CODE) {
		CATEGORY4_CODE = cATEGORY4_CODE;
	}
	public String getCOLUMN6() {
		return COLUMN6;
	}
	public void setCOLUMN6(String cOLUMN6) {
		COLUMN6 = cOLUMN6;
	}
	public String getUNIT_ISO_STD_CODE() {
		return UNIT_ISO_STD_CODE;
	}
	public void setUNIT_ISO_STD_CODE(String uNIT_ISO_STD_CODE) {
		UNIT_ISO_STD_CODE = uNIT_ISO_STD_CODE;
	}
	public String getCTR_RSP_PS_EP_ID() {
		return CTR_RSP_PS_EP_ID;
	}
	public void setCTR_RSP_PS_EP_ID(String cTR_RSP_PS_EP_ID) {
		CTR_RSP_PS_EP_ID = cTR_RSP_PS_EP_ID;
	}
	public String getMODEL_NAME() {
		return MODEL_NAME;
	}
	public void setMODEL_NAME(String mODEL_NAME) {
		MODEL_NAME = mODEL_NAME;
	}
	public String getCTR_END_DATE() {
		return CTR_END_DATE;
	}
	public void setCTR_END_DATE(String cTR_END_DATE) {
		CTR_END_DATE = cTR_END_DATE;
	}
	public String getLEAD_TIME() {
		return LEAD_TIME;
	}
	public void setLEAD_TIME(String lEAD_TIME) {
		LEAD_TIME = lEAD_TIME;
	}
	public String getMIN_SALES_QTY() {
		return MIN_SALES_QTY;
	}
	public void setMIN_SALES_QTY(String mIN_SALES_QTY) {
		MIN_SALES_QTY = mIN_SALES_QTY;
	}
	public String getPO_UNIT_QTY() {
		return PO_UNIT_QTY;
	}
	public void setPO_UNIT_QTY(String pO_UNIT_QTY) {
		PO_UNIT_QTY = pO_UNIT_QTY;
	}
	public String getBUYING_PRICE() {
		return BUYING_PRICE;
	}
	public void setBUYING_PRICE(String bUYING_PRICE) {
		BUYING_PRICE = bUYING_PRICE;
	}
	public WsHeaderVO getWsHeader() {
		return wsHeader;
	}
	public void setWsHeader(WsHeaderVO wsHeader) {
		this.wsHeader = wsHeader;
	}
	public String getITEM_SPEC() {
		return ITEM_SPEC;
	}
	public void setITEM_SPEC(String iTEM_SPEC) {
		ITEM_SPEC = iTEM_SPEC;
	}
	public String getXml() {			
		StringBuffer xml	= new StringBuffer();
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("IF_DATE", this.IF_DATE));
		xml.append(CommonUtil.makeElement("IF_TIME", this.IF_TIME));
		xml.append(CommonUtil.makeElement("COMPANY_CODE", this.COMPANY_CODE));
		xml.append(CommonUtil.makeElement("SITE_CODE", this.SITE_CODE));
		xml.append(CommonUtil.makeElement("ITEM_CODE", this.ITEM_CODE));
		xml.append(CommonUtil.makeElement("SP_CODE", this.SP_CODE));
		xml.append(CommonUtil.makeElement("ITEM_NAME", this.ITEM_NAME));
		xml.append(CommonUtil.makeElement("CATEGORY4_CODE", this.CATEGORY4_CODE));
		xml.append(CommonUtil.makeElement("COLUMN6", this.COLUMN6));
		xml.append(CommonUtil.makeElement("UNIT_ISO_STD_CODE", this.UNIT_ISO_STD_CODE));
		xml.append(CommonUtil.makeElement("CTR_RSP_PS_EP_ID", this.CTR_RSP_PS_EP_ID));
		xml.append(CommonUtil.makeElement("MODEL_NAME", this.MODEL_NAME));
		xml.append(CommonUtil.makeElement("CTR_END_DATE", this.CTR_END_DATE));
		xml.append(CommonUtil.makeElement("LEAD_TIME", this.LEAD_TIME));
		xml.append(CommonUtil.makeElement("MIN_SALES_QTY", this.MIN_SALES_QTY));
		xml.append(CommonUtil.makeElement("PO_UNIT_QTY", this.PO_UNIT_QTY));
		xml.append(CommonUtil.makeElement("BUYING_PRICE", this.BUYING_PRICE));
		xml.append(CommonUtil.makeElement("ITEM_SPEC", this.ITEM_SPEC));
		xml.append("</arg0>\n");
		return xml.toString();
	}
}