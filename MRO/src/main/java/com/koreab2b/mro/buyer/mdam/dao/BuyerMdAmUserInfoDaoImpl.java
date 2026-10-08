package com.koreab2b.mro.buyer.mdam.dao;

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

@Repository("buyerMdAmUserInfoDao")
@Transactional
public class BuyerMdAmUserInfoDaoImpl implements BuyerMdAmUserInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserInfoList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserInfoApproved", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserInfoRefer", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectAgreeList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserInfoAgree", formData);
	}
		
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mdam.pwdValidCheckBuyerMdAmUserInfo", formData);
	}
		
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _passMsg = "";
		try {
			//_passMsg = sqlSessionTemplate.selectOne("buyer.mdam.pwdValidCheckBuyerMdAmUserInfo", formData);
			_passMsg = "OK";
			if (_passMsg.equals("OK")) {
				
				if (formData.get("st_user_type").equals(formData.get("change_user_type"))) {
					formData.put("st_status", "C");
		        } else {
		        	formData.put("st_status", "R");
		        }
				String st_person_author = formData.get("st_person_author");
				if(st_person_author == null || "".equals(st_person_author)){
					formData.put("st_person_author", 	"");
				}
				String st_user_group = formData.get("st_user_group");
				if(st_user_group == null || "".equals(st_user_group)){
					formData.put("st_user_group", 	"");
				}
				String strPassword = formData.get("st_password");
				byte[] hashPassword_2 = strPassword.getBytes();
				byte[] bszDigest = new byte[32];
				SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
				String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
				
				formData.put("st_password", toHashpassword);
				sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmUserInfoPop",formData);
				
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
	
}
