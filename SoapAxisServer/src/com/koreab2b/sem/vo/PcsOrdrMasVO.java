package com.koreab2b.sem.vo;

import com.koreab2b.util.CommonUtil;

public class PcsOrdrMasVO {

	private String loekz;
	private String req_system;
	private String bukrs;
	private String werks;
	private String gsber;
	private String kostl;
	private String ltext;
	private String ebeln;
	private String bedat;
	private String ernam;
	private String ernam_nm;
	private String ernam_tel;
	private String purchaser_name;
	private String purchaser_tel;
	private String origin_code;
	
	public String getLoekz() {
		return loekz;
	}
	public void setLoekz(String loekz) {
		this.loekz = loekz;
	}
	public String getReq_system() {
		return req_system;
	}
	public void setReq_system(String req_system) {
		this.req_system = req_system;
	}
	public String getBukrs() {
		return bukrs;
	}
	public void setBukrs(String bukrs) {
		this.bukrs = bukrs;
	}
	public String getWerks() {
		return werks;
	}
	public void setWerks(String werks) {
		this.werks = werks;
	}
	public String getGsber() {
		return gsber;
	}
	public void setGsber(String gsber) {
		this.gsber = gsber;
	}
	public String getKostl() {
		return kostl;
	}
	public void setKostl(String kostl) {
		this.kostl = kostl;
	}
	public String getLtext() {
		return ltext;
	}
	public void setLtext(String ltext) {
		this.ltext = ltext;
	}
	public String getEbeln() {
		return ebeln;
	}
	public void setEbeln(String ebeln) {
		this.ebeln = ebeln;
	}
	public String getBedat() {
		return bedat;
	}
	public void setBedat(String bedat) {
		this.bedat = bedat;
	}
	public String getErnam() {
		return ernam;
	}
	public void setErnam(String ernam) {
		this.ernam = ernam;
	}
	public String getErnam_nm() {
		return ernam_nm;
	}
	public void setErnam_nm(String ernam_nm) {
		this.ernam_nm = ernam_nm;
	}
	public String getErnam_tel() {
		return ernam_tel;
	}
	public void setErnam_tel(String ernam_tel) {
		this.ernam_tel = ernam_tel;
	}
	public String getPurchaser_name() {
		return purchaser_name;
	}
	public void setPurchaser_name(String purchaser_name) {
		this.purchaser_name = purchaser_name;
	}
	public String getPurchaser_tel() {
		return purchaser_tel;
	}
	public void setPurchaser_tel(String purchaser_tel) {
		this.purchaser_tel = purchaser_tel;
	}
	public String getOrigin_code() {
		return origin_code;
	}
	public void setOrigin_code(String origin_code) {
		this.origin_code = origin_code;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("loekz", this.loekz));
		xml.append(CommonUtil.makeElement("req_system", this.req_system));
		xml.append(CommonUtil.makeElement("bukrs", this.bukrs));
		xml.append(CommonUtil.makeElement("werks", this.werks));
		xml.append(CommonUtil.makeElement("gsber", this.gsber));
		xml.append(CommonUtil.makeElement("kostl", this.kostl));
		xml.append(CommonUtil.makeElement("ltext", this.ltext));
		xml.append(CommonUtil.makeElement("ebeln", this.ebeln));
		xml.append(CommonUtil.makeElement("bedat", this.bedat));
		xml.append(CommonUtil.makeElement("ernam", this.ernam));
		xml.append(CommonUtil.makeElement("ernam_nm", this.ernam_nm));
		xml.append(CommonUtil.makeElement("ernam_tel", this.ernam_tel));
		xml.append(CommonUtil.makeElement("purchaser_name", this.purchaser_name));
		xml.append(CommonUtil.makeElement("purchaser_tel", this.purchaser_tel));
		xml.append(CommonUtil.makeElement("origin_code", this.origin_code));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
