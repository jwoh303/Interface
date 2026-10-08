package com.koreab2b.mro.manager.login.domain;

import java.io.Serializable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("serial")
public class Login implements Serializable {

	private static final Logger LOGGER = LoggerFactory.getLogger(Login.class);

	private String userId;
	private String password;
	private String status;
	private String userType;
	private String changeUserType;
	private String comType;
	private String pageFlag;
	private String businessCond;
	private String comCode;
	private String LogInErrorCnt;
	private String password_type;
	private String two_factor_yn;
	private String dely_area;
	private String cmpy_status;
	private String pwd_status;
	
	/* 결재상신 메일 관련 sso 처리 */
	private String st_gj_user_id;
	private String st_gw_no;
	private String st_page_flag;
	private String st_gj_type;
	private String st_gubun;
	/* 결재상신 메일 관련 sso 처리 */ 

	public String getStatus() {
		return status;
	}

	public String getSt_gj_user_id() {
		return st_gj_user_id;
	}

	public void setSt_gj_user_id(String pSt_gj_user_id) {
		st_gj_user_id = pSt_gj_user_id;
	}

	public String getSt_gw_no() {
		return st_gw_no;
	}

	public void setSt_gw_no(String pSt_gw_no) {
		st_gw_no = pSt_gw_no;
	}

	public String getSt_page_flag() {
		return st_page_flag;
	}

	public void setSt_page_flag(String pSt_page_flag) {
		st_page_flag = pSt_page_flag;
	}

	public String getSt_gj_type() {
		return st_gj_type;
	}

	public void setSt_gj_type(String pSt_gj_type) {
		st_gj_type = pSt_gj_type;
	}
	
	public void setStatus(String pStatus) {
		status = pStatus;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String pUserId) {
		userId = pUserId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String pPassword) {
		password = pPassword;
	}
	
	public String getUserType() {
		return userType;
	}

	public void setUserType(String pUserType) {
		userType = pUserType;
	}

	public String getChangeUserType() {
		return changeUserType;
	}

	public void setChangeUserType(String pChangeUserType) {
		changeUserType = pChangeUserType;
	}
	
	public String getComType() {
		return comType;
	}

	public void setComType(String pComType) {
		comType = pComType;
	}

	public String getPageFlag() {
		return pageFlag;
	}

	public void setPageFlag(String pPageFlag) {
		pageFlag = pPageFlag;
	}

	public String getBusinessCond() {
		return businessCond;
	}

	public void setBusinessCond(String pBusinessCond) {
		businessCond = pBusinessCond;
	}

	public String getComCode() {
		return comCode;
	}

	public String getLogInErrorCnt() {
		return LogInErrorCnt;
	}
	
	public String getPassword_type() {
		return password_type;
	}
	
	public void setComCode(String pComCode) {
		comCode = pComCode;
	}

	public String getTwoFactorYn() {
		return two_factor_yn;
	}

	public void setTwoFactorYn(String pTwoFactorYn) {
		two_factor_yn = pTwoFactorYn;
	}
	
	public String getDelyArea() {
		return dely_area;
	}

	public void setDelyArea(String pDelyArea) {
		dely_area = pDelyArea;
	}
	
	public boolean comfirmUserId(Login pLogin) {

		LOGGER.debug("파라미터 사용자  : {}", pLogin);

		if (pLogin == null) {
			return false;
		}

		LOGGER.debug("파라미터 사용자 아이디 : {}", pLogin.getUserId());
		LOGGER.debug("멤버변수 사용자 아이디 : {}", userId);

		if (userId.equals(pLogin.getUserId())) {
			return true;
		}

		return false;
	}

	public boolean comfirmPassword(Login pLogin) {
		
		LOGGER.debug("파라미터 사용자  : {}", pLogin);
		
		if (pLogin == null) {
			return false;
		}
		if (password.equals(pLogin.getPassword())) {
			return true;
		}

		return false;
	}
	
	public String getCmpy_status() {
		return cmpy_status;
	}

	public void setCmpy_status(String pCmpy_status) {
		cmpy_status = pCmpy_status;
	}

	public String getPwd_status() {
		return pwd_status;
	}

	public void setPwd_status(String pwd_status) {
		this.pwd_status = pwd_status;
	}
	
	public String getSt_gubun() {
		return st_gubun;
	}

	public void setSt_gubun(String pSt_gubun) {
		st_gubun = pSt_gubun;
	}

}
