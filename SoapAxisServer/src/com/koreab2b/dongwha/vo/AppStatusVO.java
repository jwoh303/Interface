package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class AppStatusVO {
	private String IFKEY;
	private String OBJID;
	private String ORDER;
	private String STYPE;
	private String STATUS;
	private String XMLDATA;
	private String APPR_ID;
	private String APPR_DOC_NO;
	private String TITLE;
	private String RECEIVER;
	public String getIFKEY() {
		return IFKEY;
	}
	public void setIFKEY(String iFKEY) {
		IFKEY = iFKEY;
	}
	public String getOBJID() {
		return OBJID;
	}
	public void setOBJID(String oBJID) {
		OBJID = oBJID;
	}
	public String getORDER() {
		return ORDER;
	}
	public void setORDER(String oRDER) {
		ORDER = oRDER;
	}
	public String getSTYPE() {
		return STYPE;
	}
	public void setSTYPE(String sTYPE) {
		STYPE = sTYPE;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public String getXMLDATA() {
		return XMLDATA;
	}
	public void setXMLDATA(String xMLDATA) {
		XMLDATA = xMLDATA;
	}
	public String getAPPR_ID() {
		return APPR_ID;
	}
	public void setAPPR_ID(String aPPR_ID) {
		APPR_ID = aPPR_ID;
	}
	public String getAPPR_DOC_NO() {
		return APPR_DOC_NO;
	}
	public void setAPPR_DOC_NO(String aPPR_DOC_NO) {
		APPR_DOC_NO = aPPR_DOC_NO;
	}
	public String getTITLE() {
		return TITLE;
	}
	public void setTITLE(String tITLE) {
		TITLE = tITLE;
	}
	public String getRECEIVER() {
		return RECEIVER;
	}
	public void setRECEIVER(String rECEIVER) {
		RECEIVER = rECEIVER;
	}

	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("IFKEY", this.IFKEY));
		xml.append(CommonUtil.makeElement("OBJID", this.OBJID));
		xml.append(CommonUtil.makeElement("ORDER", this.ORDER));
		xml.append(CommonUtil.makeElement("STYPE", this.STYPE));
		xml.append(CommonUtil.makeElement("STATUS", this.STATUS));
		xml.append(CommonUtil.makeElement("XMLDATA", this.XMLDATA));
		xml.append(CommonUtil.makeElement("APPR_ID", this.APPR_ID));
		xml.append(CommonUtil.makeElement("APPR_DOC_NO", this.APPR_DOC_NO));
		xml.append(CommonUtil.makeElement("TITLE", this.TITLE));
		xml.append(CommonUtil.makeElement("RECEIVER", this.RECEIVER));

		xml.append("</arg0>\n");

		return xml.toString();
	}
}
