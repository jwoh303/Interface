package com.koreab2b.sem.vo;

import com.koreab2b.util.CommonUtil;

public class GdRcptVO {

	private String loekz;
	private String bukrs;
	private String division;
	private String zsectcd;
	private String ltext;
	private String mjahr;
	private String mblnr;
	private String zeile;
	private String ebeln;
	private String ebelp;
	private String matnr;
	private String maktx;
	private String spec;
	private String menge;
	private String meins;
	private String netpr;
	private String waers;
	private String dmbtr;
	private String zbudat;
	private String lfbnr;
	public String getLoekz() {
		return loekz;
	}
	public void setLoekz(String loekz) {
		this.loekz = loekz;
	}
	public String getBukrs() {
		return bukrs;
	}
	public void setBukrs(String bukrs) {
		this.bukrs = bukrs;
	}
	public String getDivision() {
		return division;
	}
	public void setDivision(String division) {
		this.division = division;
	}
	public String getZsectcd() {
		return zsectcd;
	}
	public void setZsectcd(String zsectcd) {
		this.zsectcd = zsectcd;
	}
	public String getLtext() {
		return ltext;
	}
	public void setLtext(String ltext) {
		this.ltext = ltext;
	}
	public String getMjahr() {
		return mjahr;
	}
	public void setMjahr(String mjahr) {
		this.mjahr = mjahr;
	}
	public String getMblnr() {
		return mblnr;
	}
	public void setMblnr(String mblnr) {
		this.mblnr = mblnr;
	}
	public String getZeile() {
		return zeile;
	}
	public void setZeile(String zeile) {
		this.zeile = zeile;
	}
	public String getEbeln() {
		return ebeln;
	}
	public void setEbeln(String ebeln) {
		this.ebeln = ebeln;
	}
	public String getEbelp() {
		return ebelp;
	}
	public void setEbelp(String ebelp) {
		this.ebelp = ebelp;
	}
	public String getMatnr() {
		return matnr;
	}
	public void setMatnr(String matnr) {
		this.matnr = matnr;
	}
	public String getMaktx() {
		return maktx;
	}
	public void setMaktx(String maktx) {
		this.maktx = maktx;
	}
	public String getSpec() {
		return spec;
	}
	public void setSpec(String spec) {
		this.spec = spec;
	}
	public String getMenge() {
		return menge;
	}
	public void setMenge(String menge) {
		this.menge = menge;
	}
	public String getMeins() {
		return meins;
	}
	public void setMeins(String meins) {
		this.meins = meins;
	}
	public String getNetpr() {
		return netpr;
	}
	public void setNetpr(String netpr) {
		this.netpr = netpr;
	}
	public String getWaers() {
		return waers;
	}
	public void setWaers(String waers) {
		this.waers = waers;
	}
	public String getDmbtr() {
		return dmbtr;
	}
	public void setDmbtr(String dmbtr) {
		this.dmbtr = dmbtr;
	}
	public String getZbudat() {
		return zbudat;
	}
	public void setZbudat(String zbudat) {
		this.zbudat = zbudat;
	}
	public String getLfbnr() {
		return lfbnr;
	}
	public void setLfbnr(String lfbnr) {
		this.lfbnr = lfbnr;
	}

	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("loekz", this.loekz));
		xml.append(CommonUtil.makeElement("bukrs", this.bukrs));
		xml.append(CommonUtil.makeElement("division", this.division));
		xml.append(CommonUtil.makeElement("zsectcd", this.zsectcd));
		xml.append(CommonUtil.makeElement("ltext", this.ltext));
		xml.append(CommonUtil.makeElement("mjahr", this.mjahr));
		xml.append(CommonUtil.makeElement("mblnr", this.mblnr));
		xml.append(CommonUtil.makeElement("zeile", this.zeile));
		xml.append(CommonUtil.makeElement("ebeln", this.ebeln));
		xml.append(CommonUtil.makeElement("ebelp", this.ebelp));
		xml.append(CommonUtil.makeElement("matnr", this.matnr));
		xml.append(CommonUtil.makeElement("maktx", this.maktx));
		xml.append(CommonUtil.makeElement("spec", this.spec));
		xml.append(CommonUtil.makeElement("menge", this.menge));
		xml.append(CommonUtil.makeElement("meins", this.meins));
		xml.append(CommonUtil.makeElement("netpr", this.netpr));
		xml.append(CommonUtil.makeElement("waers", this.waers));
		xml.append(CommonUtil.makeElement("dmbtr", this.dmbtr));
		xml.append(CommonUtil.makeElement("zbudat", this.zbudat));
		xml.append(CommonUtil.makeElement("lfbnr", this.lfbnr));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
