package com.koreab2b.po.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class EKET {

	@XmlElement(required=true)
	private String EBELN;	/* 구매오더 번호 */
	@XmlElement(required=true)
	private String EBELP;	/* 구매오더 ITEM 번호 */
	@XmlElement(required=true)
	private int ETENR;		/* 일정 counter */
	private String EINDT;	/* 납품 요청일 */
	
	public String getEBELN() {
		return EBELN;
	}
	public void setEBELN(String eBELN) {
		EBELN = eBELN;
	}
	public String getEBELP() {
		return EBELP;
	}
	public void setEBELP(String eBELP) {
		EBELP = eBELP;
	}
	public int getETENR() {
		return ETENR;
	}
	public void setETENR(int eTENR) {
		ETENR = eTENR;
	}
	public String getEINDT() {
		return EINDT;
	}
	public void setEINDT(String eINDT) {
		EINDT = eINDT;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();

		xml.append("<poDelyPlan>\n");
		xml.append("<EBELN>"+EBELN+"</EBELN>\n");
		xml.append("<EBELP>"+EBELP+"</EBELP>\n");
		xml.append("<ETENR>"+ETENR+"</ETENR>\n");
		xml.append("<EINDT>"+EINDT+"</EINDT>\n");
		xml.append("</poDelyPlan>\n");
		
		return xml.toString();
	}
}
