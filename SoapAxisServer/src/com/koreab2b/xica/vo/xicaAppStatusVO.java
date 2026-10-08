package com.koreab2b.xica.vo;

import java.util.List;

import com.koreab2b.common.CommonUtil;

public class xicaAppStatusVO {

	private String progSt;
	private String appvTpNum;
	List<xicaApprovalLine> appDetail;
	
	
	public String getProgSt() {
		return progSt;
	}
	public void setProgSt(String progSt) {
		this.progSt = progSt;
	}
	public String getAppvTpNum() {
		return appvTpNum;
	}
	public void setAppvTpNum(String appvTpNum) {
		this.appvTpNum = appvTpNum;
	}
	public List<xicaApprovalLine> getAppDetail() {
		return appDetail;
	}
	public void setAppDetail(List<xicaApprovalLine> appDetail) {
		this.appDetail = appDetail;
	}
	
	public String getXml() {
		
		StringBuffer xml = new StringBuffer();
		
		xml.append("         <arg0>\n");
		xml.append("<progSt>"+progSt+"</progSt>\n");
		xml.append("<appvTpNum>"+appvTpNum+"</appvTpNum>\n");
		
		for (xicaApprovalLine xicaAppDetail : appDetail) {
			xml.append(xicaAppDetail.getXml());
		}
		
		xml.append("         </arg0>\n");
		
		return xml.toString();
	}
	
}

