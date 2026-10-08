package com.koreab2b.rfq.vo;

import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

@XmlAccessorType(XmlAccessType.FIELD)
public class RfqVO {
	@XmlElement(required=true)
	private String BANFN;
	@XmlElement(required=true)
	private int BNFPO;
	private String BSART;
	private String BSTYP;
	private String LOEKZ;
	private String EKGRP;
	private String ERDAT;
	private String ZZSIZE;
	private String TXZ01;
	private String MATNR;
	private String BUKRS;
	private String BUTXT;
	private String WERKS;
	private String NAME1;
	private String ORT01;
	private String LGORT;
	private String LGOBE;
	private Double MENGE;
	private String MEINS;
	private String LFDAT;
	private Double PREIS;
	private Double PEINH;
	private String ZZMAKER;
	private String WAERS;
	private String ZZAFNAM;
	private String ZZAFNAM_NAME;
	private String ZZDEPTA;
	private String ZZDEPTA_NAME;
	private String ZZEMAIL;
	private String ZZPHONE1;
	private String ZZPHONE2;
	private String ZZORDER;
	private String ZZORDER_NAME;
	private String ZZDEPTO;
	private String ZZDEPTO_NAME;
	private String ZZCLOSE_DATE;
	private String ZZKAMSNO;
	private String ZZTEXT;
	private String SPEC_TEXT;
	private String KZUNW;
	private String REQ_TEXT;
	private String POSID;
	private String POST1;
	private String ZZORDER_PHONE;
	private String CHAR10;
	private String CHAR20;
	private String CHAR30;
	private String CHAR40;
	private WsHeaderVO wsHeader;
	
	public WsHeaderVO getWsHeader() {
		if(wsHeader == null) {
			return new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		return wsHeader;
	}
	public void setWsHeader(WsHeaderVO wsHeader) {
		if(wsHeader == null) {
			this.wsHeader = new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		this.wsHeader = wsHeader;
	}
	public String getBANFN() {
		return BANFN;
	}
	public void setBANFN(String pBANFN) {
		BANFN = pBANFN;
	}
	public int getBNFPO() {
		return BNFPO;
	}
	public void setBNFPO(int pBNFPO) {
		BNFPO = pBNFPO;
	}
	public String getBSART() {
		return BSART;
	}
	public void setBSART(String pBSART) {
		BSART = pBSART;
	}
	public String getBSTYP() {
		return BSTYP;
	}
	public void setBSTYP(String pBSTYP) {
		BSTYP = pBSTYP;
	}
	public String getLOEKZ() {
		return LOEKZ;
	}
	public void setLOEKZ(String pLOEKZ) {
		LOEKZ = pLOEKZ;
	}
	public String getEKGRP() {
		return EKGRP;
	}
	public void setEKGRP(String pEKGRP) {
		EKGRP = pEKGRP;
	}
	public String getERDAT() {
		return ERDAT;
	}
	public void setERDAT(String pERDAT) {
		ERDAT = pERDAT;
	}
	public String getZZSIZE() {
		return ZZSIZE;
	}
	public void setZZSIZE(String pZZSIZE) {
		ZZSIZE = pZZSIZE;
	}
	public String getTXZ01() {
		return TXZ01;
	}
	public void setTXZ01(String pTXZ01) {
		TXZ01 = pTXZ01;
	}
	public String getMATNR() {
		return MATNR;
	}
	public void setMATNR(String pMATNR) {
		MATNR = pMATNR;
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
	public String getLFDAT() {
		return LFDAT;
	}
	public void setLFDAT(String pLFDAT) {
		LFDAT = pLFDAT;
	}
	public Double getPREIS() {
		return PREIS;
	}
	public void setPREIS(Double pPREIS) {
		PREIS = pPREIS;
	}
	public Double getPEINH() {
		return PEINH;
	}
	public void setPEINH(Double pPEINH) {
		PEINH = pPEINH;
	}
	public String getZZMAKER() {
		return ZZMAKER;
	}
	public void setZZMAKER(String pZZMAKER) {
		ZZMAKER = pZZMAKER;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String pWAERS) {
		WAERS = pWAERS;
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
	public String getZZCLOSE_DATE() {
		return ZZCLOSE_DATE;
	}
	public void setZZCLOSE_DATE(String pZZCLOSE_DATE) {
		ZZCLOSE_DATE = pZZCLOSE_DATE;
	}
	public String getZZKAMSNO() {
		return ZZKAMSNO;
	}
	public void setZZKAMSNO(String pZZKAMSNO) {
		ZZKAMSNO = pZZKAMSNO;
	}
	public String getZZTEXT() {
		return ZZTEXT;
	}
	public void setZZTEXT(String pZZTEXT) {
		ZZTEXT = pZZTEXT;
	}
	public String getSPEC_TEXT() {
		return SPEC_TEXT;
	}
	public void setSPEC_TEXT(String pSPEC_TEXT) {
		SPEC_TEXT = pSPEC_TEXT;
	}
	public String getKZUNW() {
		return KZUNW;
	}
	public void setKZUNW(String pKZUNW) {
		KZUNW = pKZUNW;
	}
	public String getREQ_TEXT() {
		return REQ_TEXT;
	}
	public void setREQ_TEXT(String pREQ_TEXT) {
		REQ_TEXT = pREQ_TEXT;
	}
	public String getPOSID() {
		return POSID;
	}
	public void setPOSID(String pOSID) {
		POSID = pOSID;
	}
	public String getPOST1() {
		return POST1;
	}
	public void setPOST1(String pOST1) {
		POST1 = pOST1;
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

		xml.append("<arg0>\n");
		xml.append("  <BANFN>"+BANFN+"</BANFN>\n");
		xml.append("  <BNFPO>"+BNFPO+"</BNFPO>\n");
		xml.append("  <BSART>"+BSART+"</BSART>\n");
		xml.append("  <BSTYP>"+BSTYP+"</BSTYP>\n");
		xml.append("  <LOEKZ>"+LOEKZ+"</LOEKZ>\n");
		xml.append("  <EKGRP>"+EKGRP+"</EKGRP>\n");
		xml.append("  <ERDAT>"+ERDAT+"</ERDAT>\n");
		xml.append("  <ZZSIZE>"+ZZSIZE+"</ZZSIZE>\n");
		xml.append("  <TXZ01>"+TXZ01+"</TXZ01>\n");
		xml.append("  <MATNR>"+MATNR+"</MATNR>\n");
		xml.append("  <BUKRS>"+BUKRS+"</BUKRS>\n");
		xml.append("  <BUTXT>"+BUTXT+"</BUTXT>\n");
		xml.append("  <WERKS>"+WERKS+"</WERKS>\n");
		xml.append("  <NAME1>"+NAME1+"</NAME1>\n");
		xml.append("  <ORT01>"+ORT01+"</ORT01>\n");
		xml.append("  <LGORT>"+LGORT+"</LGORT>\n");
		xml.append("  <LGOBE>"+LGOBE+"</LGOBE>\n");
		xml.append("  <MENGE>"+MENGE+"</MENGE>\n");
		xml.append("  <MEINS>"+MEINS+"</MEINS>\n");
		xml.append("  <LFDAT>"+LFDAT+"</LFDAT>\n");
		xml.append("  <PREIS>"+PREIS+"</PREIS>\n");
		xml.append("  <PEINH>"+PEINH+"</PEINH>\n");
		xml.append("  <ZZMAKER>"+ZZMAKER+"</ZZMAKER>\n");
		xml.append("  <WAERS>"+WAERS+"</WAERS>\n");
		xml.append("  <ZZAFNAM>"+ZZAFNAM+"</ZZAFNAM>\n");
		xml.append("  <ZZAFNAM_NAME>"+ZZAFNAM_NAME+"</ZZAFNAM_NAME>\n");
		xml.append("  <ZZDEPTA>"+ZZDEPTA+"</ZZDEPTA>\n");
		xml.append("  <ZZDEPTA_NAME>"+ZZDEPTA_NAME+"</ZZDEPTA_NAME>\n");
		xml.append("  <ZZEMAIL>"+ZZEMAIL+"</ZZEMAIL>\n");
		xml.append("  <ZZPHONE1>"+ZZPHONE1+"</ZZPHONE1>\n");
		xml.append("  <ZZPHONE2>"+ZZPHONE2+"</ZZPHONE2>\n");
		xml.append("  <ZZORDER>"+ZZORDER+"</ZZORDER>\n");
		xml.append("  <ZZORDER_NAME>"+ZZORDER_NAME+"</ZZORDER_NAME>\n");
		xml.append("  <ZZDEPTO>"+ZZDEPTO+"</ZZDEPTO>\n");
		xml.append("  <ZZDEPTO_NAME>"+ZZDEPTO_NAME+"</ZZDEPTO_NAME>\n");
		xml.append("  <ZZCLOSE_DATE>"+ZZCLOSE_DATE+"</ZZCLOSE_DATE>\n");
		xml.append("  <ZZKAMSNO>"+ZZKAMSNO+"</ZZKAMSNO>\n");
		xml.append("  <ZZTEXT>"+ZZTEXT+"</ZZTEXT>\n");
		xml.append("  <SPEC_TEXT>"+SPEC_TEXT+"</SPEC_TEXT>\n");
		xml.append("  <KZUNW>"+KZUNW+"</KZUNW>\n");
		xml.append("  <REQ_TEXT>"+REQ_TEXT+"</REQ_TEXT>\n");
		xml.append("  <POSID>"+POSID+"</POSID>\n");
		xml.append("  <POST1>"+POST1+"</POST1>\n");
		xml.append("  <ZZORDER_PHONE>"+ZZORDER_PHONE+"</ZZORDER_PHONE>\n");
		xml.append("  <CHAR10>"+CHAR10+"</CHAR10>\n");
		xml.append("  <CHAR20>"+CHAR20+"</CHAR20>\n");
		xml.append("  <CHAR30>"+CHAR30+"</CHAR30>\n");
		xml.append("  <CHAR40>"+CHAR40+"</CHAR40>\n");
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
