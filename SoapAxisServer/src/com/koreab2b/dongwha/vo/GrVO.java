package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class GrVO {
	
	private String MBLNR;
	private String ZEILE;
	private String MJAHR;
	private String LEGACY_PO_NO;
	private String LEGACY_PO_SEQ;
	private String GR_QTY;
	private String GR_DATE;
	private String SMBLN;
	private String SMBLP;
	private String SJAHR;
	
	private String RESULT_FLAG;
	private String RESULT_MSG;
	
	public String getMBLNR() {
		return MBLNR;
	}
	public void setMBLNR(String mBLNR) {
		MBLNR = mBLNR;
	}
	public String getZEILE() {
		return ZEILE;
	}
	public void setZEILE(String zEILE) {
		ZEILE = zEILE;
	}
	public String getMJAHR() {
		return MJAHR;
	}
	public void setMJAHR(String mJAHR) {
		MJAHR = mJAHR;
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
	public String getGR_QTY() {
		return GR_QTY;
	}
	public void setGR_QTY(String gR_QTY) {
		GR_QTY = gR_QTY;
	}
	public String getGR_DATE() {
		return GR_DATE;
	}
	public void setGR_DATE(String gR_DATE) {
		GR_DATE = gR_DATE;
	}
	public String getSMBLN() {
		return SMBLN;
	}
	public void setSMBLN(String sMBLN) {
		SMBLN = sMBLN;
	}
	public String getSMBLP() {
		return SMBLP;
	}
	public void setSMBLP(String sMBLP) {
		SMBLP = sMBLP;
	}
	public String getSJAHR() {
		return SJAHR;
	}
	public void setSJAHR(String sJAHR) {
		SJAHR = sJAHR;
	}
	public String getRESULT_FLAG() {
		return RESULT_FLAG;
	}
	public void setRESULT_FLAG(String rESULT_FLAG) {
		RESULT_FLAG = rESULT_FLAG;
	}
	public String getRESULT_MSG() {
		return RESULT_MSG;
	}

	public void setRESULT_MSG(String rESULT_MSG) {
		RESULT_MSG = rESULT_MSG;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		
		xml.append(CommonUtil.makeElement("MBLNR", this.MBLNR));
		xml.append(CommonUtil.makeElement("ZEILE", this.ZEILE));
		xml.append(CommonUtil.makeElement("MJAHR", this.MJAHR));
		xml.append(CommonUtil.makeElement("LEGACY_PO_NO", this.LEGACY_PO_NO));
		xml.append(CommonUtil.makeElement("LEGACY_PO_SEQ", this.LEGACY_PO_SEQ));
		xml.append(CommonUtil.makeElement("GR_QTY", this.GR_QTY));
		xml.append(CommonUtil.makeElement("GR_DATE", this.GR_DATE));
		xml.append(CommonUtil.makeElement("SMBLN", this.SMBLN));
		xml.append(CommonUtil.makeElement("SMBLP", this.SMBLP));
		xml.append(CommonUtil.makeElement("SJAHR", this.SJAHR));


		xml.append("</arg0>\n");

		return xml.toString();
	}
}
