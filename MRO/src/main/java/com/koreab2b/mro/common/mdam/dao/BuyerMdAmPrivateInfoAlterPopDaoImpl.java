package com.koreab2b.mro.common.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("buyerMdAmPrivateInfoAlterPopDao")
@Transactional
public class BuyerMdAmPrivateInfoAlterPopDaoImpl implements BuyerMdAmPrivateInfoAlterPopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmPrivateInfoAlterPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdam.selectBuyerMdAmPrivateInfoAlterPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdam.selectBuyerMdAmPrivateInfoAlterApproved", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdam.selectBuyerMdAmPrivateInfoAlterRefer", formData);
	}

	// 조회 - 기본 결재경로의 결재/참조/합의 멤버 통합 (GUBUN IN ('C','R','H'))
	public List<Map<String,String>> selectDefaultApprovalLineMembers(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdam.selectDefaultApprovalLineMembers", formData);
	}
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdam.pwdValidCheckBuyerMdAmPrivateInfoAlterPop", formData);
	}
		
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _passMsg = "";
		try {
			_passMsg = 	"OK";
			if (_passMsg.equals("OK")) {
				String strPassword = formData.get("st_password");
				if(strPassword != null){
					byte[] hashPassword_2 = strPassword.getBytes();
					byte[] bszDigest = new byte[32];
					SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
					String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
					formData.put("st_password", toHashpassword);
				}			
				sqlSessionTemplate.update("common.mdam.updateBuyerMdAmPrivateInfoAlterPop",formData);
				
				String old_person_author = formData.get("st_old_person_author");
				String old_role = formData.get("st_old_role");
				String old_user_group = formData.get("st_old_user_group");
				String new_person_author = formData.get("st_person_author");
				String new_role = formData.get("st_role");
				String new_user_group = formData.get("st_user_group");
				
				if(old_person_author.equals(new_person_author))
					formData.put("st_person_author","");
				if(old_role.equals(new_role))
					formData.put("st_role","");
				if(old_user_group.equals(new_user_group))
					formData.put("st_user_group","");
				
				if(!formData.get("st_person_author").equals("") || !formData.get("st_role").equals("") || !formData.get("st_user_group").equals("")) {
					sqlSessionTemplate.update("common.mdam.insertBuyerMdAmPrivateUserInfoLog",formData);
					
					//메뉴 권한을 위해 proc_userauth_gen 실행
					formData.put("COM_CODE", formData.get("st_com_code"));
					formData.put("USER_ID", formData.get("st_user_id"));
					sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", formData);
					
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
