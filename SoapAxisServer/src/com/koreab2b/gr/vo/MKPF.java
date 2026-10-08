package com.koreab2b.gr.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class MKPF {

	@XmlElement(required=true)
	private String MBLNR;
	@XmlElement(required=true)
	private String MJAHR;
	private String SMBLN;
	private String SJAHR;
	private String BLDAT;
	private String BUDAT;
	private String LE_VBELN;
	private String BKTXT;
	private String TYPE;
	
	public String getMBLNR() {
		return MBLNR;
	}
	public void setMBLNR(String mBLNR) {
		MBLNR = mBLNR;
	}
	public String getMJAHR() {
		return MJAHR;
	}
	public void setMJAHR(String mJAHR) {
		MJAHR = mJAHR;
	}
	public String getSMBLN() {
		return SMBLN;
	}
	public void setSMBLN(String sMBLN) {
		SMBLN = sMBLN;
	}
	public String getSJAHR() {
		return SJAHR;
	}
	public void setSJAHR(String sJAHR) {
		SJAHR = sJAHR;
	}
	public String getBLDAT() {
		return BLDAT;
	}
	public void setBLDAT(String bLDAT) {
		BLDAT = bLDAT;
	}
	public String getBUDAT() {
		return BUDAT;
	}
	public void setBUDAT(String bUDAT) {
		BUDAT = bUDAT;
	}
	public String getLE_VBELN() {
		return LE_VBELN;
	}
	public void setLE_VBELN(String lE_VBELN) {
		LE_VBELN = lE_VBELN;
	}
	public String getBKTXT() {
		return BKTXT;
	}
	public void setBKTXT(String bKTXT) {
		BKTXT = bKTXT;
	}
	public String getTYPE() {
		return TYPE;
	}
	public void setTYPE(String tYPE) {
		TYPE = tYPE;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<grHeader>");
		xml.append("<MBLNR>"+MBLNR+"</MBLNR>\n");
		xml.append("<MJAHR>"+MJAHR+"</MJAHR>\n");
		xml.append("<SMBLN>"+SMBLN+"</SMBLN>\n");
		xml.append("<SJAHR>"+SJAHR+"</SJAHR>\n");
		xml.append("<BLDAT>"+BLDAT+"</BLDAT>\n");
		xml.append("<BUDAT>"+BUDAT+"</BUDAT>\n");
		xml.append("<LE_VBELN>"+LE_VBELN+"</LE_VBELN>\n");
		xml.append("<BKTXT>"+BKTXT+"</BKTXT>\n");
		xml.append("<TYPE>"+TYPE+"</TYPE>\n");
		xml.append("</grHeader>");
		
		return xml.toString();
	}
}
