package com.koreab2b.rfq.vo;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class ItemConfirmVO {
	private String processType;
	private String vendorReqNo;
	private String itemCode;
	private String categoryId1;
	private String categoryName1;
	private String categoryId2;
	private String categoryName2;
	private String categoryId3;
	private String categoryName3;
	private String categoryId4;
	private String categoryName4;
	private String companyCode;
	private String incoterms;
	private String vendorItemCode;
	private String confirmType;
	private String rejectReason;
	private String comments;
	private String cmId1;
	private String cmId2;
	private String cmId3;
	private String cmId4;
	private String cmId5;
	private String cmId6;
	private String cmId7;
	private String cmId8;
	private String cmId9;
	private String cmId10;
	private String secReqNo;
	private String unitCode;
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

	public String getProcessType() {
		return processType;
	}
	public void setProcessType(String processType) {
		this.processType = processType;
	}
	public String getVendorReqNo() {
		return vendorReqNo;
	}
	public void setVendorReqNo(String vendorReqNo) {
		this.vendorReqNo = vendorReqNo;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getCategoryId1() {
		return categoryId1;
	}
	public void setCategoryId1(String categoryId1) {
		this.categoryId1 = categoryId1;
	}
	public String getCategoryName1() {
		return categoryName1;
	}
	public void setCategoryName1(String categoryName1) {
		this.categoryName1 = categoryName1;
	}
	public String getCategoryId2() {
		return categoryId2;
	}
	public void setCategoryId2(String categoryId2) {
		this.categoryId2 = categoryId2;
	}
	public String getCategoryName2() {
		return categoryName2;
	}
	public void setCategoryName2(String categoryName2) {
		this.categoryName2 = categoryName2;
	}
	public String getCategoryId3() {
		return categoryId3;
	}
	public void setCategoryId3(String categoryId3) {
		this.categoryId3 = categoryId3;
	}
	public String getCategoryName3() {
		return categoryName3;
	}
	public void setCategoryName3(String categoryName3) {
		this.categoryName3 = categoryName3;
	}
	public String getCategoryId4() {
		return categoryId4;
	}
	public void setCategoryId4(String categoryId4) {
		this.categoryId4 = categoryId4;
	}
	public String getCategoryName4() {
		return categoryName4;
	}
	public void setCategoryName4(String categoryName4) {
		this.categoryName4 = categoryName4;
	}
	public String getCompanyCode() {
		return companyCode;
	}
	public void setCompanyCode(String companyCode) {
		this.companyCode = companyCode;
	}
	public String getIncoterms() {
		return incoterms;
	}
	public void setIncoterms(String incoterms) {
		this.incoterms = incoterms;
	}
	public String getVendorItemCode() {
		return vendorItemCode;
	}
	public void setVendorItemCode(String vendorItemCode) {
		this.vendorItemCode = vendorItemCode;
	}
	public String getConfirmType() {
		return confirmType;
	}
	public void setConfirmType(String confirmType) {
		this.confirmType = confirmType;
	}
	public String getRejectReason() {
		return rejectReason;
	}
	public void setRejectReason(String rejectReason) {
		this.rejectReason = rejectReason;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getCmId1() {
		return cmId1;
	}
	public void setCmId1(String cmId1) {
		this.cmId1 = cmId1;
	}
	public String getCmId2() {
		return cmId2;
	}
	public void setCmId2(String cmId2) {
		this.cmId2 = cmId2;
	}
	public String getCmId3() {
		return cmId3;
	}
	public void setCmId3(String cmId3) {
		this.cmId3 = cmId3;
	}
	public String getCmId4() {
		return cmId4;
	}
	public void setCmId4(String cmId4) {
		this.cmId4 = cmId4;
	}
	public String getCmId5() {
		return cmId5;
	}
	public void setCmId5(String cmId5) {
		this.cmId5 = cmId5;
	}
	public String getCmId6() {
		return cmId6;
	}
	public void setCmId6(String cmId6) {
		this.cmId6 = cmId6;
	}
	public String getCmId7() {
		return cmId7;
	}
	public void setCmId7(String cmId7) {
		this.cmId7 = cmId7;
	}
	public String getCmId8() {
		return cmId8;
	}
	public void setCmId8(String cmId8) {
		this.cmId8 = cmId8;
	}
	public String getCmId9() {
		return cmId9;
	}
	public void setCmId9(String cmId9) {
		this.cmId9 = cmId9;
	}
	public String getCmId10() {
		return cmId10;
	}
	public void setCmId10(String cmId10) {
		this.cmId10 = cmId10;
	}
	public String getSecReqNo() {
		return secReqNo;
	}
	public void setSecReqNo(String secReqNo) {
		this.secReqNo = secReqNo;
	}
	public String getUnitCode() {
		return unitCode;
	}
	public void setUnitCode(String unitCode) {
		this.unitCode = unitCode;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		xml.append("<arg0>\n");
		xml.append(CommonUtil.makeElement("processType", this.processType));
		xml.append(CommonUtil.makeElement("vendorReqNo", this.vendorReqNo));
		xml.append(CommonUtil.makeElement("itemCode", this.itemCode));
		xml.append(CommonUtil.makeElement("categoryId1", this.categoryId1));
		xml.append(CommonUtil.makeElement("categoryName1", this.categoryName1));
		xml.append(CommonUtil.makeElement("categoryId2", this.categoryId2));
		xml.append(CommonUtil.makeElement("categoryName2", this.categoryName2));
		xml.append(CommonUtil.makeElement("categoryId3", this.categoryId3));
		xml.append(CommonUtil.makeElement("categoryName3", this.categoryName3));
		xml.append(CommonUtil.makeElement("categoryId4", this.categoryId4));
		xml.append(CommonUtil.makeElement("categoryName4", this.categoryName4));
		xml.append(CommonUtil.makeElement("companyCode", this.companyCode));
		xml.append(CommonUtil.makeElement("incoterms", this.incoterms));
		xml.append(CommonUtil.makeElement("vendorItemCode", this.vendorItemCode));
		xml.append(CommonUtil.makeElement("confirmType", this.confirmType));
		xml.append(CommonUtil.makeElement("rejectReason", this.rejectReason));
		xml.append(CommonUtil.makeElement("comments", this.comments));
		xml.append(CommonUtil.makeElement("cmId1", this.cmId1));
		xml.append(CommonUtil.makeElement("cmId2", this.cmId2));
		xml.append(CommonUtil.makeElement("cmId3", this.cmId3));
		xml.append(CommonUtil.makeElement("cmId4", this.cmId4));
		xml.append(CommonUtil.makeElement("cmId5", this.cmId5));
		xml.append(CommonUtil.makeElement("cmId6", this.cmId6));
		xml.append(CommonUtil.makeElement("cmId7", this.cmId7));
		xml.append(CommonUtil.makeElement("cmId8", this.cmId8));
		xml.append(CommonUtil.makeElement("cmId9", this.cmId9));
		xml.append(CommonUtil.makeElement("cmId10", this.cmId10));
		xml.append(CommonUtil.makeElement("secReqNo", this.secReqNo));
		xml.append(CommonUtil.makeElement("unitCode", this.unitCode));
		xml.append("</arg0>\n");
		
		return xml.toString();
	}
}
