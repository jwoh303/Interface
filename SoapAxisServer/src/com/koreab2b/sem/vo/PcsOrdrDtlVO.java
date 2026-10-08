package com.koreab2b.sem.vo;

import com.koreab2b.util.CommonUtil;

public class PcsOrdrDtlVO {

	private String loekz_item;
	private String ebelp;
	private String matnr;
	private String txz01;
	private String spec;
	private String menge;
	private String meins;
	private String netpr;
	private String waers;
	private String amt;
	private String eindt;
	private String postal;
	private String address1;
	private String address2;
	private String po_date;
	private String po_time;
	private String order_flag;
	private String gr_id;
	private String gr_name;
	private String gr_telno;
	private String gr_hpno;
	private String g_code;
	private String g_name;
	private String u_code;
	private String p_code;
	private String id;
	private String order_step;
	private String gubun;
	private String remark;
	private String quality_class;
	private String peinh;
	public String getLoekz_item() {
		return loekz_item;
	}
	public void setLoekz_item(String loekz_item) {
		this.loekz_item = loekz_item;
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
	public String getTxz01() {
		return txz01;
	}
	public void setTxz01(String txz01) {
		this.txz01 = txz01;
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
	public String getAmt() {
		return amt;
	}
	public void setAmt(String amt) {
		this.amt = amt;
	}
	public String getEindt() {
		return eindt;
	}
	public void setEindt(String eindt) {
		this.eindt = eindt;
	}
	public String getPostal() {
		return postal;
	}
	public void setPostal(String postal) {
		this.postal = postal;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getPo_date() {
		return po_date;
	}
	public void setPo_date(String po_date) {
		this.po_date = po_date;
	}
	public String getPo_time() {
		return po_time;
	}
	public void setPo_time(String po_time) {
		this.po_time = po_time;
	}
	public String getOrder_flag() {
		return order_flag;
	}
	public void setOrder_flag(String order_flag) {
		this.order_flag = order_flag;
	}
	public String getGr_id() {
		return gr_id;
	}
	public void setGr_id(String gr_id) {
		this.gr_id = gr_id;
	}
	public String getGr_name() {
		return gr_name;
	}
	public void setGr_name(String gr_name) {
		this.gr_name = gr_name;
	}
	public String getGr_telno() {
		return gr_telno;
	}
	public void setGr_telno(String gr_telno) {
		this.gr_telno = gr_telno;
	}
	public String getGr_hpno() {
		return gr_hpno;
	}
	public void setGr_hpno(String gr_hpno) {
		this.gr_hpno = gr_hpno;
	}
	public String getG_code() {
		return g_code;
	}
	public void setG_code(String g_code) {
		this.g_code = g_code;
	}
	public String getG_name() {
		return g_name;
	}
	public void setG_name(String g_name) {
		this.g_name = g_name;
	}
	public String getU_code() {
		return u_code;
	}
	public void setU_code(String u_code) {
		this.u_code = u_code;
	}
	public String getP_code() {
		return p_code;
	}
	public void setP_code(String p_code) {
		this.p_code = p_code;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOrder_step() {
		return order_step;
	}
	public void setOrder_step(String order_step) {
		this.order_step = order_step;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getQuality_class() {
		return quality_class;
	}
	public void setQuality_class(String quality_class) {
		this.quality_class = quality_class;
	}
	public String getPeinh() {
		return peinh;
	}
	public void setPeinh(String peinh) {
		this.peinh = peinh;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg1>\n");
		xml.append(CommonUtil.makeElement("loekz_item", this.loekz_item));
		xml.append(CommonUtil.makeElement("ebelp", this.ebelp));
		xml.append(CommonUtil.makeElement("matnr", this.matnr));
		xml.append(CommonUtil.makeElement("txz01", this.txz01));
		xml.append(CommonUtil.makeElement("spec", this.spec));
		xml.append(CommonUtil.makeElement("menge", this.menge));
		xml.append(CommonUtil.makeElement("meins", this.meins));
		xml.append(CommonUtil.makeElement("netpr", this.netpr));
		xml.append(CommonUtil.makeElement("waers", this.waers));
		xml.append(CommonUtil.makeElement("amt", this.amt));
		xml.append(CommonUtil.makeElement("eindt", this.eindt));
		xml.append(CommonUtil.makeElement("postal", this.postal));
		xml.append(CommonUtil.makeElement("address1", this.address1));
		xml.append(CommonUtil.makeElement("address2", this.address2));
		xml.append(CommonUtil.makeElement("po_date", this.po_date));
		xml.append(CommonUtil.makeElement("po_time", this.po_time));
		xml.append(CommonUtil.makeElement("order_flag", this.order_flag));
		xml.append(CommonUtil.makeElement("gr_id", this.gr_id));
		xml.append(CommonUtil.makeElement("gr_name", this.gr_name));
		xml.append(CommonUtil.makeElement("gr_telno", this.gr_telno));
		xml.append(CommonUtil.makeElement("gr_hpno", this.gr_hpno));
		xml.append(CommonUtil.makeElement("g_code", this.g_code));
		xml.append(CommonUtil.makeElement("g_name", this.g_name));
		xml.append(CommonUtil.makeElement("u_code", this.u_code));
		xml.append(CommonUtil.makeElement("p_code", this.p_code));
		xml.append(CommonUtil.makeElement("id", this.id));
		xml.append(CommonUtil.makeElement("order_step", this.order_step));
		xml.append(CommonUtil.makeElement("gubun", this.gubun));
		xml.append(CommonUtil.makeElement("remark", this.remark));
		xml.append(CommonUtil.makeElement("quality_class", this.quality_class));
		xml.append(CommonUtil.makeElement("peinh", this.peinh));
		xml.append("</arg1>\n");
		
		return xml.toString();
	}
}
