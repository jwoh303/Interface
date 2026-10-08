package com.koreab2b.dongwha.vo;

import com.koreab2b.common.CommonUtil;

public class UserVO {

	private String EmpNo;
	private String EmpName;
	private String PositionName;
	private String DivCode;
	private String DivName;
	private String DeptCode;
	private String DeptName;
	private String TeamCode;
	private String TeamName;
	private String CompCd;
	private String BUTXT;
	private String JoinDt;
	private String RetireDt;
	private String WorkYN;
	private String RegiDate;
	private String CHIEF;
	private String MAIL;
	private String ZTEL;
	private String ADRES;
	
	public String getEmpNo() {
		return EmpNo;
	}
	public void setEmpNo(String empNo) {
		EmpNo = empNo;
	}
	public String getEmpName() {
		return EmpName;
	}
	public void setEmpName(String empName) {
		EmpName = empName;
	}
	public String getPositionName() {
		return PositionName;
	}
	public void setPositionName(String positionName) {
		PositionName = positionName;
	}
	public String getDivName() {
		return DivName;
	}
	public void setDivName(String divName) {
		DivName = divName;
	}
	public String getDeptName() {
		return DeptName;
	}
	public void setDeptName(String deptName) {
		DeptName = deptName;
	}
	public String getTeamName() {
		return TeamName;
	}
	public void setTeamName(String teamName) {
		TeamName = teamName;
	}
	public String getCompCd() {
		return CompCd;
	}
	public void setCompCd(String compCd) {
		CompCd = compCd;
	}
	public String getBUTXT() {
		return BUTXT;
	}
	public void setBUTXT(String bUTXT) {
		BUTXT = bUTXT;
	}
	public String getJoinDt() {
		return JoinDt;
	}
	public void setJoinDt(String joinDt) {
		JoinDt = joinDt;
	}
	public String getRetireDt() {
		return RetireDt;
	}
	public void setRetireDt(String retireDt) {
		RetireDt = retireDt;
	}
	public String getWorkYN() {
		return WorkYN;
	}
	public void setWorkYN(String workYN) {
		WorkYN = workYN;
	}
	public String getRegiDate() {
		return RegiDate;
	}
	public void setRegiDate(String regiDate) {
		RegiDate = regiDate;
	}
	public String getCHIEF() {
		return CHIEF;
	}
	public void setCHIEF(String cHIEF) {
		CHIEF = cHIEF;
	}
	public String getMAIL() {
		return MAIL;
	}
	public void setMAIL(String mAIL) {
		MAIL = mAIL;
	}
	public String getZTEL() {
		return ZTEL;
	}
	public void setZTEL(String zTEL) {
		ZTEL = zTEL;
	}
	public String getADRES() {
		return ADRES;
	}
	public void setADRES(String aDRES) {
		ADRES = aDRES;
	}
	public String getDivCode() {
		return DivCode;
	}
	public void setDivCode(String divCode) {
		DivCode = divCode;
	}
	public String getDeptCode() {
		return DeptCode;
	}
	public void setDeptCode(String deptCode) {
		DeptCode = deptCode;
	}
	public String getTeamCode() {
		return TeamCode;
	}
	public void setTeamCode(String teamCode) {
		TeamCode = teamCode;
	}
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("<arg0>\n");
		
		xml.append(CommonUtil.makeElement("EmpNo", this.EmpNo));
		xml.append(CommonUtil.makeElement("EmpName", this.EmpName));
		xml.append(CommonUtil.makeElement("PositionName", this.PositionName));
		xml.append(CommonUtil.makeElement("DivCode", this.DivCode));
		xml.append(CommonUtil.makeElement("DivName", this.DivName));
		xml.append(CommonUtil.makeElement("DeptCode", this.DeptCode));
		xml.append(CommonUtil.makeElement("DeptName", this.DeptName));
		xml.append(CommonUtil.makeElement("TeamCode", this.TeamCode));
		xml.append(CommonUtil.makeElement("TeamName", this.TeamName));
		xml.append(CommonUtil.makeElement("CompCd", this.CompCd));
		xml.append(CommonUtil.makeElement("BUTXT", this.BUTXT));
		xml.append(CommonUtil.makeElement("JoinDt", this.JoinDt));
		xml.append(CommonUtil.makeElement("RetireDt", this.RetireDt));
		xml.append(CommonUtil.makeElement("WorkYN", this.WorkYN));
		xml.append(CommonUtil.makeElement("RegiDate", this.RegiDate));
		xml.append(CommonUtil.makeElement("CHIEF", this.CHIEF));
		xml.append(CommonUtil.makeElement("MAIL", this.MAIL));
		xml.append(CommonUtil.makeElement("ZTEL", this.ZTEL));
		xml.append(CommonUtil.makeElement("ADRES", this.ADRES));


		xml.append("</arg0>\n");

		return xml.toString();
	}
}
