package com.koreab2b.xica.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;

@XmlAccessorType(XmlAccessType.FIELD)
public class xicaApprovalLine {
	private String appSeqField;		    //결재순서
	private String appvId;				//결재자ID
	private String appUserIDField;		//결재자사번
	private String appvNm; 				//결재자명
	private String appOrgIDField;		//부서
	private String appvPostnNm;			//직급
	private String appDutyNmField;		//직책
	private String appvSt;				//결재상태(코드시트 참조)  2:결재요청,3:결재처리중,5:반려완료,6:결재완료,8:상신취소
	private String appvCmmt;			//결재 코멘트
	
	public String getAppSeqField() {
		return appSeqField;
	}
	public void setAppSeqField(String appSeqField) {
		this.appSeqField = appSeqField;
	}
	public String getAppvId() {
		return appvId;
	}
	public void setAppvId(String appvId) {
		this.appvId = appvId;
	}
	public String getAppUserIDField() {
		return appUserIDField;
	}
	public void setAppUserIDField(String appUserIDField) {
		this.appUserIDField = appUserIDField;
	}
	public String getAppvNm() {
		return appvNm;
	}
	public void setAppvNm(String appvNm) {
		this.appvNm = appvNm;
	}
	public String getAppOrgIDField() {
		return appOrgIDField;
	}
	public void setAppOrgIDField(String appOrgIDField) {
		this.appOrgIDField = appOrgIDField;
	}
	public String getAppvPostnNm() {
		return appvPostnNm;
	}
	public void setAppvPostnNm(String appvPostnNm) {
		this.appvPostnNm = appvPostnNm;
	}
	public String getAppDutyNmField() {
		return appDutyNmField;
	}
	public void setAppDutyNmField(String appDutyNmField) {
		this.appDutyNmField = appDutyNmField;
	}
	public String getAppvSt() {
		return appvSt;
	}
	public void setAppvSt(String appvSt) {
		this.appvSt = appvSt;
	}
	public String getAppvCmmt() {
		return appvCmmt;
	}
	public void setAppvCmmt(String appvCmmt) {
		this.appvCmmt = appvCmmt;
	}
	
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
	
		xml.append("<xicaApprovalLine>\n");
		xml.append("<appSeqField>"+appSeqField+"</appSeqField>\n");
		xml.append("<appvId>"+appvId+"</appvId>\n");
		xml.append("<appUserIDField>"+appUserIDField+"</appUserIDField>\n");
		xml.append("<appvNm>"+appvNm+"</appvNm>\n");
		xml.append("<appOrgIDField>"+appOrgIDField+"</appOrgIDField>\n");
		xml.append("<appvPostnNm>"+appvPostnNm+"</appvPostnNm>\n");
		xml.append("<appDutyNmField>"+appDutyNmField+"</appDutyNmField>\n");
		xml.append("<appvSt>"+appvSt+"</appvSt>\n");
		xml.append("<appvCmmt>"+appvCmmt+"</appvCmmt>\n");
		xml.append("</xicaApprovalLine>\n");
		
		return xml.toString();
	}
}
