package com.koreab2b.ltal.vo;

import com.koreab2b.common.CommonUtil;

public class ApprovalStatusVO {

	private String KEY_NO;
	private String DATA01;
	public String getKEY_NO() {
		return KEY_NO;
	}
	public void setKEY_NO(String kEY_NO) {
		KEY_NO = kEY_NO;
	}
	public String getDATA01() {
		return DATA01;
	}
	public void setDATA01(String dATA01) {
		DATA01 = dATA01;
	}

	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("KEY_NO",this.KEY_NO));
		xml.append(CommonUtil.makeElement("DATA01",this.DATA01));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
