package com.koreab2b.mro.master.mdam.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Repository("masterMdAmSellerMbrcmpyRegDao")
@Transactional
public class MasterMdAmSellerMbrcmpyRegDaoImpl implements MasterMdAmSellerMbrcmpyRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdAmSellerMbrcmpyRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmSellerMbrcmpyRegList", param);
	}
	
	// 아이디 중복체크, 금지어 목록 체크
	public String selectIDCheck(Map<String,String> formData) {
		_rtnMsg = "NO";
		
		try {
			String idFlag = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegIDCheck", formData);
			
			if (Integer.parseInt(idFlag) == 0) {
				_rtnMsg = "OK";
			}
			
			// 금지어 목록 불러오기
			List<String> wordList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmSellerMbrcmpyRegIDCheck2", formData);
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
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegPwdValidCheck", formData);
	}
		
	// 가입여부 확인 (IRS_NO)
	public Map<String,String> selectIrsCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmMbrcmpyIrsCheck", formData);
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
			_pMap.put("st_irs_no", formData.get("st_irs_no1") + "-" + formData.get("st_irs_no2") + "-" + formData.get("st_irs_no3"));
			String _irsNoChk = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegIrsCheck", _pMap);
			
			if (Integer.parseInt(_irsNoChk) == 0) {
				_pMap.clear();
				_pMap.put("imsi_com_type", imsi_com_type.toUpperCase());
				String sequence_number = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegComCode", _pMap);
				
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
					formData.put("st_establish_date", formData.get("st_establish_date").replaceAll("/", ""));
					
					// STEP1
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmSellerMbrcmpyRegCmpy", formData);
					
					_pMap.clear();
					_pMap.put("st_type", "C001");
					_pMap.put("st_com_code", com_code);
					String cod2Check = "";
					cod2Check = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegIcomcod", _pMap);
					
					if (Integer.parseInt(cod2Check) == 0) {
						sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerMbrcmpyRegCod2", _pMap);
					}
					
					_pMap.clear();
					_pMap.put("st_type", "C003");
					_pMap.put("st_com_code", com_code);
					cod2Check = "";
					cod2Check = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegIcomcod", _pMap);
					
					if (Integer.parseInt(cod2Check) == 0) {
						sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerMbrcmpyRegCod2", _pMap);
					}
					 
					
					String strPassword = formData.get("st_password");
					byte[] hashPassword_2 = strPassword.getBytes();
					byte[] bszDigest = new byte[32];
					SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
					String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
					
					formData.put("st_password", toHashpassword);
					formData.put("T_KEY", T_KEY);
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerMbrcmpyRegUsr", formData);
					//경리담당자정보 자동 입력.
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerBillAccountingUsr", formData);
					
					/* 기존 SeedCbc 암호화
					//SeedCbcAlgorithmUtil 암호화
					String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
					byte[] plainText = st_bank_account_no.getBytes();
					byte[]  bszDigestCbc = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
					String bszst_bank_account_no = SeedCbcAlgorithmUtil.getString(bszDigestCbc);
					formData.put("st_hash_bank_account_no", bszst_bank_account_no);
					*/
					
					//신규 KMS 암호화
					String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
					String bszst_bank_account_no = AWSKMSAlgorithmUtil.encrypt(st_bank_account_no);
					formData.put("st_hash_bank_account_no", bszst_bank_account_no);


					//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
					//KMS - cck_temp에 암호화데이터 임시저장
					String st_bank_account_no_seed = CommonUtil.nvl(formData.get("st_bank_account_no"));
					byte[] plainText = st_bank_account_no_seed.getBytes();
					byte[] bszDigestCbc = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText, 0, plainText.length);
					String bszst_bank_account_no_seed = SeedCbcAlgorithmUtil.getString(bszDigestCbc);
					formData.put("bszst_bank_account_no_test", bszst_bank_account_no_seed);
					formData.put("com_code", com_code);
					int chk = sqlSessionTemplate.update("common.mdcp.updateEncryptText", formData);
					if(chk == 0) {
						sqlSessionTemplate.update("common.mdcp.insertEncryptText", formData);
					}
					//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
					
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerMbrcmpyRegAcntsupl", formData);
					
					formData.put("st_kep_damdang_nm", CommonUtil.nvl(formData.get("st_kep_damdang_nm")));
					formData.put("st_mp_business_yn", CommonUtil.nvl(formData.get("st_mp_business_yn")));
					for (int i=1; i < 6; i++) {
						formData.put("st_mp"+i+"_business_yn", CommonUtil.nvl(formData.get("st_mp"+i+"_business_yn")));
					}
					formData.put("st_itm_mk_yn", CommonUtil.nvl(formData.get("st_itm_mk_yn")));
					for (int i=1; i < 11; i++) {
						formData.put("st_itm_mk"+i+"_yn", CommonUtil.nvl(formData.get("st_itm_mk"+i+"_yn")));
					}
					
					if ( Integer.parseInt(formData.get("st_kep_system_ed_month")) < 10) {
						formData.put("st_kep_system_ed", formData.get("st_kep_system_ed_year") + "0" + formData.get("st_kep_system_ed_month"));
					} else {
						formData.put("st_kep_system_ed" ,formData.get("st_kep_system_ed_year") + formData.get("st_kep_system_ed_month"));
					}

					formData.put("st_pay_type", CommonUtil.nvl(formData.get("st_pay_type")));
					formData.put("st_pay_date_type", CommonUtil.nvl(formData.get("st_pay_date_type")));
					
					formData.put("st_deal_contract_doc_yn", CommonUtil.nvl(formData.get("st_deal_contract_doc_yn")));
					formData.put("st_biz_licence_doc_yn", CommonUtil.nvl(formData.get("st_biz_licence_doc_yn")));
					formData.put("st_account_doc_yn", CommonUtil.nvl(formData.get("st_account_doc_yn")));
					formData.put("st_bankbook_copy_yn", CommonUtil.nvl(formData.get("st_bankbook_copy_yn")));
					formData.put("st_seal_cert_doc_yn", CommonUtil.nvl(formData.get("st_seal_cert_doc_yn")));
					formData.put("st_using_seal_doc_yn", CommonUtil.nvl(formData.get("st_using_seal_doc_yn")));
					
					sqlSessionTemplate.insert("master.mdam.insertMasterMdAmSellerMbrcmpyRegSupl", formData);
					
					Map<String, String> _imgMap = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegItmKey", _pMap);
					List< String > _list = new ArrayList< String >( );
					
					if (_imgMap != null ) {
						for (int i=0; i <= 10; i++) {
							_list.add(i, CommonUtil.nvl(_imgMap.get("ITM_MK" + i + "_IMAGE_KEY")));
						}

						_pMap.clear();
						_pMap.put("st_com_code", com_code);
						_pMap.put("image_key_array", _list);
						sqlSessionTemplate.update("master.mdam.updateMasterMdAmSellerMbrcmpyRegIcomatch", _pMap);

						String _imgKey = "";
						for (int i=0; i <= 10; i++) {
							Map<String, String> _imgKeyMap = new HashMap<String, String>(); 
							_imgKey = CommonUtil.nvl(_imgMap.get("ITM_MK" + i + "_IMAGE_KEY"));
							if (!"".equals(_imgKey)) {
								_imgKeyMap.put("DOC_NO", _imgKey);
								sqlSessionTemplate.update("common.fileUploadFlagUpdate", _imgKeyMap);
							}
						}
					}
				}
			} else {
				_rtnMsg = "irs";
			}
			_result.put("msg", _rtnMsg);
			_result.put("com_code", com_code);
		} catch (Exception e){
			_rtnMsg = "Err";
			_result.put("msg", _rtnMsg);
			_result.put("com_code", com_code);
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _result;
	}
}
