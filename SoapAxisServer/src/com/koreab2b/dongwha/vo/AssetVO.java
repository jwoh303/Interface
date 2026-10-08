package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class AssetVO {
	private String BUKRS;
	private String ANLN1;
	private String ANLN2;
	private String TXT50;
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getANLN1() {
		return ANLN1;
	}
	public void setANLN1(String aNLN1) {
		ANLN1 = aNLN1;
	}
	public String getANLN2() {
		return ANLN2;
	}
	public void setANLN2(String aNLN2) {
		ANLN2 = aNLN2;
	}
	public String getTXT50() {
		return TXT50;
	}
	public void setTXT50(String tXT50) {
		TXT50 = tXT50;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		
		xml.append(CommonUtil.makeElement("BUKRS", this.BUKRS));
		xml.append(CommonUtil.makeElement("ANLN1", this.ANLN1));
		xml.append(CommonUtil.makeElement("ANLN2", this.ANLN2));
		xml.append(CommonUtil.makeElement("TXT50", this.TXT50));

		xml.append("</arg0>\n");

		return xml.toString();
	}
}
