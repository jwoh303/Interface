package com.koreab2b.po.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class EKKO {

	@XmlElement(required=true)
	private String EBELN;	
	@XmlElement(required=true)
	private String BUKRS;	
	private String BUTXT;
	@XmlElement(required=true)
	private String EKORG;
	@XmlElement(required=true)
	private String EKGRP;
	private String ZZORDER;
	private String ZZORDER_NAME;	
	private String ZZDEPTO;	
	private String ZZDEPTO_NAME;	
	private String BSART;	
	private String FLAG;	
	private String LIFNR;	
	private String NAME1;	
	private String AEDAT;	
	private String ZTERM;	
	private String WAERS;	
	private Double WKURS;	
	private String INCO1;	
	private String INCO2;	
	private Double KBETR;
	private String ZZORDER_PHONE;	
	private String CHAR10;	
	private String CHAR20;	
	private String CHAR30;	
	private String CHAR40;	
	
	public String getEBELN() {
		return EBELN;
	}
	public void setEBELN(String pEBELN) {
		EBELN = pEBELN;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String pBUKRS) {
		BUKRS = pBUKRS;
	}
	public String getBUTXT() {
		return BUTXT;
	}
	public void setBUTXT(String pBUTXT) {
		BUTXT = pBUTXT;
	}
	public String getEKORG() {
		return EKORG;
	}
	public void setEKORG(String pEKORG) {
		EKORG = pEKORG;
	}
	public String getEKGRP() {
		return EKGRP;
	}
	public void setEKGRP(String pEKGRP) {
		EKGRP = pEKGRP;
	}
	public String getZZORDER() {
		return ZZORDER;
	}
	public void setZZORDER(String pZZORDER) {
		ZZORDER = pZZORDER;
	}
	public String getZZORDER_NAME() {
		return ZZORDER_NAME;
	}
	public void setZZORDER_NAME(String pZZORDER_NAME) {
		ZZORDER_NAME = pZZORDER_NAME;
	}
	public String getZZDEPTO() {
		return ZZDEPTO;
	}
	public void setZZDEPTO(String pZZDEPTO) {
		ZZDEPTO = pZZDEPTO;
	}
	public String getZZDEPTO_NAME() {
		return ZZDEPTO_NAME;
	}
	public void setZZDEPTO_NAME(String pZZDEPTO_NAME) {
		ZZDEPTO_NAME = pZZDEPTO_NAME;
	}
	public String getBSART() {
		return BSART;
	}
	public void setBSART(String pBSART) {
		BSART = pBSART;
	}
	public String getFLAG() {
		return FLAG;
	}
	public void setFLAG(String pFLAG) {
		FLAG = pFLAG;
	}
	public String getLIFNR() {
		return LIFNR;
	}
	public void setLIFNR(String pLIFNR) {
		LIFNR = pLIFNR;
	}
	public String getNAME1() {
		return NAME1;
	}
	public void setNAME1(String pNAME1) {
		NAME1 = pNAME1;
	}
	public String getAEDAT() {
		return AEDAT;
	}
	public void setAEDAT(String pAEDAT) {
		AEDAT = pAEDAT;
	}
	public String getZTERM() {
		return ZTERM;
	}
	public void setZTERM(String pZTERM) {
		ZTERM = pZTERM;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String pWAERS) {
		WAERS = pWAERS;
	}
	public Double getWKURS() {
		return WKURS;
	}
	public void setWKURS(Double pWKURS) {
		WKURS = pWKURS;
	}
	public String getINCO1() {
		return INCO1;
	}
	public void setINCO1(String pINCO1) {
		INCO1 = pINCO1;
	}
	public String getINCO2() {
		return INCO2;
	}
	public void setINCO2(String pINCO2) {
		INCO2 = pINCO2;
	}
	public Double getKBETR() {
		return KBETR;
	}
	public void setKBETR(Double pKBETR) {
		KBETR = pKBETR;
	}
	public String getZZORDER_PHONE() {
		return ZZORDER_PHONE;
	}
	public void setZZORDER_PHONE(String zZORDER_PHONE) {
		ZZORDER_PHONE = zZORDER_PHONE;
	}
	public String getCHAR10() {
		return CHAR10;
	}
	public void setCHAR10(String cHAR10) {
		CHAR10 = cHAR10;
	}
	public String getCHAR20() {
		return CHAR20;
	}
	public void setCHAR20(String cHAR20) {
		CHAR20 = cHAR20;
	}
	public String getCHAR30() {
		return CHAR30;
	}
	public void setCHAR30(String cHAR30) {
		CHAR30 = cHAR30;
	}
	public String getCHAR40() {
		return CHAR40;
	}
	public void setCHAR40(String cHAR40) {
		CHAR40 = cHAR40;
	}	
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<poHeader>\n");
		xml.append("<EBELN>"+EBELN+"</EBELN>\n");
		xml.append("<BUKRS>"+BUKRS+"</BUKRS>\n");
		xml.append("<BUTXT>"+BUTXT+"</BUTXT>\n");
		xml.append("<EKORG>"+EKORG+"</EKORG>\n");
		xml.append("<EKGRP>"+EKGRP+"</EKGRP>\n");
		xml.append("<ZZORDER>"+ZZORDER+"</ZZORDER>\n");
		xml.append("<ZZORDER_NAME>"+ZZORDER_NAME+"</ZZORDER_NAME>\n");
		xml.append("<ZZDEPTO>"+ZZDEPTO+"</ZZDEPTO>\n");
		xml.append("<ZZDEPTO_NAME>"+ZZDEPTO_NAME+"</ZZDEPTO_NAME>\n");
		xml.append("<BSART>"+BSART+"</BSART>\n");
		xml.append("<FLAG>"+FLAG+"</FLAG>\n");
		xml.append("<LIFNR>"+LIFNR+"</LIFNR>\n");
		xml.append("<NAME1>"+NAME1+"</NAME1>\n");
		xml.append("<AEDAT>"+AEDAT+"</AEDAT>\n");
		xml.append("<ZTERM>"+ZTERM+"</ZTERM>\n");
		xml.append("<WAERS>"+WAERS+"</WAERS>\n");
		xml.append("<WKURS>"+WKURS+"</WKURS>\n");
		xml.append("<INCO1>"+INCO1+"</INCO1>\n");
		xml.append("<INCO2>"+INCO2+"</INCO2>\n");
		xml.append("<KBETR>"+KBETR+"</KBETR>\n");
		xml.append("<ZZORDER_PHONE>"+ZZORDER_PHONE+"</ZZORDER_PHONE>\n");
		xml.append("<CHAR10>"+CHAR10+"</CHAR10>\n");
		xml.append("<CHAR20>"+CHAR20+"</CHAR20>\n");
		xml.append("<CHAR30>"+CHAR30+"</CHAR30>\n");
		xml.append("<CHAR40>"+CHAR40+"</CHAR40>\n");
		xml.append("</poHeader>\n");

		return xml.toString();
	}
}
