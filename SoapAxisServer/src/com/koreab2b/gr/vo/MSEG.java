package com.koreab2b.gr.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class MSEG {

	@XmlElement(required=true)
	private String MBLNR;
	@XmlElement(required=true)
	private String MJAHR;
	@XmlElement(required=true)
	private String ZEILE;
	private String MATNR;
	private Double MENGE;
	private String MEINS;
	private String CHARG;
	private String WERKS;
	private String LGORT;
	private String EMLIF;
	private String ENAME;
	private String BWART;
	private String SOBKZ;
	private String INSMK;
	private String EBELN;
	private String EBELP;
	private String PSTYP;
	private String IMPORT;
	private String LIFNR;
	private String LNAME;
	private String SHKZG;
	private String WAERS;
	private Double DMBTR;
	
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
	public String getZEILE() {
		return ZEILE;
	}
	public void setZEILE(String zEILE) {
		ZEILE = zEILE;
	}
	public String getMATNR() {
		return MATNR;
	}
	public void setMATNR(String mATNR) {
		MATNR = mATNR;
	}
	public Double getMENGE() {
		return MENGE;
	}
	public void setMENGE(Double mENGE) {
		MENGE = mENGE;
	}
	public String getMEINS() {
		return MEINS;
	}
	public void setMEINS(String mEINS) {
		MEINS = mEINS;
	}
	public String getCHARG() {
		return CHARG;
	}
	public void setCHARG(String cHARG) {
		CHARG = cHARG;
	}
	public String getWERKS() {
		return WERKS;
	}
	public void setWERKS(String wERKS) {
		WERKS = wERKS;
	}
	public String getLGORT() {
		return LGORT;
	}
	public void setLGORT(String lGORT) {
		LGORT = lGORT;
	}
	public String getEMLIF() {
		return EMLIF;
	}
	public void setEMLIF(String eMLIF) {
		EMLIF = eMLIF;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getBWART() {
		return BWART;
	}
	public void setBWART(String bWART) {
		BWART = bWART;
	}
	public String getSOBKZ() {
		return SOBKZ;
	}
	public void setSOBKZ(String sOBKZ) {
		SOBKZ = sOBKZ;
	}
	public String getINSMK() {
		return INSMK;
	}
	public void setINSMK(String iNSMK) {
		INSMK = iNSMK;
	}
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
	public String getPSTYP() {
		return PSTYP;
	}
	public void setPSTYP(String pSTYP) {
		PSTYP = pSTYP;
	}
	public String getIMPORT() {
		return IMPORT;
	}
	public void setIMPORT(String iMPORT) {
		IMPORT = iMPORT;
	}
	public String getLIFNR() {
		return LIFNR;
	}
	public void setLIFNR(String lIFNR) {
		LIFNR = lIFNR;
	}
	public String getLNAME() {
		return LNAME;
	}
	public void setLNAME(String lNAME) {
		LNAME = lNAME;
	}
	public String getSHKZG() {
		return SHKZG;
	}
	public void setSHKZG(String sHKZG) {
		SHKZG = sHKZG;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public Double getDMBTR() {
		return DMBTR;
	}
	public void setDMBTR(Double dMBTR) {
		DMBTR = dMBTR;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<grDetail>");
		xml.append("<MBLNR>"+MBLNR+"</MBLNR>\n");
		xml.append("<MJAHR>"+MJAHR+"</MJAHR>\n");
		xml.append("<ZEILE>"+ZEILE+"</ZEILE>\n");
		xml.append("<MATNR>"+MATNR+"</MATNR>\n");
		xml.append("<MENGE>"+MENGE+"</MENGE>\n");
		xml.append("<MEINS>"+MEINS+"</MEINS>\n");
		xml.append("<CHARG>"+CHARG+"</CHARG>\n");
		xml.append("<WERKS>"+WERKS+"</WERKS>\n");
		xml.append("<LGORT>"+LGORT+"</LGORT>\n");
		xml.append("<EMLIF>"+EMLIF+"</EMLIF>\n");
		xml.append("<ENAME>"+ENAME+"</ENAME>\n");
		xml.append("<BWART>"+BWART+"</BWART>\n");
		xml.append("<SOBKZ>"+SOBKZ+"</SOBKZ>\n");
		xml.append("<INSMK>"+INSMK+"</INSMK>\n");
		xml.append("<EBELN>"+EBELN+"</EBELN>\n");
		xml.append("<EBELP>"+EBELP+"</EBELP>\n");
		xml.append("<PSTYP>"+PSTYP+"</PSTYP>\n");
		xml.append("<IMPORT>"+IMPORT+"</IMPORT>\n");
		xml.append("<LIFNR>"+LIFNR+"</LIFNR>\n");
		xml.append("<LNAME>"+LNAME+"</LNAME>\n");
		xml.append("<SHKZG>"+SHKZG+"</SHKZG>\n");
		xml.append("<WAERS>"+WAERS+"</WAERS>\n");
		xml.append("<DMBTR>"+DMBTR+"</DMBTR>\n");
		xml.append("</grDetail>");
		
		return xml.toString();
	}
}
