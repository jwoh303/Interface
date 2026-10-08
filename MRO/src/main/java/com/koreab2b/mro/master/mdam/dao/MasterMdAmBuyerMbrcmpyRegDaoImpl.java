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

import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("masterMdAmBuyerMbrcmpyRegDao")
@Transactional
public class MasterMdAmBuyerMbrcmpyRegDaoImpl implements MasterMdAmBuyerMbrcmpyRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdAmBuyerMbrcmpyRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmBuyerMbrcmpyRegList", param);
	}

	// 아이디 중복체크 , 금지어 목록 체크
	public String selectIDCheck(Map<String,String> formData) {
		_rtnMsg = "NO";
		
		try {

			String idFlag = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmBuyerMbrcmpyRegIDCheck", formData);
			
			if (Integer.parseInt(idFlag) == 0) {
				_rtnMsg = "OK";
			}
			
			// 금지어 목록 불러오기
			List<String> wordList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmBuyerMbrcmpyRegIDCheck2", formData);
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
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmBuyerMbrcmpyRegPwdValidCheck", formData);
	}
	
	// 저장
	public Map<String, Object> updateSelectedData(Map<String,String>  formData) {
		Map<String, Object> _result = new HashMap<String, Object>();
		_rtnMsg = "OK";
		String country_code = "KR";
		
		// 각 특수문자 replace ( ! @ # , & + " ' $ *)
		String chars = "[!@#%,&+\"\'\\$\\*]";
		String com_name_eng = formData.get("st_com_name_eng").replaceAll(" ","-").trim();
		com_name_eng = com_name_eng.replaceAll(chars,"-").trim();
		
		int com_name_eng_length = com_name_eng.length();
		
		if(com_name_eng.length() < 4) {
			for(int i = com_name_eng_length; i < 4; i++) {
				com_name_eng += "-";
			}
		}
				
		String imsi_com_type = country_code + com_name_eng.substring(0,4);
		String com_code = "";
		String T_KEY  = "3972624753";
		
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {

			_pMap.put("imsi_com_type", imsi_com_type.toUpperCase());
			String sequence_number = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmBuyerMbrcmpyRegComCode", _pMap);

			if (Integer.parseInt(sequence_number) > 9999) {
				com_code = "xxx";
				_rtnMsg = "9999";
				LOGGER.error("ERROR: 한 회사에서 9999건 이상 초과해서 등록할 수 없습니다.");
			} else {
			
				if (sequence_number.length() == 1) {
					sequence_number = "000" + sequence_number;
				} else if (sequence_number.length() == 2) {
					sequence_number = "00" + sequence_number;
				} else if (sequence_number.length() == 3) {
					sequence_number = "0" + sequence_number;
				}
				com_code  = country_code.substring(0,2);
				com_code += com_name_eng.substring(0,4).toUpperCase();
				com_code += sequence_number;
				
				formData.put("st_com_code", com_code);
				
				// STEP1
				sqlSessionTemplate.insert("master.mdam.insertMasterMdAmBuyerMbrcmpyReg", formData);
				sqlSessionTemplate.insert("master.mdam.insertMasterMdAmBuyerMbrcmpyRegAcntbuyr", formData);

				_pMap.clear();
				_pMap.put("st_com_code", com_code);
				_pMap.put("st_type", "C001");
				
				String icomcod = "";
				icomcod = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmBuyerMbrcmpyRegIcomcod", _pMap);
				if (icomcod.equals("0")) {
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmBuyerMbrcmpyRegIcomCod2", _pMap);
				}
				
				_pMap.clear();
				_pMap.put("st_com_code", com_code);
				_pMap.put("st_type", "C003");
				
				icomcod = "";	
				 icomcod = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmBuyerMbrcmpyRegIcomcod", _pMap);
				if (icomcod.equals("0")) {
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmBuyerMbrcmpyRegIcomCod2", _pMap);
				}
				
				String strPassword = formData.get("st_password");
				byte[] hashPassword_2 = strPassword.getBytes();
				byte[] bszDigest = new byte[32];
				SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
				String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
				
				formData.put("st_password", toHashpassword);
				formData.put("T_KEY", T_KEY);
				sqlSessionTemplate.insert("master.mdam.insertMasterMdAmBuyerMbrcmpyRegIcomlUsr", formData);
				
				if (!"".equals(formData.get("st_image_key"))) {
					sqlSessionTemplate.update("master.mdam.updateMasterMdAmBuyerMbrcmpyRegIcomatch", formData);
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}
			}
			_result.put("msg", _rtnMsg);
			_result.put("com_code", com_code);
		} catch (Exception e) {
			_rtnMsg = "Err";
			_result.put("com_code", com_code);
			_result.put("msg", _rtnMsg);
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 등록이 실패 하였습니다.");
		}
		return _result;
	}
}
