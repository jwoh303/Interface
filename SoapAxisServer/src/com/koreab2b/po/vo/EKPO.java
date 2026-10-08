package com.koreab2b.po.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class EKPO {

	@XmlElement(required=true)
	private String EBELN;	
	@XmlElement(required=true)
	private String EBELP;	
	private String BANFN;	
	private String BNFPO;	
	private String MATNR;	
	private String TXZ01;	
	private String ZZSIZE;	
	private Double MENGE;	
	private String MEINS;	
	private Double NETPR;	
	private Double BRTWR;	
	private String WERKS;	
	private String NAME1;	
	private String ORT01;	
	private String LGORT;	
	private String LGOBE;	
	private String LOEKZ;
	private String ZZAFNAM;
	private String ZZAFNAM_NAME;
	private String ZZDEPTA;
	private String ZZDEPTA_NAME;
	private String ZZEMAIL;
	private String ZZPHONE1;
	private String ZZPHONE2;
	private String ITEMTXT;
	private Double PEINH;
	private String KOSTL;
	private String KTEXT;
	
	public String getEBELN() {
		return EBELN;
	}
	public void setEBELN(String pEBELN) {
		EBELN = pEBELN;
	}
	public String getEBELP() {
		return EBELP;
	}
	public void setEBELP(String pEBELP) {
		EBELP = pEBELP;
	}
	public String getBANFN() {
		return BANFN;
	}
	public void setBANFN(String pBANFN) {
		BANFN = pBANFN;
	}
	public String getBNFPO() {
		return BNFPO;
	}
	public void setBNFPO(String pBNFPO) {
		BNFPO = pBNFPO;
	}
	public String getMATNR() {
		return MATNR;
	}
	public void setMATNR(String pMATNR) {
		MATNR = pMATNR;
	}
	public String getTXZ01() {
		return TXZ01;
	}
	public void setTXZ01(String pTXZ01) {
		TXZ01 = pTXZ01;
	}
	public String getZZSIZE() {
		return ZZSIZE;
	}
	public void setZZSIZE(String pZZSIZE) {
		ZZSIZE = pZZSIZE;
	}
	public Double getMENGE() {
		return MENGE;
	}
	public void setMENGE(Double pMENGE) {
		MENGE = pMENGE;
	}
	public String getMEINS() {
		return MEINS;
	}
	public void setMEINS(String pMEINS) {
		MEINS = pMEINS;
	}
	public Double getNETPR() {
		return NETPR;
	}
	public void setNETPR(Double pNETPR) {
		NETPR = pNETPR;
	}
	public Double getBRTWR() {
		return BRTWR;
	}
	public void setBRTWR(Double pBRTWR) {
		BRTWR = pBRTWR;
	}
	public String getWERKS() {
		return WERKS;
	}
	public void setWERKS(String pWERKS) {
		WERKS = pWERKS;
	}
	public String getNAME1() {
		return NAME1;
	}
	public void setNAME1(String pNAME1) {
		NAME1 = pNAME1;
	}
	public String getORT01() {
		return ORT01;
	}
	public void setORT01(String pORT01) {
		ORT01 = pORT01;
	}
	public String getLGORT() {
		return LGORT;
	}
	public void setLGORT(String pLGORT) {
		LGORT = pLGORT;
	}
	public String getLGOBE() {
		return LGOBE;
	}
	public void setLGOBE(String pLGOBE) {
		LGOBE = pLGOBE;
	}
	public String getLOEKZ() {
		return LOEKZ;
	}
	public void setLOEKZ(String pLOEKZ) {
		LOEKZ = pLOEKZ;
	}
	public String getZZAFNAM() {
		return ZZAFNAM;
	}
	public void setZZAFNAM(String pZZAFNAM) {
		ZZAFNAM = pZZAFNAM;
	}
	public String getZZAFNAM_NAME() {
		return ZZAFNAM_NAME;
	}
	public void setZZAFNAM_NAME(String pZZAFNAM_NAME) {
		ZZAFNAM_NAME = pZZAFNAM_NAME;
	}
	public String getZZDEPTA() {
		return ZZDEPTA;
	}
	public void setZZDEPTA(String pZZDEPTA) {
		ZZDEPTA = pZZDEPTA;
	}
	public String getZZDEPTA_NAME() {
		return ZZDEPTA_NAME;
	}
	public void setZZDEPTA_NAME(String pZZDEPTA_NAME) {
		ZZDEPTA_NAME = pZZDEPTA_NAME;
	}
	public String getZZEMAIL() {
		return ZZEMAIL;
	}
	public void setZZEMAIL(String pZZEMAIL) {
		ZZEMAIL = pZZEMAIL;
	}
	public String getZZPHONE1() {
		return ZZPHONE1;
	}
	public void setZZPHONE1(String pZZPHONE1) {
		ZZPHONE1 = pZZPHONE1;
	}
	public String getZZPHONE2() {
		return ZZPHONE2;
	}
	public void setZZPHONE2(String pZZPHONE2) {
		ZZPHONE2 = pZZPHONE2;
	}
	public String getITEMTXT() {
		return ITEMTXT;
	}
	public void setITEMTXT(String iTEMTXT) {
		ITEMTXT = iTEMTXT;
	}
	public Double getPEINH() {
		return PEINH;
	}
	public void setPEINH(Double pEINH) {
		PEINH = pEINH;
	}
	public String getKOSTL() {
		return KOSTL;
	}
	public void setKOSTL(String kOSTL) {
		KOSTL = kOSTL;
	}
	public String getKTEXT() {
		return KTEXT;
	}
	public void setKTEXT(String kTEXT) {
		KTEXT = kTEXT;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();

		xml.append("<poDetail>\n");
		xml.append("<EBELN>"+EBELN+"</EBELN>\n");
		xml.append("<EBELP>"+EBELP+"</EBELP>\n");
		xml.append("<BANFN>"+BANFN+"</BANFN>\n");
		xml.append("<BNFPO>"+BNFPO+"</BNFPO>\n");
		xml.append("<MATNR>"+MATNR+"</MATNR>\n");
		xml.append("<TXZ01>"+TXZ01+"</TXZ01>\n");
		xml.append("<ZZSIZE>"+ZZSIZE+"</ZZSIZE>\n");
		xml.append("<MENGE>"+MENGE+"</MENGE>\n");
		xml.append("<MEINS>"+MEINS+"</MEINS>\n");
		xml.append("<NETPR>"+NETPR+"</NETPR>\n");
		xml.append("<BRTWR>"+BRTWR+"</BRTWR>\n");
		xml.append("<WERKS>"+WERKS+"</WERKS>\n");
		xml.append("<NAME1>"+NAME1+"</NAME1>\n");
		xml.append("<ORT01>"+ORT01+"</ORT01>\n");
		xml.append("<LGORT>"+LGORT+"</LGORT>\n");
		xml.append("<LGOBE>"+LGOBE+"</LGOBE>\n");
		xml.append("<ZZAFNAM>"+ZZAFNAM+"</ZZAFNAM>\n");
		xml.append("<ZZAFNAM_NAME>"+ZZAFNAM_NAME+"</ZZAFNAM_NAME>\n");
		xml.append("<ZZDEPTA>"+ZZDEPTA+"</ZZDEPTA>\n");
		xml.append("<ZZDEPTA_NAME>"+ZZDEPTA_NAME+"</ZZDEPTA_NAME>\n");
		xml.append("<ZZEMAIL>"+ZZEMAIL+"</ZZEMAIL>\n");
		xml.append("<ZZPHONE1>"+ZZPHONE1+"</ZZPHONE1>\n");
		xml.append("<ZZPHONE2>"+ZZPHONE2+"</ZZPHONE2>\n");
		xml.append("<LOEKZ>"+LOEKZ+"</LOEKZ>\n");
		xml.append("<ITEMTXT>"+ITEMTXT+"</ITEMTXT>\n");
		xml.append("<PEINH>"+PEINH+"</PEINH>\n");
		xml.append("<KOSTL>"+KOSTL+"</KOSTL>\n");
		xml.append("<KTEXT>"+KTEXT+"</KTEXT>\n");
		xml.append("</poDetail>\n");

		return xml.toString();
	}
}
