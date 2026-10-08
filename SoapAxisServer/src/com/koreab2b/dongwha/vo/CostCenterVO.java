package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class CostCenterVO {
	private String KOSTL;
	private String DATBI;
	private String LTEXT;
	private String DATAB;
	private String BUKRS;
	public String getKOSTL() {
		return KOSTL;
	}
	public void setKOSTL(String kOSTL) {
		KOSTL = kOSTL;
	}
	public String getDATBI() {
		return DATBI;
	}
	public void setDATBI(String dATBI) {
		DATBI = dATBI;
	}
	public String getLTEXT() {
		return LTEXT;
	}
	public void setLTEXT(String lTEXT) {
		LTEXT = lTEXT;
	}
	public String getDATAB() {
		return DATAB;
	}
	public void setDATAB(String dATAB) {
		DATAB = dATAB;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		
		xml.append(CommonUtil.makeElement("KOSTL", this.KOSTL));
		xml.append(CommonUtil.makeElement("DATBI", this.DATBI));
		xml.append(CommonUtil.makeElement("LTEXT", this.LTEXT));
		xml.append(CommonUtil.makeElement("DATAB", this.DATAB));
		xml.append(CommonUtil.makeElement("BUKRS", this.BUKRS));

		xml.append("</arg0>\n");

		return xml.toString();
	}
}
