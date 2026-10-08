package com.koreab2b.mro.manager.login.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

public interface LoginDao {
	Login getLogin(String pUserId);
	SessionInfo getSessionInfo(String pUserId);
	String getIRSNo(Map<String,String>  pMap);
	String getPWD(String userId);
	String getLusrYn(String userId, String comCode);
	String getComCode(String userId);
	String getOldPasswordCheck(Map<String,String>  pMap);	
	String setUserPwdUpdate(Map<String,String>  pMap);
	String getRollYn(Map<String,String>  pMap);
	String setPunchoutRollInsert(Map<String,String>  pMap);
	String setPunchoutAdminRollInsert(Map<String,String>  pMap);
	String setPunchoutRollDel(Map<String,String>  pMap);
	String setPunchoutUserInsert(Map<String,String>  pMap);
	String setPunchoutUserUpdate(Map<String,String>  pMap);
	List<String> getRoleIdsByUserId(String pUserId);
	String getRedirectUrlByUserId(String pUserId, String pComCode);
	String setIkenSsoId(String pComCode, String pEmpNo);
	String setIkenSsoNm(String pComCode, String pEmpNo);
	String setIkenSsoPw(String pComCode, String pKitaId);
	void setSessionkey(String pSessionKey, String pKitaId);
	List<Map<String, String>> getSsoDomainList(String pComCode);
	
	String getEncryptedEmpNo(String pEmpNo);
	// 저장
	public String saveLogintime(Map<String,String>  formData);
	// 개인정보동의 
	public String saveInfoAgree(Map<String,String>  formData);
	
	public void saveLog(Map<String,Object> pMap);
	String updatePasswordSha(String pComCode, String pEmpNo);
	// 저장
	public String saveLoginErrorCnt(Map<String,String>  formData);
	// 회사_개인정보 갱신
	public String saveInfoUpdate(Map<String,String>  formData);
	// 로그인 회사_개인 정보 조회
	public List<Map<String,String>> selectLoginInfoList(Map<String,String> formData);
	String getIdValidCheck(Map<String,String>  pMap);
	// 로그인 추가인증 설정
	public String saveLoginAddiCertAgree(Map<String,String>  formData);
	// 로그인 ID 추가인증 여부 확인
	String getTwoFactorYn(Map<String,String>  pMap);
	// SMS 인증번호 확인
	String getOldCertSmsCheck(Map<String,String>  pMap);
	// SMS 인증번호 재전송
	String setCertSmsResend(Map<String,String>  pMap);
	// 성공로그인 이력
	public String saveLoginHist(Map<String,String>  formData);
	// 협력사 납품가능지역 설정
	public String saveDelyArea(Map<String,String>  formData);
	// 삼기SSO 로그인
	String setSamkeeSsoId(String pType, String pEmpNo);
	// 납기관리개선용 정보 수집
	public List<Map<String,String>> selectLoginInfoImsiList(Map<String,String> formData);
	// 납기관리개선용 정보 수정
	public String saveInfoImsiUpdate(Map<String,String>  formData);
}