package com.koreab2b.po.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class PurchaseOrderVO {
	private String IF_GB;
	private String PO_NO;
	private String PO_SEQ;
	private String PO_REQ_NO;
	private String MRO_TYPE;
	private String PO_GB;
	private String COMPANY_CODE;
	private String ITEM_CODE;
	private String CIS_CODE;
	private String VENDOR_ITEM_CODE;
	private String DESCRIPTION;
	private String SPECIFICATION;
	private String UNIT_CODE;
	private String MODEL_NO;
	private String MANUFACTURER;
	private String BUDGET_DEPT_CODE;
	private String BUDGET_DEPT_NAME;
	private String ACCOUNT_CODE;
	private String ACCOUNT_NAME;
	private String BUDGET_FLAG;
	private String WBS_CODE;
	private String WBS_NAME;
	private String SUPPLIER_CODE;
	private String SUPPLIER_NAME;
	private String PO_DATE;
	private String REQ_DELIVERY_DATE;
	private String STND_DELIVERY_DATE;
	private String PO_QTY;
	private String BUYING_PRICE;
	private String BUYING_AMOUNT;
	private String BUYING_CURRENCY;
	private String APPLY_CURRENCY;
	private String APPLY_EXRT;
	private String REQUESTER_NAME;
	private String REQUESTER_TEL;
	private String PO_CREATOR_NAME;
	private String PO_CREATOR_TEL;
	private String PO_CREATOR_EMAIL;
	private String PO_CREATOR_PRIVACY_POLICY;
	private String PO_CREATOR_PRIVACY_POLICY_DATE;
	private String DELIVERY_ZIP_NO;
	private String DELIVERY_ADDRESS;
	private String DELIVERY_DETAIL_ADDRESS;
	private String RECEIVER_NAME;
	private String RECEIVER_TEL;
	private String RECEIVER_HP_NO;
	private String RECEIVER_PRIVACY_POLICY;
	private String RECEIVER_PRIVACY_POLICY_DATE;
	private String REQ_INFO;
	private String PO_REQ_DATE;
	private String PO_REQ_HMS;
	private String PROGRESS_STATUS;
	private String ATTACH_NO;
	private String ATTACH_CNT;
	private String CM_ID_1;
	private String CM_ID_2;
	private String CM_ID_3;
	private String CM_ID_4;
	private String CM_ID_5;
	private String CUSTOM_YN;
	private String SHIP_METHODS;
	private String PLANT;
	private String LF_TYPE;
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
	public String getPO_REQ_NO() {
		return PO_REQ_NO;
	}
	public void setPO_REQ_NO(String pO_REQ_NO) {
		PO_REQ_NO = pO_REQ_NO;
	}
	public String getMRO_TYPE() {
		return MRO_TYPE;
	}
	public void setMRO_TYPE(String mRO_TYPE) {
		MRO_TYPE = mRO_TYPE;
	}
	public String getPO_GB() {
		return PO_GB;
	}
	public void setPO_GB(String pO_GB) {
		PO_GB = pO_GB;
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
	public String getCIS_CODE() {
		return CIS_CODE;
	}
	public void setCIS_CODE(String cIS_CODE) {
		CIS_CODE = cIS_CODE;
	}
	public String getVENDOR_ITEM_CODE() {
		return VENDOR_ITEM_CODE;
	}
	public void setVENDOR_ITEM_CODE(String vENDOR_ITEM_CODE) {
		VENDOR_ITEM_CODE = vENDOR_ITEM_CODE;
	}
	public String getDESCRIPTION() {
		return DESCRIPTION;
	}
	public void setDESCRIPTION(String dESCRIPTION) {
		DESCRIPTION = dESCRIPTION;
	}
	public String getSPECIFICATION() {
		return SPECIFICATION;
	}
	public void setSPECIFICATION(String sPECIFICATION) {
		SPECIFICATION = sPECIFICATION;
	}
	public String getUNIT_CODE() {
		return UNIT_CODE;
	}
	public void setUNIT_CODE(String uNIT_CODE) {
		UNIT_CODE = uNIT_CODE;
	}
	public String getMODEL_NO() {
		return MODEL_NO;
	}
	public void setMODEL_NO(String mODEL_NO) {
		MODEL_NO = mODEL_NO;
	}
	public String getMANUFACTURER() {
		return MANUFACTURER;
	}
	public void setMANUFACTURER(String mANUFACTURER) {
		MANUFACTURER = mANUFACTURER;
	}
	public String getBUDGET_DEPT_CODE() {
		return BUDGET_DEPT_CODE;
	}
	public void setBUDGET_DEPT_CODE(String bUDGET_DEPT_CODE) {
		BUDGET_DEPT_CODE = bUDGET_DEPT_CODE;
	}
	public String getBUDGET_DEPT_NAME() {
		return BUDGET_DEPT_NAME;
	}
	public void setBUDGET_DEPT_NAME(String bUDGET_DEPT_NAME) {
		BUDGET_DEPT_NAME = bUDGET_DEPT_NAME;
	}
	public String getACCOUNT_CODE() {
		return ACCOUNT_CODE;
	}
	public void setACCOUNT_CODE(String aCCOUNT_CODE) {
		ACCOUNT_CODE = aCCOUNT_CODE;
	}
	public String getACCOUNT_NAME() {
		return ACCOUNT_NAME;
	}
	public void setACCOUNT_NAME(String aCCOUNT_NAME) {
		ACCOUNT_NAME = aCCOUNT_NAME;
	}
	public String getBUDGET_FLAG() {
		return BUDGET_FLAG;
	}
	public void setBUDGET_FLAG(String bUDGET_FLAG) {
		BUDGET_FLAG = bUDGET_FLAG;
	}
	public String getWBS_CODE() {
		return WBS_CODE;
	}
	public void setWBS_CODE(String wBS_CODE) {
		WBS_CODE = wBS_CODE;
	}
	public String getWBS_NAME() {
		return WBS_NAME;
	}
	public void setWBS_NAME(String wBS_NAME) {
		WBS_NAME = wBS_NAME;
	}
	public String getSUPPLIER_CODE() {
		return SUPPLIER_CODE;
	}
	public void setSUPPLIER_CODE(String sUPPLIER_CODE) {
		SUPPLIER_CODE = sUPPLIER_CODE;
	}
	public String getSUPPLIER_NAME() {
		return SUPPLIER_NAME;
	}
	public void setSUPPLIER_NAME(String sUPPLIER_NAME) {
		SUPPLIER_NAME = sUPPLIER_NAME;
	}
	public String getPO_DATE() {
		return PO_DATE;
	}
	public void setPO_DATE(String pO_DATE) {
		PO_DATE = pO_DATE;
	}
	public String getREQ_DELIVERY_DATE() {
		return REQ_DELIVERY_DATE;
	}
	public void setREQ_DELIVERY_DATE(String rEQ_DELIVERY_DATE) {
		REQ_DELIVERY_DATE = rEQ_DELIVERY_DATE;
	}
	public String getSTND_DELIVERY_DATE() {
		return STND_DELIVERY_DATE;
	}
	public void setSTND_DELIVERY_DATE(String sTND_DELIVERY_DATE) {
		STND_DELIVERY_DATE = sTND_DELIVERY_DATE;
	}
	public String getPO_QTY() {
		return PO_QTY;
	}
	public void setPO_QTY(String pO_QTY) {
		PO_QTY = pO_QTY;
	}
	public String getBUYING_PRICE() {
		return BUYING_PRICE;
	}
	public void setBUYING_PRICE(String bUYING_PRICE) {
		BUYING_PRICE = bUYING_PRICE;
	}
	public String getBUYING_AMOUNT() {
		return BUYING_AMOUNT;
	}
	public void setBUYING_AMOUNT(String bUYING_AMOUNT) {
		BUYING_AMOUNT = bUYING_AMOUNT;
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
	public String getREQUESTER_NAME() {
		return REQUESTER_NAME;
	}
	public void setREQUESTER_NAME(String rEQUESTER_NAME) {
		REQUESTER_NAME = rEQUESTER_NAME;
	}
	public String getREQUESTER_TEL() {
		return REQUESTER_TEL;
	}
	public void setREQUESTER_TEL(String rEQUESTER_TEL) {
		REQUESTER_TEL = rEQUESTER_TEL;
	}
	public String getPO_CREATOR_NAME() {
		return PO_CREATOR_NAME;
	}
	public void setPO_CREATOR_NAME(String pO_CREATOR_NAME) {
		PO_CREATOR_NAME = pO_CREATOR_NAME;
	}
	public String getPO_CREATOR_TEL() {
		return PO_CREATOR_TEL;
	}
	public void setPO_CREATOR_TEL(String pO_CREATOR_TEL) {
		PO_CREATOR_TEL = pO_CREATOR_TEL;
	}
	public String getPO_CREATOR_EMAIL() {
		return PO_CREATOR_EMAIL;
	}
	public void setPO_CREATOR_EMAIL(String pO_CREATOR_EMAIL) {
		PO_CREATOR_EMAIL = pO_CREATOR_EMAIL;
	}
	public String getPO_CREATOR_PRIVACY_POLICY() {
		return PO_CREATOR_PRIVACY_POLICY;
	}
	public void setPO_CREATOR_PRIVACY_POLICY(String pO_CREATOR_PRIVACY_POLICY) {
		PO_CREATOR_PRIVACY_POLICY = pO_CREATOR_PRIVACY_POLICY;
	}
	public String getPO_CREATOR_PRIVACY_POLICY_DATE() {
		return PO_CREATOR_PRIVACY_POLICY_DATE;
	}
	public void setPO_CREATOR_PRIVACY_POLICY_DATE(
			String pO_CREATOR_PRIVACY_POLICY_DATE) {
		PO_CREATOR_PRIVACY_POLICY_DATE = pO_CREATOR_PRIVACY_POLICY_DATE;
	}
	public String getDELIVERY_ZIP_NO() {
		return DELIVERY_ZIP_NO;
	}
	public void setDELIVERY_ZIP_NO(String dELIVERY_ZIP_NO) {
		DELIVERY_ZIP_NO = dELIVERY_ZIP_NO;
	}
	public String getDELIVERY_ADDRESS() {
		return DELIVERY_ADDRESS;
	}
	public void setDELIVERY_ADDRESS(String dELIVERY_ADDRESS) {
		DELIVERY_ADDRESS = dELIVERY_ADDRESS;
	}
	public String getDELIVERY_DETAIL_ADDRESS() {
		return DELIVERY_DETAIL_ADDRESS;
	}
	public void setDELIVERY_DETAIL_ADDRESS(String dELIVERY_DETAIL_ADDRESS) {
		DELIVERY_DETAIL_ADDRESS = dELIVERY_DETAIL_ADDRESS;
	}
	public String getRECEIVER_NAME() {
		return RECEIVER_NAME;
	}
	public void setRECEIVER_NAME(String rECEIVER_NAME) {
		RECEIVER_NAME = rECEIVER_NAME;
	}
	public String getRECEIVER_TEL() {
		return RECEIVER_TEL;
	}
	public void setRECEIVER_TEL(String rECEIVER_TEL) {
		RECEIVER_TEL = rECEIVER_TEL;
	}
	public String getRECEIVER_HP_NO() {
		return RECEIVER_HP_NO;
	}
	public void setRECEIVER_HP_NO(String rECEIVER_HP_NO) {
		RECEIVER_HP_NO = rECEIVER_HP_NO;
	}
	public String getRECEIVER_PRIVACY_POLICY() {
		return RECEIVER_PRIVACY_POLICY;
	}
	public void setRECEIVER_PRIVACY_POLICY(String rECEIVER_PRIVACY_POLICY) {
		RECEIVER_PRIVACY_POLICY = rECEIVER_PRIVACY_POLICY;
	}
	public String getRECEIVER_PRIVACY_POLICY_DATE() {
		return RECEIVER_PRIVACY_POLICY_DATE;
	}
	public void setRECEIVER_PRIVACY_POLICY_DATE(String rECEIVER_PRIVACY_POLICY_DATE) {
		RECEIVER_PRIVACY_POLICY_DATE = rECEIVER_PRIVACY_POLICY_DATE;
	}
	public String getREQ_INFO() {
		return REQ_INFO;
	}
	public void setREQ_INFO(String rEQ_INFO) {
		REQ_INFO = rEQ_INFO;
	}
	public String getPO_REQ_DATE() {
		return PO_REQ_DATE;
	}
	public void setPO_REQ_DATE(String pO_REQ_DATE) {
		PO_REQ_DATE = pO_REQ_DATE;
	}
	public String getPO_REQ_HMS() {
		return PO_REQ_HMS;
	}
	public void setPO_REQ_HMS(String pO_REQ_HMS) {
		PO_REQ_HMS = pO_REQ_HMS;
	}
	public String getPROGRESS_STATUS() {
		return PROGRESS_STATUS;
	}
	public void setPROGRESS_STATUS(String pROGRESS_STATUS) {
		PROGRESS_STATUS = pROGRESS_STATUS;
	}
	public String getATTACH_NO() {
		return ATTACH_NO;
	}
	public void setATTACH_NO(String aTTACH_NO) {
		ATTACH_NO = aTTACH_NO;
	}
	public String getATTACH_CNT() {
		return ATTACH_CNT;
	}
	public void setATTACH_CNT(String aTTACH_CNT) {
		ATTACH_CNT = aTTACH_CNT;
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
	public String getCUSTOM_YN() {
		return CUSTOM_YN;
	}
	public void setCUSTOM_YN(String cUSTOM_YN) {
		CUSTOM_YN = cUSTOM_YN;
	}
	public String getSHIP_METHODS() {
		return SHIP_METHODS;
	}
	public void setSHIP_METHODS(String sHIP_METHODS) {
		SHIP_METHODS = sHIP_METHODS;
	}
	public String getPLANT() {
		return PLANT;
	}
	public void setPLANT(String pLANT) {
		PLANT = pLANT;
	}
	public String getLF_TYPE() {
		return LF_TYPE;
	}
	public void setLF_TYPE(String lF_TYPE) {
		LF_TYPE = lF_TYPE;
	}
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("IF_GB", this.IF_GB));
		xml.append(CommonUtil.makeElement("PO_NO", this.PO_NO));
		xml.append(CommonUtil.makeElement("PO_SEQ", this.PO_SEQ));
		xml.append(CommonUtil.makeElement("PO_REQ_NO", this.PO_REQ_NO));
		xml.append(CommonUtil.makeElement("MRO_TYPE", this.MRO_TYPE));
		xml.append(CommonUtil.makeElement("COMPANY_CODE", this.COMPANY_CODE));
		xml.append(CommonUtil.makeElement("ITEM_CODE", this.ITEM_CODE));
		xml.append(CommonUtil.makeElement("CIS_CODE", this.CIS_CODE));
		xml.append(CommonUtil.makeElement("VENDOR_ITEM_CODE", this.VENDOR_ITEM_CODE));
		xml.append(CommonUtil.makeElement("DESCRIPTION", this.DESCRIPTION));
		xml.append(CommonUtil.makeElement("SPECIFICATION", this.SPECIFICATION));
		xml.append(CommonUtil.makeElement("UNIT_CODE", this.UNIT_CODE));
		xml.append(CommonUtil.makeElement("MODEL_NO", this.MODEL_NO));
		xml.append(CommonUtil.makeElement("MANUFACTURER", this.MANUFACTURER));
		xml.append(CommonUtil.makeElement("BUDGET_DEPT_CODE", this.BUDGET_DEPT_CODE));
		xml.append(CommonUtil.makeElement("BUDGET_DEPT_NAME", this.BUDGET_DEPT_NAME));
		xml.append(CommonUtil.makeElement("ACCOUNT_CODE", this.ACCOUNT_CODE));
		xml.append(CommonUtil.makeElement("ACCOUNT_NAME", this.ACCOUNT_NAME));
		xml.append(CommonUtil.makeElement("BUDGET_FLAG", this.BUDGET_FLAG));
		xml.append(CommonUtil.makeElement("WBS_CODE", this.WBS_CODE));
		xml.append(CommonUtil.makeElement("WBS_NAME", this.WBS_NAME));
		xml.append(CommonUtil.makeElement("SUPPLIER_CODE", this.SUPPLIER_CODE));
		xml.append(CommonUtil.makeElement("SUPPLIER_NAME", this.SUPPLIER_NAME));
		xml.append(CommonUtil.makeElement("PO_DATE", this.PO_DATE));
		xml.append(CommonUtil.makeElement("REQ_DELIVERY_DATE", this.REQ_DELIVERY_DATE));
		xml.append(CommonUtil.makeElement("STND_DELIVERY_DATE", this.STND_DELIVERY_DATE));
		xml.append(CommonUtil.makeElement("PO_QTY", this.PO_QTY));
		xml.append(CommonUtil.makeElement("BUYING_PRICE", this.BUYING_PRICE));
		xml.append(CommonUtil.makeElement("BUYING_AMOUNT", this.BUYING_AMOUNT));
		xml.append(CommonUtil.makeElement("BUYING_CURRENCY", this.BUYING_CURRENCY));
		xml.append(CommonUtil.makeElement("APPLY_CURRENCY", this.APPLY_CURRENCY));
		xml.append(CommonUtil.makeElement("APPLY_EXRT", this.APPLY_EXRT));
		xml.append(CommonUtil.makeElement("REQUESTER_NAME", this.REQUESTER_NAME));
		xml.append(CommonUtil.makeElement("REQUESTER_TEL", this.REQUESTER_TEL));
		xml.append(CommonUtil.makeElement("PO_CREATOR_NAME", this.PO_CREATOR_NAME));
		xml.append(CommonUtil.makeElement("PO_CREATOR_TEL", this.PO_CREATOR_TEL));
		xml.append(CommonUtil.makeElement("PO_CREATOR_EMAIL", this.PO_CREATOR_EMAIL));
		xml.append(CommonUtil.makeElement("PO_CREATOR_PRIVACY_POLICY", this.PO_CREATOR_PRIVACY_POLICY));
		xml.append(CommonUtil.makeElement("PO_CREATOR_PRIVACY_POLICY_DATE", this.PO_CREATOR_PRIVACY_POLICY_DATE));
		xml.append(CommonUtil.makeElement("DELIVERY_ZIP_NO", this.DELIVERY_ZIP_NO));
		xml.append(CommonUtil.makeElement("DELIVERY_ADDRESS", this.DELIVERY_ADDRESS));
		xml.append(CommonUtil.makeElement("DELIVERY_DETAIL_ADDRESS", this.DELIVERY_DETAIL_ADDRESS));
		xml.append(CommonUtil.makeElement("RECEIVER_NAME", this.RECEIVER_NAME));
		xml.append(CommonUtil.makeElement("RECEIVER_TEL", this.RECEIVER_TEL));
		xml.append(CommonUtil.makeElement("RECEIVER_HP_NO", this.RECEIVER_HP_NO));
		xml.append(CommonUtil.makeElement("RECEIVER_PRIVACY_POLICY", this.RECEIVER_PRIVACY_POLICY));
		xml.append(CommonUtil.makeElement("RECEIVER_PRIVACY_POLICY_DATE", this.RECEIVER_PRIVACY_POLICY_DATE));
		xml.append(CommonUtil.makeElement("REQ_INFO", this.REQ_INFO));
		xml.append(CommonUtil.makeElement("PO_REQ_DATE", this.PO_REQ_DATE));
		xml.append(CommonUtil.makeElement("PO_REQ_HMS", this.PO_REQ_HMS));
		xml.append(CommonUtil.makeElement("PROGRESS_STATUS", this.PROGRESS_STATUS));
		xml.append(CommonUtil.makeElement("ATTACH_NO", this.ATTACH_NO));
		xml.append(CommonUtil.makeElement("ATTACH_CNT", this.ATTACH_CNT));
		xml.append(CommonUtil.makeElement("CM_ID_1", this.CM_ID_1));
		xml.append(CommonUtil.makeElement("CM_ID_2", this.CM_ID_2));
		xml.append(CommonUtil.makeElement("CM_ID_3", this.CM_ID_3));
		xml.append(CommonUtil.makeElement("CM_ID_4", this.CM_ID_4));
		xml.append(CommonUtil.makeElement("CM_ID_5", this.CM_ID_5));
		xml.append(CommonUtil.makeElement("CUSTOM_YN", this.CUSTOM_YN));
		xml.append(CommonUtil.makeElement("SHIP_METHODS", this.SHIP_METHODS));
		xml.append(CommonUtil.makeElement("PLANT", this.PLANT));
		xml.append(CommonUtil.makeElement("LF_TYPE", this.LF_TYPE));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
