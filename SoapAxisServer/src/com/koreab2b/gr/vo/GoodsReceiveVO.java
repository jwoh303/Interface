package com.koreab2b.gr.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class GoodsReceiveVO {
	private String IF_GB;
	private String GR_NO;
	private String PO_NO;
	private String PO_SEQ;
	private String COMPANY_CODE;
	private String ITEM_CODE;
	private String PO_QTY;
	private String GR_QTY;
	private String BUYING_AMOUNT;
	private String BUYING_PRICE;
	private String BUYING_CURRENCY;
	private String APPLY_CURRENCY;
	private String APPLY_EXRT;
	private String GR_DATE;
	private String GR_CREATOR_NAME;
	private String GR_CREATOR_EMAIL;
	private String GR_CREATOR_PRIVACY_POLICY;
	private String GR_CREATOR_PRIVACY_POLICY_DATE;
	private String INSP_TARGET_QTY;
	private String INSP_DATE;
	private String NORMAL_QTY;
	private String DEFECT_QTY;
	private String REASON;
	private String ORG_GR_NO;
	private String GR_GB;
	private String IV_PIC_NM;
	private String IV_PIC_EMAIL;
	private String IV_PIC_TEL_NO;
	private String CLSG_NO;
	private String CLSG_DTI_NO;
	private String CLSG_SUM_AMOUNT;
	private String CLSG_GR_COUNT;
	private String CLSG_SUPTOTAMT;
	private String CLSG_SURTAX;
	private String CLSG_DATE;
	private String CM_ID_1;
	private String CM_ID_2;
	private String CM_ID_3;
	private String CM_ID_4;
	private String CM_ID_5;
	private String CM_ID_6;
	private String CM_ID_7;
	private String CM_ID_8;
	private String CM_ID_9;
	private String CM_ID_10;
	private String CIS_CODE;
	private String SN_NO;
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
	public String getIF_GB() {
		return IF_GB;
	}
	public void setIF_GB(String iF_GB) {
		IF_GB = iF_GB;
	}
	public String getGR_NO() {
		return GR_NO;
	}
	public void setGR_NO(String gR_NO) {
		GR_NO = gR_NO;
	}
	public String getPO_NO() {
		return PO_NO;
	}
	public void setPO_NO(String pO_NO) {
		PO_NO = pO_NO;
	}
	public String getPO_SEQ() {
		return PO_SEQ;
	}
	public void setPO_SEQ(String pO_SEQ) {
		PO_SEQ = pO_SEQ;
	}
	public String getCOMPANY_CODE() {
		return COMPANY_CODE;
	}
	public void setCOMPANY_CODE(String cOMPANY_CODE) {
		COMPANY_CODE = cOMPANY_CODE;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getPO_QTY() {
		return PO_QTY;
	}
	public void setPO_QTY(String pO_QTY) {
		PO_QTY = pO_QTY;
	}
	public String getGR_QTY() {
		return GR_QTY;
	}
	public void setGR_QTY(String gR_QTY) {
		GR_QTY = gR_QTY;
	}
	public String getBUYING_AMOUNT() {
		return BUYING_AMOUNT;
	}
	public void setBUYING_AMOUNT(String bUYING_AMOUNT) {
		BUYING_AMOUNT = bUYING_AMOUNT;
	}
	public String getBUYING_PRICE() {
		return BUYING_PRICE;
	}
	public void setBUYING_PRICE(String bUYING_PRICE) {
		BUYING_PRICE = bUYING_PRICE;
	}
	public String getBUYING_CURRENCY() {
		return BUYING_CURRENCY;
	}
	public void setBUYING_CURRENCY(String bUYING_CURRENCY) {
		BUYING_CURRENCY = bUYING_CURRENCY;
	}
	public String getAPPLY_CURRENCY() {
		return APPLY_CURRENCY;
	}
	public void setAPPLY_CURRENCY(String aPPLY_CURRENCY) {
		APPLY_CURRENCY = aPPLY_CURRENCY;
	}
	public String getAPPLY_EXRT() {
		return APPLY_EXRT;
	}
	public void setAPPLY_EXRT(String aPPLY_EXRT) {
		APPLY_EXRT = aPPLY_EXRT;
	}
	public String getGR_DATE() {
		return GR_DATE;
	}
	public void setGR_DATE(String gR_DATE) {
		GR_DATE = gR_DATE;
	}
	public String getGR_CREATOR_NAME() {
		return GR_CREATOR_NAME;
	}
	public void setGR_CREATOR_NAME(String gR_CREATOR_NAME) {
		GR_CREATOR_NAME = gR_CREATOR_NAME;
	}
	public String getGR_CREATOR_EMAIL() {
		return GR_CREATOR_EMAIL;
	}
	public void setGR_CREATOR_EMAIL(String gR_CREATOR_EMAIL) {
		GR_CREATOR_EMAIL = gR_CREATOR_EMAIL;
	}
	public String getGR_CREATOR_PRIVACY_POLICY() {
		return GR_CREATOR_PRIVACY_POLICY;
	}
	public void setGR_CREATOR_PRIVACY_POLICY(String gR_CREATOR_PRIVACY_POLICY) {
		GR_CREATOR_PRIVACY_POLICY = gR_CREATOR_PRIVACY_POLICY;
	}
	public String getGR_CREATOR_PRIVACY_POLICY_DATE() {
		return GR_CREATOR_PRIVACY_POLICY_DATE;
	}
	public void setGR_CREATOR_PRIVACY_POLICY_DATE(
			String gR_CREATOR_PRIVACY_POLICY_DATE) {
		GR_CREATOR_PRIVACY_POLICY_DATE = gR_CREATOR_PRIVACY_POLICY_DATE;
	}
	public String getINSP_TARGET_QTY() {
		return INSP_TARGET_QTY;
	}
	public void setINSP_TARGET_QTY(String iNSP_TARGET_QTY) {
		INSP_TARGET_QTY = iNSP_TARGET_QTY;
	}
	public String getINSP_DATE() {
		return INSP_DATE;
	}
	public void setINSP_DATE(String iNSP_DATE) {
		INSP_DATE = iNSP_DATE;
	}
	public String getNORMAL_QTY() {
		return NORMAL_QTY;
	}
	public void setNORMAL_QTY(String nORMAL_QTY) {
		NORMAL_QTY = nORMAL_QTY;
	}
	public String getDEFECT_QTY() {
		return DEFECT_QTY;
	}
	public void setDEFECT_QTY(String dEFECT_QTY) {
		DEFECT_QTY = dEFECT_QTY;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getORG_GR_NO() {
		return ORG_GR_NO;
	}
	public void setORG_GR_NO(String oRG_GR_NO) {
		ORG_GR_NO = oRG_GR_NO;
	}
	public String getGR_GB() {
		return GR_GB;
	}
	public void setGR_GB(String gR_GB) {
		GR_GB = gR_GB;
	}
	public String getIV_PIC_NM() {
		return IV_PIC_NM;
	}
	public void setIV_PIC_NM(String iV_PIC_NM) {
		IV_PIC_NM = iV_PIC_NM;
	}
	public String getIV_PIC_EMAIL() {
		return IV_PIC_EMAIL;
	}
	public void setIV_PIC_EMAIL(String iV_PIC_EMAIL) {
		IV_PIC_EMAIL = iV_PIC_EMAIL;
	}
	public String getIV_PIC_TEL_NO() {
		return IV_PIC_TEL_NO;
	}
	public void setIV_PIC_TEL_NO(String iV_PIC_TEL_NO) {
		IV_PIC_TEL_NO = iV_PIC_TEL_NO;
	}
	public String getCLSG_NO() {
		return CLSG_NO;
	}
	public void setCLSG_NO(String cLSG_NO) {
		CLSG_NO = cLSG_NO;
	}
	public String getCLSG_DTI_NO() {
		return CLSG_DTI_NO;
	}
	public void setCLSG_DTI_NO(String cLSG_DTI_NO) {
		CLSG_DTI_NO = cLSG_DTI_NO;
	}
	public String getCLSG_SUM_AMOUNT() {
		return CLSG_SUM_AMOUNT;
	}
	public void setCLSG_SUM_AMOUNT(String cLSG_SUM_AMOUNT) {
		CLSG_SUM_AMOUNT = cLSG_SUM_AMOUNT;
	}
	public String getCLSG_GR_COUNT() {
		return CLSG_GR_COUNT;
	}
	public void setCLSG_GR_COUNT(String cLSG_GR_COUNT) {
		CLSG_GR_COUNT = cLSG_GR_COUNT;
	}
	public String getCLSG_SUPTOTAMT() {
		return CLSG_SUPTOTAMT;
	}
	public void setCLSG_SUPTOTAMT(String cLSG_SUPTOTAMT) {
		CLSG_SUPTOTAMT = cLSG_SUPTOTAMT;
	}
	public String getCLSG_SURTAX() {
		return CLSG_SURTAX;
	}
	public void setCLSG_SURTAX(String cLSG_SURTAX) {
		CLSG_SURTAX = cLSG_SURTAX;
	}
	public String getCLSG_DATE() {
		return CLSG_DATE;
	}
	public void setCLSG_DATE(String cLSG_DATE) {
		CLSG_DATE = cLSG_DATE;
	}
	public String getCM_ID_1() {
		return CM_ID_1;
	}
	public void setCM_ID_1(String cM_ID_1) {
		CM_ID_1 = cM_ID_1;
	}
	public String getCM_ID_2() {
		return CM_ID_2;
	}
	public void setCM_ID_2(String cM_ID_2) {
		CM_ID_2 = cM_ID_2;
	}
	public String getCM_ID_3() {
		return CM_ID_3;
	}
	public void setCM_ID_3(String cM_ID_3) {
		CM_ID_3 = cM_ID_3;
	}
	public String getCM_ID_4() {
		return CM_ID_4;
	}
	public void setCM_ID_4(String cM_ID_4) {
		CM_ID_4 = cM_ID_4;
	}
	public String getCM_ID_5() {
		return CM_ID_5;
	}
	public void setCM_ID_5(String cM_ID_5) {
		CM_ID_5 = cM_ID_5;
	}
	public String getCM_ID_6() {
		return CM_ID_6;
	}
	public void setCM_ID_6(String cM_ID_6) {
		CM_ID_6 = cM_ID_6;
	}
	public String getCM_ID_7() {
		return CM_ID_7;
	}
	public void setCM_ID_7(String cM_ID_7) {
		CM_ID_7 = cM_ID_7;
	}
	public String getCM_ID_8() {
		return CM_ID_8;
	}
	public void setCM_ID_8(String cM_ID_8) {
		CM_ID_8 = cM_ID_8;
	}
	public String getCM_ID_9() {
		return CM_ID_9;
	}
	public void setCM_ID_9(String cM_ID_9) {
		CM_ID_9 = cM_ID_9;
	}
	public String getCM_ID_10() {
		return CM_ID_10;
	}
	public void setCM_ID_10(String cM_ID_10) {
		CM_ID_10 = cM_ID_10;
	}
	public String getCIS_CODE() {
		return CIS_CODE;
	}
	public void setCIS_CODE(String cIS_CODE) {
		CIS_CODE = cIS_CODE;
	}
	public String getSN_NO() {
		return SN_NO;
	}
	public void setSN_NO(String sN_NO) {
		SN_NO = sN_NO;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("GR_NO", this.GR_NO));
		xml.append(CommonUtil.makeElement("PO_NO", this.PO_NO));
		xml.append(CommonUtil.makeElement("PO_SEQ", this.PO_SEQ));
		xml.append(CommonUtil.makeElement("COMPANY_CODE", this.COMPANY_CODE));
		xml.append(CommonUtil.makeElement("ITEM_CODE", this.ITEM_CODE));
		xml.append(CommonUtil.makeElement("PO_QTY", this.PO_QTY));
		xml.append(CommonUtil.makeElement("GR_QTY", this.GR_QTY));
		xml.append(CommonUtil.makeElement("BUYING_AMOUNT", this.BUYING_AMOUNT));
		xml.append(CommonUtil.makeElement("BUYING_PRICE", this.BUYING_PRICE));
		xml.append(CommonUtil.makeElement("BUYING_CURRENCY", this.BUYING_CURRENCY));
		xml.append(CommonUtil.makeElement("APPLY_CURRENCY", this.APPLY_CURRENCY));
		xml.append(CommonUtil.makeElement("APPLY_EXRT", this.APPLY_EXRT));
		xml.append(CommonUtil.makeElement("GR_DATE", this.GR_DATE));
		xml.append(CommonUtil.makeElement("GR_CREATOR_NAME", this.GR_CREATOR_NAME));
		xml.append(CommonUtil.makeElement("GR_CREATOR_EMAIL", this.GR_CREATOR_EMAIL));
		xml.append(CommonUtil.makeElement("GR_CREATOR_PRIVACY_POLICY", this.GR_CREATOR_PRIVACY_POLICY));
		xml.append(CommonUtil.makeElement("GR_CREATOR_PRIVACY_POLICY_DATE", this.GR_CREATOR_PRIVACY_POLICY_DATE));
		xml.append(CommonUtil.makeElement("INSP_TARGET_QTY", this.INSP_TARGET_QTY));
		xml.append(CommonUtil.makeElement("INSP_DATE", this.INSP_DATE));
		xml.append(CommonUtil.makeElement("NORMAL_QTY", this.NORMAL_QTY));
		xml.append(CommonUtil.makeElement("DEFECT_QTY", this.DEFECT_QTY));
		xml.append(CommonUtil.makeElement("REASON", this.REASON));
		xml.append(CommonUtil.makeElement("ORG_GR_NO", this.ORG_GR_NO));
		xml.append(CommonUtil.makeElement("GR_GB", this.GR_GB));
		xml.append(CommonUtil.makeElement("IV_PIC_NM", this.IV_PIC_NM));
		xml.append(CommonUtil.makeElement("IV_PIC_EMAIL", this.IV_PIC_EMAIL));
		xml.append(CommonUtil.makeElement("IV_PIC_TEL_NO", this.IV_PIC_TEL_NO));
		xml.append(CommonUtil.makeElement("CLSG_NO", this.CLSG_NO));
		xml.append(CommonUtil.makeElement("CLSG_DTI_NO", this.CLSG_DTI_NO));
		xml.append(CommonUtil.makeElement("CLSG_SUM_AMOUNT", this.CLSG_SUM_AMOUNT));
		xml.append(CommonUtil.makeElement("CLSG_GR_COUNT", this.CLSG_GR_COUNT));
		xml.append(CommonUtil.makeElement("CLSG_SUPTOTAMT", this.CLSG_SUPTOTAMT));
		xml.append(CommonUtil.makeElement("CLSG_SURTAX", this.CLSG_SURTAX));
		xml.append(CommonUtil.makeElement("CLSG_DATE", this.CLSG_DATE));
		xml.append(CommonUtil.makeElement("CM_ID_1", this.CM_ID_1));
		xml.append(CommonUtil.makeElement("CM_ID_2", this.CM_ID_2));
		xml.append(CommonUtil.makeElement("CM_ID_3", this.CM_ID_3));
		xml.append(CommonUtil.makeElement("CM_ID_4", this.CM_ID_4));
		xml.append(CommonUtil.makeElement("CM_ID_5", this.CM_ID_5));
		xml.append(CommonUtil.makeElement("CM_ID_6", this.CM_ID_6));
		xml.append(CommonUtil.makeElement("CM_ID_7", this.CM_ID_7));
		xml.append(CommonUtil.makeElement("CM_ID_8", this.CM_ID_8));
		xml.append(CommonUtil.makeElement("CM_ID_9", this.CM_ID_9));
		xml.append(CommonUtil.makeElement("CM_ID_10", this.CM_ID_10));
		xml.append(CommonUtil.makeElement("CIS_CODE", this.CIS_CODE));
		xml.append(CommonUtil.makeElement("SN_NO", this.SN_NO));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
