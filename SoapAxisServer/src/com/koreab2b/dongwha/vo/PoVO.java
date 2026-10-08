package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class PoVO {
	private String LEGACY_PO_NO;
	private String LEGACY_PO_SEQ;
	private String ITEM_QTY;
	private String IF_NO;
	private String IF_SEQ;
	private String STATUS;
	private String REMARK;
	private String EKORG;
	private String PLANT;
	private String BANFN;
	private String BNFPO;
	private String BUYER_ITEM_NO;
	private String UNIT_PRICE;
	private String PURCHASER_ID;
	private String REQ_USER_ID;
	private String ADD_DATE;
	private String RD_DATE;
	private String KNTTP;
	private String ABRAD;
	private String WEMPF;
	private String LGORT;
	private String LGPBE;
	private String DOC_TYPE;
	
	private String RESULT_FLAG;
	private String RESULT_MSG;
	
	public String getLEGACY_PO_NO() {
		return LEGACY_PO_NO;
	}
	public void setLEGACY_PO_NO(String lEGACY_PO_NO) {
		LEGACY_PO_NO = lEGACY_PO_NO;
	}
	public String getLEGACY_PO_SEQ() {
		return LEGACY_PO_SEQ;
	}
	public void setLEGACY_PO_SEQ(String lEGACY_PO_SEQ) {
		LEGACY_PO_SEQ = lEGACY_PO_SEQ;
	}
	public String getITEM_QTY() {
		return ITEM_QTY;
	}
	public void setITEM_QTY(String iTEM_QTY) {
		ITEM_QTY = iTEM_QTY;
	}
	public String getIF_NO() {
		return IF_NO;
	}
	public void setIF_NO(String iF_NO) {
		IF_NO = iF_NO;
	}
	public String getIF_SEQ() {
		return IF_SEQ;
	}
	public void setIF_SEQ(String iF_SEQ) {
		IF_SEQ = iF_SEQ;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getEKORG() {
		return EKORG;
	}
	public void setEKORG(String eKORG) {
		EKORG = eKORG;
	}
	public String getPLANT() {
		return PLANT;
	}
	public void setPLANT(String pLANT) {
		PLANT = pLANT;
	}
	public String getBANFN() {
		return BANFN;
	}
	public void setBANFN(String bANFN) {
		BANFN = bANFN;
	}
	public String getBNFPO() {
		return BNFPO;
	}
	public void setBNFPO(String bNFPO) {
		BNFPO = bNFPO;
	}
	public String getBUYER_ITEM_NO() {
		return BUYER_ITEM_NO;
	}
	public void setBUYER_ITEM_NO(String bUYER_ITEM_NO) {
		BUYER_ITEM_NO = bUYER_ITEM_NO;
	}
	public String getUNIT_PRICE() {
		return UNIT_PRICE;
	}
	public void setUNIT_PRICE(String uNIT_PRICE) {
		UNIT_PRICE = uNIT_PRICE;
	}
	public String getRESULT_FLAG() {
		return RESULT_FLAG;
	}
	public void setRESULT_FLAG(String rESULT_FLAG) {
		RESULT_FLAG = rESULT_FLAG;
	}
	public String getRESULT_MSG() {
		return RESULT_MSG;
	}
	public void setRESULT_MSG(String rESULT_MSG) {
		RESULT_MSG = rESULT_MSG;
	}
	public String getPURCHASER_ID() {
		return PURCHASER_ID;
	}
	public void setPURCHASER_ID(String pURCHASER_ID) {
		PURCHASER_ID = pURCHASER_ID;
	}
	public String getREQ_USER_ID() {
		return REQ_USER_ID;
	}
	public void setREQ_USER_ID(String rEQ_USER_ID) {
		REQ_USER_ID = rEQ_USER_ID;
	}
	public String getADD_DATE() {
		return ADD_DATE;
	}
	public void setADD_DATE(String aDD_DATE) {
		ADD_DATE = aDD_DATE;
	}
	public String getRD_DATE() {
		return RD_DATE;
	}
	public void setRD_DATE(String rD_DATE) {
		RD_DATE = rD_DATE;
	}
	public String getKNTTP() {
		return KNTTP;
	}
	public void setKNTTP(String kNTTP) {
		KNTTP = kNTTP;
	}
	public String getABRAD() {
		return ABRAD;
	}
	public void setABRAD(String aBRAD) {
		ABRAD = aBRAD;
	}
	public String getWEMPF() {
		return WEMPF;
	}
	public void setWEMPF(String wEMPF) {
		WEMPF = wEMPF;
	}
	public String getLGORT() {
		return LGORT;
	}
	public void setLGORT(String lGORT) {
		LGORT = lGORT;
	}
	public String getLGPBE() {
		return LGPBE;
	}
	public void setLGPBE(String lGPBE) {
		LGPBE = lGPBE;
	}
	public String getDOC_TYPE() {
		return DOC_TYPE;
	}
	public void setDOC_TYPE(String dOC_TYPE) {
		DOC_TYPE = dOC_TYPE;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		
		xml.append(CommonUtil.makeElement("LEGACY_PO_NO", this.LEGACY_PO_NO));
		xml.append(CommonUtil.makeElement("LEGACY_PO_SEQ", this.LEGACY_PO_SEQ));
		xml.append(CommonUtil.makeElement("ITEM_QTY", this.ITEM_QTY));
		xml.append(CommonUtil.makeElement("IF_NO", this.IF_NO));
		xml.append(CommonUtil.makeElement("IF_SEQ", this.IF_SEQ));
		xml.append(CommonUtil.makeElement("STATUS", this.STATUS));
		xml.append(CommonUtil.makeElement("REMARK", this.REMARK));
		xml.append(CommonUtil.makeElement("EKORG", this.EKORG));
		xml.append(CommonUtil.makeElement("PLANT", this.PLANT));
		xml.append(CommonUtil.makeElement("BANFN", this.BANFN));
		xml.append(CommonUtil.makeElement("BNFPO", this.BNFPO));
		xml.append(CommonUtil.makeElement("BUYER_ITEM_NO", this.BUYER_ITEM_NO));
		xml.append(CommonUtil.makeElement("UNIT_PRICE", this.UNIT_PRICE));
		xml.append(CommonUtil.makeElement("PURCHASER_ID", this.PURCHASER_ID));
		xml.append(CommonUtil.makeElement("REQ_USER_ID", this.REQ_USER_ID));
		xml.append(CommonUtil.makeElement("ADD_DATE", this.ADD_DATE));
		xml.append(CommonUtil.makeElement("RD_DATE", this.RD_DATE));
		xml.append(CommonUtil.makeElement("KNTTP", this.KNTTP));
		xml.append(CommonUtil.makeElement("ABRAD", this.ABRAD));
		xml.append(CommonUtil.makeElement("WEMPF", this.WEMPF));
		xml.append(CommonUtil.makeElement("LGORT", this.LGORT));
		xml.append(CommonUtil.makeElement("LGPBE", this.LGPBE));
		xml.append(CommonUtil.makeElement("DOC_TYPE", this.DOC_TYPE));

		xml.append("</arg0>\n");

		return xml.toString();
	}
}
