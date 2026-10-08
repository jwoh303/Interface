package com.koreab2b.mro.manager.login.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.login.dao.LoginDao;
import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.DateTimeUtil;

import crosscert.*;

@Service("loginService")
public class LoginServiceImpl implements LoginService{
	
	@Autowired
	private LoginDao loginDao;
	
	public Login getLogin(String pUserId) {
		return loginDao.getLogin(pUserId);
	}
	
	public SessionInfo getSessionInfo(String pUserId) {
		return loginDao.getSessionInfo(pUserId);
	}
	
	public String getIRSNo(Map<String,String>  pMap){
		return loginDao.getIRSNo(pMap);
	}
	
	public String getPWD(String userId){
		return loginDao.getPWD(userId);
	}
	public String getLusrYn(String userId, String comCode){
		return loginDao.getLusrYn(userId, comCode);
	}	
	public String getComCode(String userId){
		return loginDao.getComCode(userId);
	}
	/**
	 * 원문생성(hash)
	 * 본인확인
	 * 전자서명
	 * 서명시 서명원본을 구성하기 현재 시간을 구해옴.
	 * 구해진 현재시간에서 해쉬값을 추출함.
	 * @return
	 */
	public String getHashData(){
		String timestr=DateTimeUtil.getFormatString("yyyy-MM-dd-hh:mm:ss");
		
		 int nRet;
	    String Origin_data = "";
	    Hash hash = new Hash();
	    nRet = hash.GetHash(timestr.getBytes(), timestr.getBytes().length);
	    if(nRet==0){
	        Origin_data = new String(hash.contentbuf);
	    }else{
	        Origin_data = "abcdefghijklmnopqrstuvwxyz1234567890";
	    }
		
		return Origin_data;
	}
	
	/**
	 * 인증서 유효성 검사
	 * 
	 * @param signData
	 * @return
	 */
	public Map<String, String> getCertValidate(String signData, String getR, String ssn) {
		Map<String, String> result = new HashMap<String, String>();

		int nRet = 0;

		Base64 CBase64 = new Base64();
		nRet = CBase64.Decode(signData.getBytes(), signData.getBytes().length);

		if (nRet != 0) {
			result.put("errorCode", Integer.toString(CBase64.errcode));
			result.put("errorMsg", "서명값 Base64 Decode 결과 실패 [ 에러내용 : " + CBase64.errmessage  + " ]");
			return result;
		}

		Verifier CVerifier = new Verifier();
		nRet = CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);

		if (nRet != 0) {
			result.put("errorCode", Integer.toString(CVerifier.errcode));
			result.put("errorMsg", "전자서명 검증 결과 실패 [ 에러내용 : " + CVerifier.errmessage  + " ]");
			return result;
		}

		// 인증서 정보 추출 결과
		Certificate CCertificate = new Certificate();
		nRet = CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
		
		if (nRet != 0) {
			result.put("errorCode", Integer.toString(CVerifier.errcode));
			result.put("errorMsg", "인증서 추출 실패 [ 에러내용 : " + CVerifier.errmessage  + " ]");
			return result;
		}
		
		// 인증서 검증
		String policies = "";

		// 법인상호연동용(범용) //
		policies += "1.2.410.200004.5.2.1.1" + "|"; // 한국정보인증 법인
		policies += "1.2.410.200004.5.1.1.7" + "|"; // 한국증권전산 법인, 단체, 개인사업자
		policies += "1.2.410.200005.1.1.5" + "|"; // 금융결제원 법인, 임의단체, 개인사업자
		policies += "1.2.410.200004.5.3.1.1" + "|"; // 한국전산원 기관(국가기관 및 비영리기관)
		policies += "1.2.410.200004.5.3.1.2" + "|"; // 한국전산원 법인(국가기관 및 비영리기관을
													// 제외한 공공기관, 법인)
		policies += "1.2.410.200004.5.4.1.2" + "|"; // 한국전자인증 법인, 단체, 개인사업자
		policies += "1.2.410.200004.5.4.1.201" + "|"; // 한국전자인증 전자인증 법인 인터텟뱅킹용
		policies += "1.2.410.200012.1.1.3" + "|"; // 한국무역정보통신 법인
		policies += "1.2.410.200004.5.4.2.26" + "|"; // 한국전자인증 특정용 세무조사법
		policies +="1.2.410.200004.5.4.2.406"  + "|";          // 한국전자인증               전자인증 KEP전용인증서

		nRet = CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, policies, 0);
		
		if (nRet != 0) {
			result.put("errorCode", Integer.toBinaryString(CCertificate.errcode));
			result.put("errorMsg", "인증서 검증 실패 [ 에러내용 : " + CCertificate.errmessage  + " ]");
			return result;
		}
		
		//식별번호 검증
		nRet=CCertificate.VerifyVID(CVerifier.certbuf, CVerifier.certlen, getR.getBytes(), getR.length(), ssn);
		
		if (nRet == 0) {
			result.put("errorCode", "0000");
			result.put("errorMsg", "유효한 인증서");
		} else {
			result.put("errorCode", Integer.toBinaryString(CCertificate.errcode));
			result.put("errorMsg", "식별번호 검증 실패 [ 에러내용 : " + CCertificate.errmessage  + " ]");
		}

		return result;
	}
	public String getRollYn(Map<String,String>  pMap){
		return loginDao.getRollYn(pMap);
	};
	public String getOldPasswordCheck(Map<String,String>  pMap){
		return loginDao.getOldPasswordCheck(pMap);
	}
	
	public String setUserPwdUpdate(Map<String,String>  pMap){
		return loginDao.setUserPwdUpdate(pMap);
	};

	public String setPunchoutUserInsert(Map<String,String>  pMap){
		return loginDao.setPunchoutUserInsert(pMap);
	};
	
	public String setPunchoutRollInsert(Map<String,String>  pMap){
		return loginDao.setPunchoutRollInsert(pMap);
	};
	public String setPunchoutAdminRollInsert(Map<String,String>  pMap){
		return loginDao.setPunchoutAdminRollInsert(pMap);
	};
	public String setPunchoutRollDel(Map<String,String>  pMap){
		return loginDao.setPunchoutRollDel(pMap);
	};	
	public String setPunchoutUserUpdate(Map<String,String>  pMap){
		return loginDao.setPunchoutUserUpdate(pMap);
	};
	
	public List<String> getRoleIdsByUserId(String pUserId) {
		return loginDao.getRoleIdsByUserId(pUserId);
	}
	
	public String getRedirectUrlByUserId(String pUserId, String pComCode){
		return loginDao.getRedirectUrlByUserId(pUserId, pComCode);
	};
	
	public String setIkenSsoId(String pComCode, String pEmpNo){
		return loginDao.setIkenSsoId(pComCode, pEmpNo);
	};

	public String setIkenSsoNm(String pComCode, String pEmpNo){
		return loginDao.setIkenSsoNm(pComCode, pEmpNo);
	};
	
	public String setIkenSsoPw(String pComCode, String pKitaId){
		return loginDao.setIkenSsoPw(pComCode, pKitaId);
	};
	
	public void setSessionkey(String pSessionKey, String pKitaId){
		loginDao.setSessionkey(pSessionKey, pKitaId);
	}

	@Override
	public List<Map<String, String>> getSsoDomainList(String pComCode) {
		return loginDao.getSsoDomainList(pComCode);
	}

	@Override
	public String getEncryptedEmpNo(String pEmpNo) {
		return loginDao.getEncryptedEmpNo(pEmpNo);
	};
	// 로그인시간저장
	@Transactional
	public String saveLogintime(Map<String,String>  formData) {
		return loginDao.saveLogintime(formData);
	}

	@Override
	public void saveLog(Map<String, Object> pMap) {
		loginDao.saveLog(pMap);
	}	
	
	public String updatePasswordSha(String pComCode, String pEmpNo){
		return loginDao.updatePasswordSha(pComCode, pEmpNo);
	};
	// 개인정보 동의
	@Transactional
	public String saveInfoAgree(Map<String,String>  formData) {
		return loginDao.saveInfoAgree(formData);
	}
	// 로그인 실패시 횟수 저장
	@Transactional
	public String saveLoginErrorCnt(Map<String,String>  formData) {
		return loginDao.saveLoginErrorCnt(formData);
	}
	// 회사_개인정보 갱신
	@Transactional
	public String saveInfoUpdate(Map<String,String>  formData) {
		return loginDao.saveInfoUpdate(formData);
	}
	// 로그인 회사_개인 정보 조회
	@Transactional
	public List<Map<String,String>> getLoginInfoList(Map<String,String> formData) {
		return loginDao.selectLoginInfoList(formData);
	}
	public String getIdValidCheck(Map<String,String>  pMap){
		return loginDao.getIdValidCheck(pMap);
	}
	// 로그인 추가인증 설정
	@Transactional
	public String saveLoginAddiCertAgree(Map<String,String>  formData) {
		return loginDao.saveLoginAddiCertAgree(formData);
	}
	// 로그인 ID 추가인증 여부 확인
	public String getTwoFactorYn(Map<String,String>  pMap){
		return loginDao.getTwoFactorYn(pMap);
	}
	// SMS 인증번호 확인
	public String getOldCertSmsCheck(Map<String,String>  pMap){
		return loginDao.getOldCertSmsCheck(pMap);
	}
	// SMS 인증번호 재전송
	public String setCertSmsResend(Map<String,String>  pMap){
		return loginDao.setCertSmsResend(pMap);
	}
	// 성공로그인 이력
	@Transactional
	public String saveLoginHist(Map<String,String>  formData) {
		return loginDao.saveLoginHist(formData);
	}
	// 협력사 납품가능지역 설정
	@Transactional
	public String saveDelyArea(Map<String,String>  formData) {
		return loginDao.saveDelyArea(formData);
	}
	// 삼기로그인
	public String setSamkeeSsoId(String pType, String pEmpNo){
		return loginDao.setSamkeeSsoId(pType, pEmpNo);
	};
	// 납기관리개선용 정보 수집
	@Transactional
	public List<Map<String,String>> getLoginInfoImsiList(Map<String,String> formData) {
		return loginDao.selectLoginInfoImsiList(formData);
	}
	// 납기관리개선용 정보 수정
	@Transactional
	public String saveInfoImsiUpdate(Map<String,String>  formData) {
		return loginDao.saveInfoImsiUpdate(formData);
	}
}
