package com.koreab2b.mro.manager.login.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("loginDao")
@Transactional
public class LoginDaoImpl implements LoginDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Login getLogin(String pUserId) {
		return sqlSessionTemplate.selectOne("login.getLogin", pUserId);
	}

	public SessionInfo getSessionInfo(String pUserId) {
		return sqlSessionTemplate.selectOne("login.getSessionInfo", pUserId);
	}
	
	public String getIRSNo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("login.getIRSNo",pMap);
	}
	
	public String getPWD(String userId){
		return sqlSessionTemplate.selectOne("login.getPWD",userId);
	}
	
	public String getLusrYn(String userId, String comCode){
		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("USER_ID", userId);
		pMap.put("COM_CODE", comCode);
		return sqlSessionTemplate.selectOne("login.getLusrYn",pMap);
	}
	public String getRollYn(Map<String,String>  pMap){		
		return sqlSessionTemplate.selectOne("login.getRollYn",pMap);
	}	
	public String getComCode(String userId){
		return sqlSessionTemplate.selectOne("login.getComCode",userId);
	}	
	public String getOldPasswordCheck(Map<String,String>  pMap){
		/*hash암호화*/
		String st_old_password =pMap.get("st_old_password");
		byte[] hashOldPassword_2 = st_old_password.getBytes();
		byte[] bszDigest_ = new byte[32];
		SecurHashAlgorithmUtil.SHA256_Encrpyt(hashOldPassword_2,hashOldPassword_2.length,bszDigest_);
		String toHashOldpassword = SecurHashAlgorithmUtil.getString(bszDigest_);
		pMap.put("st_old_password", toHashOldpassword);
		
		return sqlSessionTemplate.selectOne("login.getOldPasswordCheck",pMap);
	}
	
	public String setUserPwdUpdate(Map<String,String>  pMap){
		
		String _rtnMsg = "패스워드 수정이 완료되었습니다.   ";

		try{
			/*hash암호화*/
			String st_new_password = pMap.get("st_password");
			byte[] hashNewPassword = st_new_password.getBytes();
			byte[] bszDigest_new = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashNewPassword,hashNewPassword.length,bszDigest_new);
			String toHashNewpassword = SecurHashAlgorithmUtil.getString(bszDigest_new);
			pMap.put("st_password", toHashNewpassword);
			
			// 현재 비밀번호
			String st_old_password = pMap.get("st_old_password");
			byte[] hashOldPassword = st_old_password.getBytes();
			byte[] bszDigest_old = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashOldPassword,hashOldPassword.length,bszDigest_old);
			String toHashOldpassword = SecurHashAlgorithmUtil.getString(bszDigest_old);
			pMap.put("st_old_password", toHashOldpassword);
			
			String old_password_cnt = sqlSessionTemplate.selectOne("login.selectOldPassword", pMap);
			
			if("1".equals(old_password_cnt)){
				sqlSessionTemplate.update("login.setUserPwdUpdate",pMap);
			}else{
				_rtnMsg = "ERR_MATCH";				
			}
		}catch(Exception e){
			throw new RuntimeException("패스워드 수정에 실패 하였습니다. 담당자에게 연락 바랍니다. ");
		}
		return _rtnMsg;
	}	
	
	public String setPunchoutUserUpdate(Map<String,String>  pMap){
		
		String _rtnMsg = "OK";

		try{
			/*hash암호화*/
			String st_old_password =pMap.get("password");
			byte[] hashOldPassword_2 = st_old_password.getBytes();
			byte[] bszDigest_ = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashOldPassword_2,hashOldPassword_2.length,bszDigest_);
			String toHashOldpassword = SecurHashAlgorithmUtil.getString(bszDigest_);
			pMap.put("password", toHashOldpassword);
			
			sqlSessionTemplate.update("login.setPunchoutUserUpdate",pMap);

		}catch(Exception e){
			throw new RuntimeException("ERR");
		}
		return _rtnMsg;
	}	

	public String setPunchoutRollInsert(Map<String,String>  pMap){
		
		String _rtnMsg = "OK";

		try{
			sqlSessionTemplate.update("login.setPunchoutRollInsert",pMap);

		}catch(Exception e){
			throw new RuntimeException("ERR");
		}
		return _rtnMsg;
	}
	public String setPunchoutAdminRollInsert(Map<String,String>  pMap){
		
		String _rtnMsg = "OK";

		try{
			sqlSessionTemplate.update("login.setPunchoutAdminRollInsert",pMap);

		}catch(Exception e){
			throw new RuntimeException("ERR");
		}
		return _rtnMsg;
	}
	public String setPunchoutRollDel(Map<String,String>  pMap){
		
		String _rtnMsg = "OK";

		try{
			sqlSessionTemplate.update("login.setPunchoutRollDel",pMap);

		}catch(Exception e){
			throw new RuntimeException("ERR");
		}
		return _rtnMsg;
	}
	public String setPunchoutUserInsert(Map<String,String>  pMap){
		
		String _rtnMsg = "OK";

		try{
			/*hash암호화*/
			String st_old_password =pMap.get("password");
			byte[] hashOldPassword_2 = st_old_password.getBytes();
			byte[] bszDigest_ = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashOldPassword_2,hashOldPassword_2.length,bszDigest_);
			String toHashOldpassword = SecurHashAlgorithmUtil.getString(bszDigest_);
			pMap.put("password", toHashOldpassword);
			sqlSessionTemplate.update("login.setPunchoutUserInsert",pMap);

		}catch(Exception e){
			throw new RuntimeException("ERR");
		}
		return _rtnMsg;
	}
	
	public List<String> getRoleIdsByUserId(String pUserId) {
		return sqlSessionTemplate.selectList("login.getRoleIdsByUserId", pUserId);
	}
	
	public String getRedirectUrlByUserId(String pUserId, String pComCode){

		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("USER_ID", pUserId);
		pMap.put("COM_CODE", pComCode);
		return (String)sqlSessionTemplate.selectOne("login.getRedirectUrlByUserId",pMap);
	}
	
	public String setIkenSsoId(String pComCode, String pEmpNo){
		String grpCnt = "0";
		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("COM_CODE", pComCode);
		pMap.put("EMP_NO", pEmpNo);

		grpCnt = (String)sqlSessionTemplate.selectOne("login.getGrounpBoolean", pMap);
		
		if("KRCOWA0001".equals(pComCode)|| "KRCOWA0002".equals(pComCode) || "KRCOWA0003".equals(pComCode)
				|| "KRCOWA0004".equals(pComCode) || "KRCOWA0005".equals(pComCode) || "KRCOWA0006".equals(pComCode)
				|| "KRCOWA0007".equals(pComCode) || "KRCOWA0008".equals(pComCode) )
			return (String)sqlSessionTemplate.selectOne("login.setCowayIkenSsoId",pMap);
		else if ("KRKUMHG001".equals(pComCode)) {
			return (String)sqlSessionTemplate.selectOne("login.setCodIkenKumhSsoId",pMap);
		}
		else if ("KRSAMYG001".equals(pComCode)) {
			return (String)sqlSessionTemplate.selectOne("login.setCodIkenSyfSsoId",pMap);
		}
		else if (Integer.parseInt(grpCnt) > 0) {
			return (String)sqlSessionTemplate.selectOne("login.setCodIkenSsoId",pMap);
		}
		else if ("G".equals(pComCode.substring(6, 7))) {
			return (String)sqlSessionTemplate.selectOne("login.setGroupIkenSsoId",pMap);
		}
		else
			return (String)sqlSessionTemplate.selectOne("login.setIkenSsoId",pMap);
	};
	public String setIkenSsoNm(String pComCode, String pEmpNo){
		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("COM_CODE", pComCode);
		pMap.put("EMP_NO", pEmpNo);
		return (String)sqlSessionTemplate.selectOne("login.setIkenSsoNm",pMap);
	};	
	public String setIkenSsoPw(String pComCode, String pKitaId){
		Map<String,String> pMap =  new HashMap<String,String>();
		//pMap.put("COM_CODE", pComCode);
		pMap.put("KITA_ID", pKitaId);
		return (String)sqlSessionTemplate.selectOne("login.setIkenSsoPw",pMap);
	};
	
	public void setSessionkey(String pSessionKey, String pKitaId){
		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("SESSION_KEY", pSessionKey);
		pMap.put("KITA_ID", pKitaId);
		sqlSessionTemplate.update("login.setSessionkey",pMap);
	}

	@Override
	public List<Map<String, String>> getSsoDomainList(String pComCode) {
		return sqlSessionTemplate.selectList("login.getSsoDomainList", pComCode);
	}

	@Override
	public String getEncryptedEmpNo(String pEmpNo) {
		return sqlSessionTemplate.selectOne("login.getEncryptedEmpNo", pEmpNo);
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveLogintime(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveLogintime", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 로그인횟수 실패저장
	@SuppressWarnings("unchecked")
	public String saveLoginErrorCnt(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveLoginErrorCnt", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	@Override
	public void saveLog(Map<String, Object> pMap) {
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", pMap);
	}
	
	public String updatePasswordSha(String pComCode, String pEmpNo){
		List<Map<String,String>> list = null;
		Map<String,String> _dataDetailParam = null;
		list = sqlSessionTemplate.selectList("login.selectPasswordShaUserInfo", pEmpNo);
	    if(list.size() > 0){
			for(int z=0; z<list.size(); z++){
				Map<String,String> mp = (Map<String,String>)list.get(z);
				if(mp.get("PWD")  != null){
					String userId = mp.get("USER_ID");
					String userPw = mp.get("PWD");
					byte[] hashPassword_2 = userPw.getBytes();
					byte[] bszDigest = new byte[32];
					SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
					String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
					_dataDetailParam = new HashMap<String,String>() ;
					_dataDetailParam.put("USER_ID", userId);
					_dataDetailParam.put("PWD", toHashpassword);
					sqlSessionTemplate.update("login.updatePasswordShaUserInfo",_dataDetailParam);
				}
			}
	    }
	    
		return "";
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveInfoAgree(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveInfoAgree", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 회사_개인정보 저장
	@SuppressWarnings("unchecked")
	public String saveInfoUpdate(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			if("A".equals(formData.get("userType"))){ // 관리자 로그인 시 회사정보 수정
				sqlSessionTemplate.insert("login.saveIcomcmpyInfoUpdate", formData); // 회사 정보 수정				
				sqlSessionTemplate.insert("login.saveSuplinfo2InfoUpdate", formData); // 계약담당자 정보 수정
			}
			sqlSessionTemplate.insert("login.saveIcomlusrInfoUpdate", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 로그인 회사_개인 정보 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectLoginInfoList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("login.selectLoginInfoList", formData);
	}
	public String getIdValidCheck(Map<String,String>  pMap){
		/*hash암호화*/
		String st_old_password =pMap.get("password");
		byte[] hashOldPassword_2 = st_old_password.getBytes();
		byte[] bszDigest_ = new byte[32];
		SecurHashAlgorithmUtil.SHA256_Encrpyt(hashOldPassword_2,hashOldPassword_2.length,bszDigest_);
		String toHashOldpassword = SecurHashAlgorithmUtil.getString(bszDigest_);
		pMap.put("password", toHashOldpassword);
		return sqlSessionTemplate.selectOne("login.getIdValidCheck",pMap);
	}
	// 로그인 추가인증 설정
	@SuppressWarnings("unchecked")
	public String saveLoginAddiCertAgree(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveLoginAddiCertAgree", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 로그인 ID 추가인증 여부 확인
	public String getTwoFactorYn(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("login.getTwoFactorYn",pMap);
	}
	// SMS 인증번호 확인
	public String getOldCertSmsCheck(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("login.getOldCertSmsCheck",pMap);
	}
	// SMS 인증번호 재전송
	public String setCertSmsResend(Map<String,String>  pMap){
		String _rtnMsg = "Y";
		try {
			// 인증번호 생성
			Random rand = new Random();
	        String numStr = "";
	        
	        for(int i=0;i<6;i++) {
	            
	            //0~9 까지 난수 생성
	            String ran = Integer.toString(rand.nextInt(10));
	            numStr += ran;
	        }
	        pMap.put("TWO_FACTOR_SMS", numStr);
	        pMap.put("USER_ID", pMap.get("userId"));
	        // 인증번호 저장
			sqlSessionTemplate.update("main.setBuyerSmsCertUpdate", pMap);
			// SMS 전송
			sqlSessionTemplate.update("main.insertBuyerCertSms", pMap);
		} catch (Exception e) {
			_rtnMsg = "N";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 성공로그인 이력
	@SuppressWarnings("unchecked")
	public String saveLoginHist(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveLoginHist", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 협력사 납품가능지역 설정
	@SuppressWarnings("unchecked")
	public String saveDelyArea(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveDelyArea", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	// 삼기SSO 로그인
	public String setSamkeeSsoId(String pType, String pEmpNo){
		Map<String,String> pMap =  new HashMap<String,String>();
		pMap.put("TYPE", pType);
		pMap.put("EMP_NO", pEmpNo);
		List<Map<String,String>> list = null;
		String st_user_id = "";
		list = sqlSessionTemplate.selectList("login.setSamkeeSsoId", pMap);
		if(list.size() > 0){
			for(int k=0; k<list.size(); k++){
				Map<String,String> mp = (Map<String,String>)list.get(k);
				//max 값 아이디 가져와서 로그인 되도록 변경 
				st_user_id = CommonUtil.nvl(mp.get("USER_ID"),"");					
			}
		}
		return st_user_id;
	}

	// 납기관리개선용 정보 수집
	public List<Map<String,String>> selectLoginInfoImsiList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("login.selectLoginInfoImsiList", formData);
	}
	
	// 납기관리개선용 정보 수정
	public String saveInfoImsiUpdate(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("login.saveIcomlusrInfoImsiUpdate", formData);
			sqlSessionTemplate.insert("login.saveIcomlusrInfoImsiUpdate_multi", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
}
