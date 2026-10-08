package com.koreab2b.mro.manager.login.domain;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

@SuppressWarnings("serial")
public class SessionInfo  implements Serializable{
	private String userId;
	private String userNameLoc;
	private String email;
	private String comType;
	private String userType;
	private String comCode;
	private String BusinessCond; 
	private String mPhone;
	private String tel;
	private String fax;
	
	/* CEJ 추가 2014.5.12 */
	private String usingCatalType;
	private String bycaComorgCode;
	private String department;
	private String position;
	private String imgViewFlag;
	private String budgetFlag;
	private String role;	 
	private String userAuth;
	
	private String userNameEng;
    private String country;
    private String departmentName;
    private String status;
    private String delyToLocation;
    private String delyToLocationCodeName;
    private String delyToLocationName;
    private String purchaseDept;
    private String purchaseDeptName;
    private String zipCode;
    private String personAuthor;
    private String rowCnt;
    private String comNameEng;
    private String comNameLoc;
    private String addressLoc;
    private String hpAddress;
    private String agentOpenFlag;
    private String bycaComorgLevel;
    private String userGroup;
    private String pwdStatus;
    private String ciImage;
    private String whAdmin;
	private String password;
    private String decode_password; // 암호 디코드
    private String office_yn; // 운영사인대 고객사로 로그인 가능자
    private String ikenSessionkey;
    private String accessComorgLevel;
    private String empNo;
    private String lang; //로그인 언어설정
    private String passwordType; //PASSWORD_TYPE='S'인 사용자는 초기패스워드 발급자이며, 패스워드를 변경해야 로그인 가능.
    private String lastLoginDate; //마지막 로그인일시
    private String twoFactorYn; //로그인 추가인증 여부
    private String prMngFlag;//고객사 주문전체 권한부여
    private String chgInfoPwdYn; //개인정보변경 추가인증 여부
    private String kepAdmIpList; // 운영사 관리자메뉴 보이는 통제 IP리스트
    private String ownOfficeYn; //해당 계정의 office_yn
    
	// 나의 메뉴 LIST ( BUYER : 고객사에서 사용 )
    private List<Map<String, String>> myMenuList;
    
	public List<Map<String, String>> getMyMenuList() {
		return myMenuList;
	}
	public void setMyMenuList(List<Map<String, String>> pMyMenuList) {
		myMenuList = pMyMenuList;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String pUserId) {
		userId = CommonUtil.nvl(pUserId);
	}
	public String getUserNameLoc() {
		return userNameLoc;
	}
	public void setUserNameLoc(String pUserNameLoc) {
		userNameLoc = CommonUtil.nvl(pUserNameLoc);
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String pEmail) {
		email = CommonUtil.nvl(pEmail);
	}
	public String getComType() {
		return comType;
	}
	public void setComType(String pComType) {
		comType = CommonUtil.nvl(pComType);
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String pUserType) {
		userType = CommonUtil.nvl(pUserType);
	}
	public String getComCode() {
		return comCode;
	}
	public void setComCode(String pComCode) {
		comCode = CommonUtil.nvl(pComCode);
	}
	public String getBusinessCond() {
		return BusinessCond;
	}
	public void setBusinessCond(String pBusinessCond) {
		BusinessCond = CommonUtil.nvl(pBusinessCond);
	}
	public String getmPhone() {
		return mPhone;
	}
	public void setmPhone(String pMPhone) {
		mPhone = CommonUtil.nvl(pMPhone);
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String pTel) {
		tel = CommonUtil.nvl(pTel);
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String pFax) {
		fax = CommonUtil.nvl(pFax);
	}
	public String getUsingCatalType() {
		return usingCatalType;
	}
	public void setUsingCatalType(String pUsingCatalType) {
		usingCatalType = CommonUtil.nvl(pUsingCatalType);
	}
	public String getBycaComorgCode() {
		return bycaComorgCode;
	}
	public void setBycaComorgCode(String pBycaComorgCode) {
		bycaComorgCode = CommonUtil.nvl(pBycaComorgCode);
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String pDepartment) {
		department = CommonUtil.nvl(pDepartment);
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String pPosition) {
		position = CommonUtil.nvl(pPosition);
	}
	public String getImgViewFlag() {
		return imgViewFlag;
	}
	public void setImgViewFlag(String pImgViewFlag) {
		imgViewFlag = CommonUtil.nvl(pImgViewFlag);
	}
	public String getBudgetFlag() {
		return budgetFlag;
	}
	public void setBudgetFlag(String pBudgetFlag) {
		budgetFlag = CommonUtil.nvl(pBudgetFlag);
	}
	public String getRole() {
		return role;
	}
	public void setRole(String pRole) {
		role = CommonUtil.nvl(pRole);
	}
	public String getUserAuth() {
		return userAuth;
	}
	public void setUserAuth(String pUserAuth) {
		userAuth = CommonUtil.nvl(pUserAuth);
	}
	public String getUserNameEng() {
		return userNameEng;
	}
	public void setUserNameEng(String pUserNameEng) {
		userNameEng = CommonUtil.nvl(pUserNameEng);
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String pCountry) {
		country = CommonUtil.nvl(pCountry);
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public void setDepartmentName(String pDepartmentName) {
		departmentName = CommonUtil.nvl(pDepartmentName);
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String pStatus) {
		status = CommonUtil.nvl(pStatus);
	}
	public String getDelyToLocation() {
		return delyToLocation;
	}
	public void setDelyToLocation(String pDelyToLocation) {
		delyToLocation = CommonUtil.nvl(pDelyToLocation);
	}
	
	public String getDelyToLocationCodeName() {
		return delyToLocationCodeName;
	}
	public void setDelyToLocationCodeName(String pDelyToLocationCodeName) {
		delyToLocationCodeName = CommonUtil.nvl(pDelyToLocationCodeName);
	}
	
	public String getDelyToLocationName() {
		return delyToLocationName;
	}
	public void setDelyToLocationName(String pDelyToLocationName) {
		delyToLocationName = CommonUtil.nvl(pDelyToLocationName);
	}
	public String getPurchaseDept() {
		return purchaseDept;
	}
	public void setPurchaseDept(String pPurchaseDept) {
		purchaseDept = CommonUtil.nvl(pPurchaseDept);
	}
	public String getPurchaseDeptName() {
		return purchaseDeptName;
	}
	public void setPurchaseDeptName(String pPurchaseDeptName) {
		purchaseDeptName = CommonUtil.nvl(pPurchaseDeptName);
	}
	public String getZipCode() {
		return zipCode;
	}
	public void setZipCode(String pZipCode) {
		zipCode = CommonUtil.nvl(pZipCode);
	}
	public String getPersonAuthor() {
		return personAuthor;
	}
	public void setPersonAuthor(String pPersonAuthor) {
		personAuthor = CommonUtil.nvl(pPersonAuthor);
	}
	public String getRowCnt() {
		return rowCnt;
	}
	public void setRowCnt(String pRowCnt) {
		rowCnt = CommonUtil.nvl(pRowCnt);
	}
	public String getComNameEng() {
		return comNameEng;
	}
	public void setComNameEng(String pComNameEng) {
		comNameEng = pComNameEng;
	}
	public String getComNameLoc() {
		return comNameLoc;
	}
	public void setComNameLoc(String pComNameLoc) {
		comNameLoc = CommonUtil.nvl(pComNameLoc);
	}
	public String getAddressLoc() {
		return addressLoc;
	}
	public void setAddressLoc(String pAddressLoc) {
		addressLoc = CommonUtil.nvl(pAddressLoc);
	}
	public String getHpAddress() {
		return hpAddress;
	}
	public void setHpAddress(String pHpAddress) {
		hpAddress = CommonUtil.nvl(pHpAddress);
	}
	public String getAgentOpenFlag() {
		return agentOpenFlag;
	}
	public void setAgentOpenFlag(String pAgentOpenFlag) {
		agentOpenFlag = CommonUtil.nvl(pAgentOpenFlag);
	}
	public String getBycaComorgLevel() {
		return bycaComorgLevel;
	}
	public void setBycaComorgLevel(String pBycaComorgLevel) {
		bycaComorgLevel = CommonUtil.nvl(pBycaComorgLevel);
	}
	public String getUserGroup() {
		return userGroup;
	}
	public void setUserGroup(String pUserGroupl) {
		userGroup = CommonUtil.nvl(pUserGroupl);
	}
	public String getPwdStatus() {
		return pwdStatus;
	}
	public void setPwdStatus(String pPwdStatus) {
		pwdStatus = pPwdStatus;
	}
	public String getCiImage() {
		return ciImage;
	}
	public void setCiImage(String pCiImage) {
		ciImage = pCiImage;
	}
	public String getWhAdmin() {
		return whAdmin;
	}
	public void setWhAdmin(String pWhAdmin) {
		whAdmin = pWhAdmin;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String pPassword) {
		password = pPassword;
	}	
    public String getDecode_password() {
		return decode_password;
	}
	public void setDecode_password(String pDecode_password) {
		decode_password = pDecode_password;
	}
	public String getOffice_yn() {
		return office_yn;
	}
	public void setOffice_yn(String pOffice_yn) {
		office_yn = pOffice_yn;
	}
    public String getIkenSessionkey() {
		return ikenSessionkey;
	}
	public void setIkenSessionkey(String pSessionkey) {
		ikenSessionkey = pSessionkey;
	}
	public String getAccessComorgLevel() {
		return accessComorgLevel;
	}
	public void setAccessComorgLevel(String pAccessComorgLevel) {
		accessComorgLevel = pAccessComorgLevel;
	}
	public String getEmpNo() {
		return empNo;
	}
	public void setEmpNo(String pEmpNo) {
		empNo = pEmpNo;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String pLang) {
		lang = pLang;
	}
	public String getPasswordType() {
		return passwordType;
	}
	public void setpPasswordType(String pPasswordType) {
		passwordType = pPasswordType;
	}
	public String getLastLoginDate() {
		return lastLoginDate;
	}
	public void setLastLoginDate(String pLastLoginDate) {
		lastLoginDate = pLastLoginDate;
	}
	public String getTwoFactorYn() {
		return twoFactorYn;
	}
	public void setTwoFactorYn(String pTwoFactorYn) {
		twoFactorYn = pTwoFactorYn;
	}
	public String getPrMngFlag() {
		return prMngFlag;
	}
	public void setPrMngFlag(String st_prMngFlag) {
		prMngFlag = st_prMngFlag;
	}
	public String getChgInfoPwdYn() {
		return chgInfoPwdYn;
	}
	public void setChgInfoPwdYn(String pChgInfoPwdYn) {
		chgInfoPwdYn = pChgInfoPwdYn;
	}
	public String getKepAdmIpList() {
		return kepAdmIpList;
	}
	public void setKepAdmIpList(String pKepAdmIpList) {
		kepAdmIpList = pKepAdmIpList;
	}
	public String getOwnOfficeYn() {
		return ownOfficeYn;
	}
	public void setOwnOfficeYn(String ownOfficeYn) {
		this.ownOfficeYn = ownOfficeYn;
	}
}