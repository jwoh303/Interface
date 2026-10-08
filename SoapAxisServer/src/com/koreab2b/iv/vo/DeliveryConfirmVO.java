package com.koreab2b.iv.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class DeliveryConfirmVO {

	private String IF_GB;
	private String DELIVERY_SEQ;
	private String VENDOR_DELIVERY_NO;
	private String VENDOR_INVOICE_NO;
	private String VENDOR_CODE;
	private String VENDOR_NAME;
	private String STATUS;
	private String CONFIRMER_ID;
	private String CONFIRMER_NAME;
	private String CONFIRM_DT;
	private String REJECTER_ID;
	private String REJECTER_NAME;
	private String REJECT_DT;
	private String REJECT_FLAG;
	private String REJECT_REASON;
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
	public String getIF_GB() {
		return IF_GB;
	}
	public void setIF_GB(String iF_GB) {
		IF_GB = iF_GB;
	}
	public String getDELIVERY_SEQ() {
		return DELIVERY_SEQ;
	}
	public void setDELIVERY_SEQ(String dELIVERY_SEQ) {
		DELIVERY_SEQ = dELIVERY_SEQ;
	}
	public String getVENDOR_DELIVERY_NO() {
		return VENDOR_DELIVERY_NO;
	}
	public void setVENDOR_DELIVERY_NO(String vENDOR_DELIVERY_NO) {
		VENDOR_DELIVERY_NO = vENDOR_DELIVERY_NO;
	}
	public String getVENDOR_INVOICE_NO() {
		return VENDOR_INVOICE_NO;
	}
	public void setVENDOR_INVOICE_NO(String vENDOR_INVOICE_NO) {
		VENDOR_INVOICE_NO = vENDOR_INVOICE_NO;
	}
	public String getVENDOR_CODE() {
		return VENDOR_CODE;
	}
	public void setVENDOR_CODE(String vENDOR_CODE) {
		VENDOR_CODE = vENDOR_CODE;
	}
	public String getVENDOR_NAME() {
		return VENDOR_NAME;
	}
	public void setVENDOR_NAME(String vENDOR_NAME) {
		VENDOR_NAME = vENDOR_NAME;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public String getCONFIRMER_ID() {
		return CONFIRMER_ID;
	}
	public void setCONFIRMER_ID(String cONFIRMER_ID) {
		CONFIRMER_ID = cONFIRMER_ID;
	}
	public String getCONFIRMER_NAME() {
		return CONFIRMER_NAME;
	}
	public void setCONFIRMER_NAME(String cONFIRMER_NAME) {
		CONFIRMER_NAME = cONFIRMER_NAME;
	}
	public String getCONFIRM_DT() {
		return CONFIRM_DT;
	}
	public void setCONFIRM_DT(String cONFIRM_DT) {
		CONFIRM_DT = cONFIRM_DT;
	}
	public String getREJECTER_ID() {
		return REJECTER_ID;
	}
	public void setREJECTER_ID(String rEJECTER_ID) {
		REJECTER_ID = rEJECTER_ID;
	}
	public String getREJECTER_NAME() {
		return REJECTER_NAME;
	}
	public void setREJECTER_NAME(String rEJECTER_NAME) {
		REJECTER_NAME = rEJECTER_NAME;
	}
	public String getREJECT_DT() {
		return REJECT_DT;
	}
	public void setREJECT_DT(String rEJECT_DT) {
		REJECT_DT = rEJECT_DT;
	}
	public String getREJECT_FLAG() {
		return REJECT_FLAG;
	}
	public void setREJECT_FLAG(String rEJECT_FLAG) {
		REJECT_FLAG = rEJECT_FLAG;
	}
	public String getREJECT_REASON() {
		return REJECT_REASON;
	}
	public void setREJECT_REASON(String rEJECT_REASON) {
		REJECT_REASON = rEJECT_REASON;
	}

	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("IF_GB", this.IF_GB));
		xml.append(CommonUtil.makeElement("DELIVERY_SEQ", this.DELIVERY_SEQ));
		xml.append(CommonUtil.makeElement("VENDOR_DELIVERY_NO", this.VENDOR_DELIVERY_NO));
		xml.append(CommonUtil.makeElement("VENDOR_INVOICE_NO", this.VENDOR_INVOICE_NO));
		xml.append(CommonUtil.makeElement("VENDOR_CODE", this.VENDOR_CODE));
		xml.append(CommonUtil.makeElement("VENDOR_NAME", this.VENDOR_NAME));
		xml.append(CommonUtil.makeElement("STATUS", this.STATUS));
		xml.append(CommonUtil.makeElement("CONFIRMER_ID", this.CONFIRMER_ID));
		xml.append(CommonUtil.makeElement("CONFIRMER_NAME", this.CONFIRMER_NAME));
		xml.append(CommonUtil.makeElement("CONFIRM_DT", this.CONFIRM_DT));
		xml.append(CommonUtil.makeElement("REJECTER_ID", this.REJECTER_ID));
		xml.append(CommonUtil.makeElement("REJECTER_NAME", this.REJECTER_NAME));
		xml.append(CommonUtil.makeElement("REJECT_DT", this.REJECT_DT));
		xml.append(CommonUtil.makeElement("REJECT_FLAG", this.REJECT_FLAG));
		xml.append(CommonUtil.makeElement("REJECT_REASON", this.REJECT_REASON));
		xml.append("</arg0>\n");

		return xml.toString();
	}	
}
