package com.koreab2b.sem.vo;

import com.koreab2b.util.CommonUtil;

public class ItmMapInfoVO {

	private String req_id;
	private String vnd_id;
	private String comp_item_id;
	private String mro_id;
	private String item_nm;
	private String item_nm_en;
	private String item_nm_cn;
	private String std;
	private String std_en;
	private String std_cn;
	private String maker;
	private String model_nm;
	public String getReq_id() {
		return req_id;
	}
	public void setReq_id(String req_id) {
		this.req_id = req_id;
	}
	public String getVnd_id() {
		return vnd_id;
	}
	public void setVnd_id(String vnd_id) {
		this.vnd_id = vnd_id;
	}
	public String getComp_item_id() {
		return comp_item_id;
	}
	public void setComp_item_id(String comp_item_id) {
		this.comp_item_id = comp_item_id;
	}
	public String getMro_id() {
		return mro_id;
	}
	public void setMro_id(String mro_id) {
		this.mro_id = mro_id;
	}
	public String getItem_nm() {
		return item_nm;
	}
	public void setItem_nm(String item_nm) {
		this.item_nm = item_nm;
	}
	public String getItem_nm_en() {
		return item_nm_en;
	}
	public void setItem_nm_en(String item_nm_en) {
		this.item_nm_en = item_nm_en;
	}
	public String getItem_nm_cn() {
		return item_nm_cn;
	}
	public void setItem_nm_cn(String item_nm_cn) {
		this.item_nm_cn = item_nm_cn;
	}
	public String getStd() {
		return std;
	}
	public void setStd(String std) {
		this.std = std;
	}
	public String getStd_en() {
		return std_en;
	}
	public void setStd_en(String std_en) {
		this.std_en = std_en;
	}
	public String getStd_cn() {
		return std_cn;
	}
	public void setStd_cn(String std_cn) {
		this.std_cn = std_cn;
	}
	public String getMaker() {
		return maker;
	}
	public void setMaker(String maker) {
		this.maker = maker;
	}
	public String getModel_nm() {
		return model_nm;
	}
	public void setModel_nm(String model_nm) {
		this.model_nm = model_nm;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("req_id", this.req_id));
		xml.append(CommonUtil.makeElement("vnd_id", this.vnd_id));
		xml.append(CommonUtil.makeElement("comp_item_id", this.comp_item_id));
		xml.append(CommonUtil.makeElement("mro_id", this.mro_id));
		xml.append(CommonUtil.makeElement("item_nm", this.item_nm));
		xml.append(CommonUtil.makeElement("item_nm_en", this.item_nm_en));
		xml.append(CommonUtil.makeElement("item_nm_cn", this.item_nm_cn));
		xml.append(CommonUtil.makeElement("std", this.std));
		xml.append(CommonUtil.makeElement("std_en", this.std_en));
		xml.append(CommonUtil.makeElement("std_cn", this.std_cn));
		xml.append(CommonUtil.makeElement("maker", this.maker));
		xml.append(CommonUtil.makeElement("model_nm", this.model_nm));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}	
}
