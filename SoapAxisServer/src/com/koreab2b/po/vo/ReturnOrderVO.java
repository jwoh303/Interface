package com.koreab2b.po.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class ReturnOrderVO {
	private String IF_GB;
	private String RM_NO;
	private String PO_NO;
	private String PO_SEQ;
	private String RM_REQ_NO;
	private String GR_NO;
	private String VENDOR_DELIVERY_NO;
	private String VENDOR_INVOICE_NO;
	private String RM_GB;
	private String COMPANY_CODE;
	private String ITEM_CODE;
	private String CIS_CODE;
	private String VENDOR_ITEM_CODE;
	private String RM_HOP_DATE;
	private String RM_REQ_QTY;
	private String RM_REQ_AMOUNT;
	private String RM_REQ_PRICE;
	private String RM_REQ_CURRENCY;
	private String RM_CREATOR_NAME;
	private String RM_CREATOR_TEL;
	private String RM_CREATOR_HP_NO;
	private String RM_CREATOR_EMAIL;
	private String ZIP_NO;
	private String RM_ADDRESS;
	private String RM_DETAIL_ADDRESS;
	private String RM_REASON_GB;
	private String RM_DETAIL_REASON;
	private String RM_REQ_INFO;
	private String RM_REQ_DATE;
	private String RM_REQ_HMS;
	private String PROGRESS_STATUS;
	private String ATTACH_NO;
	private String ATTACH_CNT;
	private String CM_ID_1;
	private String CM_ID_2;
	private String CM_ID_3;
	private String CM_ID_4;
	private String CM_ID_5;
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
	public String getRM_NO() {
		return RM_NO;
	}
	public void setRM_NO(String rM_NO) {
		RM_NO = rM_NO;
	}
	public String getPO_NO() {
		return PO_NO;
	}
	public void setPO_NO(String pO_NO) {
		PO_NO = pO_NO;
	}
	public String getPO_SEQ() {
		return PO_SEQ;
	}
	public void setPO_SEQ(String pO_SEQ) {
		PO_SEQ = pO_SEQ;
	}
	public String getRM_REQ_NO() {
		return RM_REQ_NO;
	}
	public void setRM_REQ_NO(String rM_REQ_NO) {
		RM_REQ_NO = rM_REQ_NO;
	}
	public String getGR_NO() {
		return GR_NO;
	}
	public void setGR_NO(String gR_NO) {
		GR_NO = gR_NO;
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
	public String getRM_GB() {
		return RM_GB;
	}
	public void setRM_GB(String rM_GB) {
		RM_GB = rM_GB;
	}
	public String getCOMPANY_CODE() {
		return COMPANY_CODE;
	}
	public void setCOMPANY_CODE(String cOMPANY_CODE) {
		COMPANY_CODE = cOMPANY_CODE;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getCIS_CODE() {
		return CIS_CODE;
	}
	public void setCIS_CODE(String cIS_CODE) {
		CIS_CODE = cIS_CODE;
	}
	public String getVENDOR_ITEM_CODE() {
		return VENDOR_ITEM_CODE;
	}
	public void setVENDOR_ITEM_CODE(String vENDOR_ITEM_CODE) {
		VENDOR_ITEM_CODE = vENDOR_ITEM_CODE;
	}
	public String getRM_HOP_DATE() {
		return RM_HOP_DATE;
	}
	public void setRM_HOP_DATE(String rM_HOP_DATE) {
		RM_HOP_DATE = rM_HOP_DATE;
	}
	public String getRM_REQ_QTY() {
		return RM_REQ_QTY;
	}
	public void setRM_REQ_QTY(String rM_REQ_QTY) {
		RM_REQ_QTY = rM_REQ_QTY;
	}
	public String getRM_REQ_AMOUNT() {
		return RM_REQ_AMOUNT;
	}
	public void setRM_REQ_AMOUNT(String rM_REQ_AMOUNT) {
		RM_REQ_AMOUNT = rM_REQ_AMOUNT;
	}
	public String getRM_REQ_PRICE() {
		return RM_REQ_PRICE;
	}
	public void setRM_REQ_PRICE(String rM_REQ_PRICE) {
		RM_REQ_PRICE = rM_REQ_PRICE;
	}
	public String getRM_REQ_CURRENCY() {
		return RM_REQ_CURRENCY;
	}
	public void setRM_REQ_CURRENCY(String rM_REQ_CURRENCY) {
		RM_REQ_CURRENCY = rM_REQ_CURRENCY;
	}
	public String getRM_CREATOR_NAME() {
		return RM_CREATOR_NAME;
	}
	public void setRM_CREATOR_NAME(String rM_CREATOR_NAME) {
		RM_CREATOR_NAME = rM_CREATOR_NAME;
	}
	public String getRM_CREATOR_TEL() {
		return RM_CREATOR_TEL;
	}
	public void setRM_CREATOR_TEL(String rM_CREATOR_TEL) {
		RM_CREATOR_TEL = rM_CREATOR_TEL;
	}
	public String getRM_CREATOR_HP_NO() {
		return RM_CREATOR_HP_NO;
	}
	public void setRM_CREATOR_HP_NO(String rM_CREATOR_HP_NO) {
		RM_CREATOR_HP_NO = rM_CREATOR_HP_NO;
	}
	public String getRM_CREATOR_EMAIL() {
		return RM_CREATOR_EMAIL;
	}
	public void setRM_CREATOR_EMAIL(String rM_CREATOR_EMAIL) {
		RM_CREATOR_EMAIL = rM_CREATOR_EMAIL;
	}
	public String getZIP_NO() {
		return ZIP_NO;
	}
	public void setZIP_NO(String zIP_NO) {
		ZIP_NO = zIP_NO;
	}
	public String getRM_ADDRESS() {
		return RM_ADDRESS;
	}
	public void setRM_ADDRESS(String rM_ADDRESS) {
		RM_ADDRESS = rM_ADDRESS;
	}
	public String getRM_DETAIL_ADDRESS() {
		return RM_DETAIL_ADDRESS;
	}
	public void setRM_DETAIL_ADDRESS(String rM_DETAIL_ADDRESS) {
		RM_DETAIL_ADDRESS = rM_DETAIL_ADDRESS;
	}
	public String getRM_REASON_GB() {
		return RM_REASON_GB;
	}
	public void setRM_REASON_GB(String rM_REASON_GB) {
		RM_REASON_GB = rM_REASON_GB;
	}
	public String getRM_DETAIL_REASON() {
		return RM_DETAIL_REASON;
	}
	public void setRM_DETAIL_REASON(String rM_DETAIL_REASON) {
		RM_DETAIL_REASON = rM_DETAIL_REASON;
	}
	public String getRM_REQ_INFO() {
		return RM_REQ_INFO;
	}
	public void setRM_REQ_INFO(String rM_REQ_INFO) {
		RM_REQ_INFO = rM_REQ_INFO;
	}
	public String getRM_REQ_DATE() {
		return RM_REQ_DATE;
	}
	public void setRM_REQ_DATE(String rM_REQ_DATE) {
		RM_REQ_DATE = rM_REQ_DATE;
	}
	public String getRM_REQ_HMS() {
		return RM_REQ_HMS;
	}
	public void setRM_REQ_HMS(String rM_REQ_HMS) {
		RM_REQ_HMS = rM_REQ_HMS;
	}
	public String getPROGRESS_STATUS() {
		return PROGRESS_STATUS;
	}
	public void setPROGRESS_STATUS(String pROGRESS_STATUS) {
		PROGRESS_STATUS = pROGRESS_STATUS;
	}
	public String getATTACH_NO() {
		return ATTACH_NO;
	}
	public void setATTACH_NO(String aTTACH_NO) {
		ATTACH_NO = aTTACH_NO;
	}
	public String getATTACH_CNT() {
		return ATTACH_CNT;
	}
	public void setATTACH_CNT(String aTTACH_CNT) {
		ATTACH_CNT = aTTACH_CNT;
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

	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("COMPANY_CODE", this.COMPANY_CODE));
		xml.append(CommonUtil.makeElement("ITEM_CODE", this.ITEM_CODE));
		xml.append(CommonUtil.makeElement("CIS_CODE", this.CIS_CODE));
		xml.append(CommonUtil.makeElement("VENDOR_ITEM_CODE", this.VENDOR_ITEM_CODE));
		xml.append(CommonUtil.makeElement("RM_HOP_DATE", this.RM_HOP_DATE));
		xml.append(CommonUtil.makeElement("RM_REQ_QTY", this.RM_REQ_QTY));
		xml.append(CommonUtil.makeElement("RM_REQ_AMOUNT", this.RM_REQ_AMOUNT));
		xml.append(CommonUtil.makeElement("RM_REQ_PRICE", this.RM_REQ_PRICE));
		xml.append(CommonUtil.makeElement("RM_REQ_CURRENCY", this.RM_REQ_CURRENCY));
		xml.append(CommonUtil.makeElement("RM_CREATOR_NAME", this.RM_CREATOR_NAME));
		xml.append(CommonUtil.makeElement("RM_CREATOR_TEL", this.RM_CREATOR_TEL));
		xml.append(CommonUtil.makeElement("RM_CREATOR_HP_NO", this.RM_CREATOR_HP_NO));
		xml.append(CommonUtil.makeElement("RM_CREATOR_EMAIL", this.RM_CREATOR_EMAIL));
		xml.append(CommonUtil.makeElement("ZIP_NO", this.ZIP_NO));
		xml.append(CommonUtil.makeElement("RM_ADDRESS", this.RM_ADDRESS));
		xml.append(CommonUtil.makeElement("RM_DETAIL_ADDRESS", this.RM_DETAIL_ADDRESS));
		xml.append(CommonUtil.makeElement("RM_REASON_GB", this.RM_REASON_GB));
		xml.append(CommonUtil.makeElement("RM_DETAIL_REASON", this.RM_DETAIL_REASON));
		xml.append(CommonUtil.makeElement("RM_REQ_INFO", this.RM_REQ_INFO));
		xml.append(CommonUtil.makeElement("RM_REQ_DATE", this.RM_REQ_DATE));
		xml.append(CommonUtil.makeElement("RM_REQ_HMS", this.RM_REQ_HMS));
		xml.append(CommonUtil.makeElement("PROGRESS_STATUS", this.PROGRESS_STATUS));
		xml.append(CommonUtil.makeElement("ATTACH_NO", this.ATTACH_NO));
		xml.append(CommonUtil.makeElement("ATTACH_CNT", this.ATTACH_CNT));
		xml.append(CommonUtil.makeElement("CM_ID_1", this.CM_ID_1));
		xml.append(CommonUtil.makeElement("CM_ID_2", this.CM_ID_2));
		xml.append(CommonUtil.makeElement("CM_ID_3", this.CM_ID_3));
		xml.append(CommonUtil.makeElement("CM_ID_4", this.CM_ID_4));
		xml.append(CommonUtil.makeElement("CM_ID_5", this.CM_ID_5));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
