package com.koreab2b.mro.seller.mdam.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("sellerMdAmUserInfoDao")
@Transactional
public class SellerMdAmUserInfoDaoImpl implements SellerMdAmUserInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdAmUserInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdam.selectSellerMdAmUserInfoList", formData);
	}
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("seller.mdam.pwdValidCheckSellerMdAmUserInfoList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _passMsg = "";
		try {
			_passMsg =  "OK";
			if (_passMsg.equals("OK")) {
				sqlSessionTemplate.update("seller.mdam.updateSellerMdAmUserInfoList", formData);
				
				// Admin사용자 -> 일반사용자
				if (formData.get("st_user_type").equals("A") && formData.get("change_user_type").equals("U")) {
					Map<String, String> _pMap = new HashMap<String, String>();
		        	
					_pMap.put("COM_CODE", formData.get("st_com_code"));
					_pMap.put("USER_ID", formData.get("st_user_id"));
					
					sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap);
				}
				
			} else {
				_rtnMsg = _passMsg;
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 정보 수정이 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 비밀번호변경
	public String updateSellerMdAmUsePwd(Map<String,String> formData) {
		String _rtnMsg = "OK";
		try {
			Map<String, String> _pMap = new HashMap<String, String>();

			// 변경할 비밀번호
			String strPassword = formData.get("st_password");
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);

			// 현재 비밀번호
			String strPasswordPresent = formData.get("st_password_present");
			byte[] hashPassword_pre = strPasswordPresent.getBytes();
			byte[] bszDigest_pre = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_pre,hashPassword_pre.length,bszDigest_pre);
			String toHashpassword_pre = SecurHashAlgorithmUtil.getString(bszDigest_pre);

			_pMap.put("COM_CODE", formData.get("st_com_code"));
			_pMap.put("USER_ID", formData.get("st_user_id"));
			_pMap.put("PSW", toHashpassword);
			_pMap.put("PSW_PRE", toHashpassword_pre);

			String pre_password_cnt = sqlSessionTemplate.selectOne("seller.mdam.selectSellerMdAmUsePwd", _pMap);

			if("1".equals(pre_password_cnt)){
				sqlSessionTemplate.update("seller.mdam.updateSellerMdAmUsePwd", _pMap);
			}else{
				_rtnMsg = "ERR_MATCH";
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("패스워드 변경에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 비밀번호변경 v2 (현재 비밀번호와 동일 방지 검증 추가)
	public String updateSellerMdAmUsePwd_v2(Map<String,String> formData) {
		String _rtnMsg = "OK";
		try {
			Map<String, String> _pMap = new HashMap<String, String>();

			// 변경할 비밀번호
			String strPassword = formData.get("st_password");
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);

			// 현재 비밀번호
			String strPasswordPresent = formData.get("st_password_present");
			byte[] hashPassword_pre = strPasswordPresent.getBytes();
			byte[] bszDigest_pre = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_pre,hashPassword_pre.length,bszDigest_pre);
			String toHashpassword_pre = SecurHashAlgorithmUtil.getString(bszDigest_pre);

			// ★ 신규 검증: 현재 비밀번호와 새 비밀번호가 동일한지 체크
			if(toHashpassword_pre.equals(toHashpassword)){
				return "ERR_SAME_PASSWORD";
			}

			_pMap.put("COM_CODE", formData.get("st_com_code"));
			_pMap.put("USER_ID", formData.get("st_user_id"));
			_pMap.put("PSW", toHashpassword);
			_pMap.put("PSW_PRE", toHashpassword_pre);

			String pre_password_cnt = sqlSessionTemplate.selectOne("seller.mdam.selectSellerMdAmUsePwd", _pMap);

			if("1".equals(pre_password_cnt)){
				sqlSessionTemplate.update("seller.mdam.updateSellerMdAmUsePwd", _pMap);
			}else{
				_rtnMsg = "ERR_MATCH";
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("패스워드 변경에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
