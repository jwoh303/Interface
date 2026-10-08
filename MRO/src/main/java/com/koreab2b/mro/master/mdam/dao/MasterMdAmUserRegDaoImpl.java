package com.koreab2b.mro.master.mdam.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Repository("masterMdAmUserRegDao")
@Transactional
public class MasterMdAmUserRegDaoImpl implements MasterMdAmUserRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdAmUserRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmUserRegList", param);
	}
	
	// 아이디 중복체크, 금지어 목록 체크
	public String selectIDCheck(Map<String,String> formData) {
		String _rtnMsg = "NO";
		
		try {
			String idFlag = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmUserRegIDCheck", formData);
			
			if (Integer.parseInt(idFlag) == 0) {
				_rtnMsg = "OK";
			}
			
			// 금지어 목록 불러오기
			List<String> wordList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmUserRegIDCheck2", formData);
			for(int i = 0; i < wordList.size(); i++) {
				if(formData.get("st_user_id").contains(wordList.get(i))) {
					_rtnMsg = wordList.get(i);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("아이디 중복 체크에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmUserRegPwdValidCheck", formData);
	}

	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		
		String _buyer = formData.get("st_com_code").toString(); 
		
		// SLOGIC-BEGIN ( 1015_02 ) - 기본세팅 : PR
		String p01101502 = CommonUtil.getSpecialCheckReturn(_buyer,"P01-1015-02","COL01_DATA"); // 직발주 권한
		
		if(p01101502.equals("PO")){
			formData.put("st_person_author", "PO");
		}else{
			formData.put("st_person_author", "PR");
		}
		// SLOGIC-END		
		
		// SLOGIC-BEGIN ( 1015_03 ) - 기본세팅 : admin관리자= A+, 일반사용자= U+
		String p01101503 = CommonUtil.getSpecialCheckReturn(_buyer,"P01-1015-03","COL01_DATA"); // 메뉴접근 권한
		
		if(!p01101503.equals("")){
			formData.put("st_role", p01101503);
		}
		// SLOGIC-END
		
		// SLOGIC-BEGIN ( 1015_04 ) - 기본세팅 : Q
		String p01101504 = CommonUtil.getSpecialCheckReturn(_buyer,"P01-1015-04","COL01_DATA"); // 신규소싱 권한
		
		if(!p01101504.equals("")){
			formData.put("st_user_group", p01101504);
		}else{
			formData.put("st_user_group", "Q");
		}
		// SLOGIC-END
		
		// SLOGIC-BEGIN ( 1015_05 ) - 기본COL01_DATA : Y
		String p01101505 = CommonUtil.getSpecialCheckReturn(_buyer,"P01-1015-05","COL01_DATA"); // 발주부서에 본인부서 디폴트 세팅
		if(!p01101505.equals("") && formData.get("st_department") != null) {
			formData.put("st_purchase_dept", formData.get("st_department"));
		}
		// SLOGIC-END

		// SLOGIC-BEGIN ( 1015_06 ) - 기본COL01_DATA : Y
		String p01101506 = CommonUtil.getSpecialCheckReturn(_buyer,"P01-1015-06","COL01_DATA"); //주문진행현황 전체 조회 권한
		if(!p01101506.equals("")){
			formData.put("pr_mng_flag", p01101506);
		}else{
			formData.put("pr_mng_flag", "N");
		}
		// SLOGIC-END
		
		// 운영사 가입 시 전화번호 대표번호로 지정 - 변경은 S/R 요청(SMS 전송 관련 내선번호 지정)
		if(_buyer.equals("KRKORE0001")){
			formData.put("st_phone_number", "02-3016-8989");
		}
		
		try {
			
			if (selectIDCheck(formData).equals("OK")) {
				// STEP1
				/* hash암호화*/
				String strPassword = formData.get("st_password");
				byte[] hashPassword_2 = strPassword.getBytes();
				byte[] bszDigest = new byte[32];
				SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
				String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
				formData.put("st_password",toHashpassword);
				 
				sqlSessionTemplate.update("master.mdam.insertMasterMdAmUserReg", formData);
				
				// ICOMCOD2.TYPE=USJO 등록 고객사 - 신규가입자 승인 요청 메일 발송
				String new_mail_flag = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmUserRegNewMailCheck", formData);
				if (Integer.parseInt(new_mail_flag) != 0) {
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmUserRegNewMail", formData);
				}
			} else {
				_rtnMsg = "dup";
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 등록이 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	
	// Hash저장
	public String updateSelectedHashData(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			
			StringBuffer sb = new StringBuffer();
			List<Map<String,String>> _result = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmUseHashDataList",formData);
			if (_result != null){
				for (int i =0; i <_result.size(); i++){
					Map<String,String> rmap = _result.get(i);
					if (rmap != null){
						Map<String, String> pMap = new HashMap<String, String>();
						pMap.put("SUPPLIER", rmap.get("SUPPLIER"));						
						  //SeedCbcAlgorithmUtil 암호화
						String st_bank_account_no = rmap.get("BANK_ACCOUNT_NO");
						if(st_bank_account_no != null){
							byte[] plainText = st_bank_account_no.getBytes();
							byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
							String bszst_bank_account_no = SeedCbcAlgorithmUtil.getString(bszDigest);
						
							pMap.put("PSWD",bszst_bank_account_no);
							sqlSessionTemplate.update("master.mdam.updateMasterMdAmUseHashDataList", pMap);
						}
						
					}
				}
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(" PASSWORD변경이 실패 하였습니다.");
		}
		return _rtnMsg;
	}
}
