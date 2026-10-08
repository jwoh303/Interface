package com.koreab2b.ltal.vo;

import com.koreab2b.common.CommonUtil;

public class ResultVO {

	private String IF_SEQ;
	private String DOC_TYPE;
	private String DATA01;
	private String DATA02;
	private String DATA03;
	private String DATA04;
	private String DATA05;
	private String IF_FLAG;
	private String IF_MSG;
	
	public String getIF_SEQ() {
		return IF_SEQ;
	}
	public void setIF_SEQ(String iF_SEQ) {
		IF_SEQ = iF_SEQ;
	}
	public String getDOC_TYPE() {
		return DOC_TYPE;
	}
	public void setDOC_TYPE(String dOC_TYPE) {
		DOC_TYPE = dOC_TYPE;
	}
	public String getDATA01() {
		return DATA01;
	}
	public void setDATA01(String dATA01) {
		DATA01 = dATA01;
	}
	public String getDATA02() {
		return DATA02;
	}
	public void setDATA02(String dATA02) {
		DATA02 = dATA02;
	}
	public String getDATA03() {
		return DATA03;
	}
	public void setDATA03(String dATA03) {
		DATA03 = dATA03;
	}
	public String getDATA04() {
		return DATA04;
	}
	public void setDATA04(String dATA04) {
		DATA04 = dATA04;
	}
	public String getDATA05() {
		return DATA05;
	}
	public void setDATA05(String dATA05) {
		DATA05 = dATA05;
	}
	public String getIF_FLAG() {
		return IF_FLAG;
	}
	public void setIF_FLAG(String iF_FLAG) {
		IF_FLAG = iF_FLAG;
	}
	public String getIF_MSG() {
		return IF_MSG;
	}
	public void setIF_MSG(String iF_MSG) {
		IF_MSG = iF_MSG;
	}

	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("IF_SEQ",this.IF_SEQ));
		xml.append(CommonUtil.makeElement("DOC_TYPE",this.DOC_TYPE));
		xml.append(CommonUtil.makeElement("DATA01",this.DATA01));
		xml.append(CommonUtil.makeElement("DATA02",this.DATA02));
		xml.append(CommonUtil.makeElement("DATA03",this.DATA03));
		xml.append(CommonUtil.makeElement("DATA04",this.DATA04));
		xml.append(CommonUtil.makeElement("DATA05",this.DATA05));
		xml.append(CommonUtil.makeElement("IF_FLAG",this.IF_FLAG));
		xml.append(CommonUtil.makeElement("IF_MSG",this.IF_MSG));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
	
	

}
