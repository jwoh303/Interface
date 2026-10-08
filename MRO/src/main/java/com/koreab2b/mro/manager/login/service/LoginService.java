package com.koreab2b.mro.manager.login.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

public interface LoginService {
	Login getLogin(String pUserId);
	SessionInfo getSessionInfo(String pUserId);
	String getIRSNo(Map<String,String>  pMap);
	String getLusrYn(String userId, String comCode);
	String getRollYn(Map<String,String>  pMap);
	String getComCode(String userId);
	String getHashData();
	String getPWD(String userId);
	Map<String, String> getCertValidate(String signData, String getR, String ssn);
	String getOldPasswordCheck(Map<String,String>  pMap);
	String setUserPwdUpdate(Map<String,String>  pMap);
	String setPunchoutUserInsert(Map<String,String>  pMap);
	String setPunchoutUserUpdate(Map<String,String>  pMap);
	String setPunchoutRollInsert(Map<String,String>  pMap);
	String setPunchoutAdminRollInsert(Map<String,String>  pMap);
	String setPunchoutRollDel(Map<String,String>  pMap);
	List<String> getRoleIdsByUserId(String pUserId);
	String getRedirectUrlByUserId(String pUserId, String pComCode);
	String setIkenSsoId(String pComCode, String pEmpNo);
	String setIkenSsoNm(String pComCode, String pEmpNo);
	String setIkenSsoPw(String pComCode, String pKitaId);
	void setSessionkey(String pSessionKey, String pKitaId);
	List<Map<String, String>> getSsoDomainList(String pComCode);
	String getEncryptedEmpNo(String empNo);
	public String saveLogintime(Map<String,String> formData);
	public String saveInfoAgree(Map<String,String> formData);
	public void saveLog(Map<String,Object> pMap);
	String updatePasswordSha(String pComCode, String pEmpNo);
	public String saveLoginErrorCnt(Map<String,String> formData);
	public String saveInfoUpdate(Map<String,String> formData);
	public List<Map<String,String>> getLoginInfoList(Map<String,String> formData);
	String getIdValidCheck(Map<String,String>  pMap);
	public String saveLoginAddiCertAgree(Map<String,String> formData);
	String getTwoFactorYn(Map<String,String>  pMap);
	String getOldCertSmsCheck(Map<String,String>  pMap);
	String setCertSmsResend(Map<String,String>  pMap);
	public String saveLoginHist(Map<String,String> formData);
	public String saveDelyArea(Map<String,String> formData);
	//삼기 SSO 로그인
	String setSamkeeSsoId(String pType, String pEmpNo);
	public List<Map<String,String>> getLoginInfoImsiList(Map<String,String> formData);
	public String saveInfoImsiUpdate(Map<String,String> formData);
}

