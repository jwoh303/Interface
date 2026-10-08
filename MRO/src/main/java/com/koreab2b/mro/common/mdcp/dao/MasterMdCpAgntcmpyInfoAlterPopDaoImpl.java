package com.koreab2b.mro.common.mdcp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtMbrCmpyInfoDaoImpl;
import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Repository("masterMdCpAgntcmpyInfoAlterPopDao")
@Transactional
public class MasterMdCpAgntcmpyInfoAlterPopDaoImpl implements MasterMdCpAgntcmpyInfoAlterPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		/* 로그관련 셋팅 시작 */
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.mdcp.selectMasterMdCpAgntcmpyInfoAlterPopList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "협력사정보(협력사조회)");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		/* 로그관련 셋팅 끝 */
		
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgntcmpyInfoAlterPopList", formData);
	}
	// 납품가능지역 조회
	public List<Map<String,String>> selectDelyAreaList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpCmpyDelyAreaList", formData);
	}	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "OK";
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopCmpy", formData);
			if(!formData.get("simsaLevel").equals("3")) {
				sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopUsr", formData);
			}
			formData.put("st_mp_business_yn", CommonUtil.nvl(formData.get("st_mp_business_yn")));	
			for (int i=1; i < 6; i++) {
				formData.put("st_mp"+i+"_business_yn", CommonUtil.nvl(formData.get("st_mp"+i+"_business_yn")));
			}
			formData.put("st_itm_mk_yn", CommonUtil.nvl(formData.get("st_itm_mk_yn")));
			for (int i=1; i < 11; i++) {
				formData.put("st_itm_mk"+i+"_yn", CommonUtil.nvl(formData.get("st_itm_mk"+i+"_yn")));
			}

			
			formData.put("st_deal_contract_doc_yn", CommonUtil.nvl(formData.get("st_deal_contract_doc_yn")));
			formData.put("st_biz_licence_doc_yn", CommonUtil.nvl(formData.get("st_biz_licence_doc_yn")));
			formData.put("st_account_doc_yn", CommonUtil.nvl(formData.get("st_account_doc_yn")));
			formData.put("st_bankbook_copy_yn", CommonUtil.nvl(formData.get("st_bankbook_copy_yn")));
			formData.put("st_seal_cert_doc_yn", CommonUtil.nvl(formData.get("st_seal_cert_doc_yn")));
			formData.put("st_using_seal_doc_yn", CommonUtil.nvl(formData.get("st_using_seal_doc_yn")));
			
			if ( Integer.parseInt(formData.get("st_kep_system_ed_month")) < 10) {
				formData.put("st_kep_system_ed", formData.get("st_kep_system_ed_year") + "0" + formData.get("st_kep_system_ed_month"));
			} else {
				formData.put("st_kep_system_ed" ,formData.get("st_kep_system_ed_year") + formData.get("st_kep_system_ed_month"));
			}
			formData.put("st_kep_damdang_remark", CommonUtil.nvl(formData.get("st_kep_damdang_remark")));
			formData.put("st_kep_damdang_remark2", CommonUtil.nvl(formData.get("st_kep_damdang_remark2")));
			
			formData.put("st_pay_type", CommonUtil.nvl(formData.get("st_pay_type")));
			formData.put("st_pay_date_type", CommonUtil.nvl(formData.get("st_pay_date_type")));
			
			/* 기존 SeedCbc 암호화 
			  //SeedCbcAlgorithmUtil 암호화
			String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
			byte[] plainText = st_bank_account_no.getBytes();

			//byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_EncryptCbc(plainText,0,plainText.length); //현명환 임시주석처리
			byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
			String bszst_bank_account_no = SeedCbcAlgorithmUtil.getString(bszDigest);
			
			formData.put("st_hash_bank_account_no", bszst_bank_account_no);
			*/
			
			//신규 KMS 암호화
			String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
			String bszst_bank_account_no =AWSKMSAlgorithmUtil.encrypt(st_bank_account_no);
			formData.put("st_hash_bank_account_no", bszst_bank_account_no);
			 
			
			//////////////////////////추후 데이터 migration을 위한 임시 로직///////////////////
			//KMS - cck_temp에 암호화데이터 임시저장
			String st_bank_account_no_seed = CommonUtil.nvl(formData.get("st_bank_account_no"));
			byte[] plainText = st_bank_account_no_seed.getBytes();
			byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
			String bszst_bank_account_no_seed = SeedCbcAlgorithmUtil.getString(bszDigest);
			formData.put("bszst_bank_account_no_test", bszst_bank_account_no_seed);
			
//			String bszst_bank_account_no_test = AWSKMSAlgorithmUtil.encrypt(CommonUtil.nvl(formData.get("st_bank_account_no")));
//			formData.put("bszst_bank_account_no_test", bszst_bank_account_no_test);
			//com_code 기준 데이터 있으면 update, 없으면 insert (temp_04 = 협력사코드 , temp_05 = 계좌번호 평문데이터 , temp_06 = 계좌번호 암호화데이터SeedCbc , temp_07 = 계좌번호 암호화데이터 KMS)
			int chk = sqlSessionTemplate.update("common.mdcp.updateEncryptText", formData);
			if(chk == 0) {
				sqlSessionTemplate.update("common.mdcp.insertEncryptText", formData);
			}
			//////////////////////////추후 데이터 migration을 위한 임시 로직///////////////////
			
			//처음에 KeP담당자에는 품의올린 사람이 들어가도록(회원가입화면에서 KeP담당자 입력x)
			if(formData.get("st_kep_damdang_id").equals("")) {
				formData.put("st_kep_damdang_id", formData.get("st_user_name"));
			}
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopSuplinfo2", formData);
			
			/* 로그관련 셋팅 시작 */
			String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopAcntsupl").getBoundSql(formData).getSql();
			String attr_01 = "";
			for(Map.Entry<String, String>entry: formData.entrySet()){
				attr_01 += entry.getKey() + "="+entry.getValue() + "/";
			}
			Map<String, String> data = new HashMap<String, String>();
			data.putAll(formData);
			data.put("SYSTEM", "KOREAB2B");
			data.put("MENU", "협력사정보(협력사조회)");
			data.put("LOG_TYPE", "수정");
			data.put("ATTR_01", strSql+"/"+attr_01);
			data.put("ATTR_02", "");
			data.put("ATTR_03", "");
			sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
			/* 로그관련 셋팅 끝 */
			
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopAcntsupl", formData);
			
			if (formData.get("st_SaveFlag").equals("T")) {
//				formData.put("st_auth_id",  "ROLE_SADM001");
//				String _authChk =  sqlSessionTemplate.selectOne("common.mdcp.getMasterMdCpAgntcmpyInfoAlterPopUserAuth",formData);
//				if (Integer.parseInt(_authChk) > 0) {
//					sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopUserAuth",formData);
//				} else {
//					sqlSessionTemplate.insert("common.mdcp.insertMasterMdCpAgntcmpyInfoAlterPopUserAuth",formData);
//				}
				Map<String, String> _pMap2 = new HashMap<String, String>();
				_pMap2.put("COM_CODE", formData.get("com_code"));
				_pMap2.put("USER_ID", formData.get("st_usr_user_id"));
				
				sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap2);
			}
			
			_pMap.put("st_com_code", formData.get("com_code"));
			Map<String, String> _imgMap = sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmSellerMbrcmpyRegItmKey", _pMap);
			
			if (_imgMap != null ) {
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
			if(formData.get("st_evl_user").equals("Y")) {
								
				if(formData.get("st_SaveFlag").equals("T")){ //품의인 경우에만 merge
					// 물류 수수료율 등록
					sqlSessionTemplate.update("master.mdcp.insertLogisRateMng_agentPop", formData);
				}
			}
			
			
		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("협력사 수정에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 저장
	public String updateSelectedDataAvl(Map<String,String> formData) {

		String _rtnMsg = "OK";
	
		try {
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgntcmpyInfoAlterPopAvl", formData);
			
		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("AVL 협력사 수정 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {

		String _rtnMsg = "OK";
	
		try {
			sqlSessionTemplate.update("common.mdcp.deleteMasterMdCpAgntcmpyInfoAlterPopCmpy", formData);
			sqlSessionTemplate.update("common.mdcp.deleteMasterMdCpAgntcmpyInfoAlterPopUsr", formData);
			
		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("AVL 협력사 수정 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//
	public String getEncryptText(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdcp.getEncryptText", formData);
	}
}
