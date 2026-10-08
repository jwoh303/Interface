package com.koreab2b.mro.seller.mdct.dao;

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
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Repository("sellerMdCtMbrCmpyInfoDao")
@Transactional
public class SellerMdCtMbrCmpyInfoDaoImpl implements SellerMdCtMbrCmpyInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtMbrCmpyInfoList", formData);
	}
	// 납품가능지역조회
	public List<Map<String,String>> selectDelyAreaList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtMbrCmpyDelyAreaList", formData);
	}	
	

	// 저장 (레거시)
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "OK";
	
		try {
			sqlSessionTemplate.update("seller.mdct.updateSellerMdCtMbrCmpyInfoCmpy", formData);

			String suplinfoCnt = sqlSessionTemplate.selectOne("seller.mdct.selectSellerMdCtMbrCmpyInfoSuplinfoCnt",formData);

			if (suplinfoCnt.equals("0")) {
				sqlSessionTemplate.insert("seller.mdct.insertSellerMdCtMbrCmpyInfoSuplinfo", formData);
			} else {
				
				for (int i=1; i < 6; i++) {
					formData.put("st_mp"+i+"_business_yn", CommonUtil.nvl(formData.get("st_mp"+i+"_business_yn")));
				}
				formData.put("st_mp_business_yn", CommonUtil.nvl(formData.get("st_mp_business_yn")));
				formData.put("st_itm_mk_yn", CommonUtil.nvl(formData.get("st_itm_mk_yn")));
				
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
				 
				
				//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
				//KMS - cck_temp에 암호화데이터 임시저장
//				String bszst_bank_account_no_test = AWSKMSAlgorithmUtil.encrypt(CommonUtil.nvl(formData.get("st_bank_account_no")));
//				formData.put("bszst_bank_account_no_test", bszst_bank_account_no_test);
				String st_bank_account_no_seed = CommonUtil.nvl(formData.get("st_bank_account_no"));
				byte[] plainText = st_bank_account_no_seed.getBytes();
				//byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_EncryptCbc(plainText,0,plainText.length); //현명환 임시주석처리
				byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
				String bszst_bank_account_no_seed = SeedCbcAlgorithmUtil.getString(bszDigest);
				formData.put("bszst_bank_account_no_test", bszst_bank_account_no_seed);
				formData.put("com_code", formData.get("st_com_code"));
				//com_code 기준 데이터 있으면 update, 없으면 insert (temp_04 = 협력사코드 , temp_05 = 계좌번호 평문데이터 , temp_06 = 계좌번호 암호화데이터SeedCbc , temp_07 = 계좌번호 암호화데이터 KMS)
				int chk = sqlSessionTemplate.update("common.mdcp.updateEncryptText", formData);
				if(chk == 0) {
					sqlSessionTemplate.update("common.mdcp.insertEncryptText", formData);
				}
				//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
				
				sqlSessionTemplate.update("seller.mdct.updateSellerMdCtMbrCmpyInfoSuplinfo", formData);
				//계좌정보 업데이트
				sqlSessionTemplate.update("seller.mdct.updateSellerMdCtBankAccountNoinfo", formData);
				
				Map<String, Object> _pMap = new HashMap<String, Object>();
				_pMap.put("st_com_code", formData.get("st_com_code"));
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
			}

		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 담기에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 저장 (리뉴얼)
	public String updateSelectedData_v2(Map<String,String> formData) {

		String _rtnMsg = "OK";

		try {
			// 회원사 기본 정보 업데이트 (ICOMCMPY)
			sqlSessionTemplate.update("seller.mdct.updateSellerMdCtMbrCmpyInfoCmpy_v2", formData);

			// 관리자 정보 업데이트 (ICOMLUSR)
			sqlSessionTemplate.update("seller.mdct.updateSellerMdCtMbrCmpyInfoUsr", formData);

			String suplinfoCnt = sqlSessionTemplate.selectOne("seller.mdct.selectSellerMdCtMbrCmpyInfoSuplinfoCnt",formData);

			if (suplinfoCnt.equals("0")) {
				sqlSessionTemplate.insert("seller.mdct.insertSellerMdCtMbrCmpyInfoSuplinfo", formData);
			} else {
				
				for (int i=1; i < 6; i++) {
					formData.put("st_mp"+i+"_business_yn", CommonUtil.nvl(formData.get("st_mp"+i+"_business_yn")));
				}
				formData.put("st_mp_business_yn", CommonUtil.nvl(formData.get("st_mp_business_yn")));
				formData.put("st_itm_mk_yn", CommonUtil.nvl(formData.get("st_itm_mk_yn")));
				
/* 				기존 SeedCbc 암호화
				 //SeedCbcAlgorithmUtil 암호화
				String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
				byte[] plainText = st_bank_account_no.getBytes();
				//byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_EncryptCbc(plainText,0,plainText.length); //현명환 임시주석처리
				byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
				String bszst_bank_account_no = SeedCbcAlgorithmUtil.getString(bszDigest);
				formData.put("st_hash_bank_account_no", bszst_bank_account_no);
				*/
				
				/* TODO: 계좌번호 수정 기능 주석처리 로컬에서 암호화 관련 에러 발생하여 주석 처리  - 추후 구현 예정

				//신규 KMS 암호화
				String st_bank_account_no = CommonUtil.nvl(formData.get("st_bank_account_no"));
				String bszst_bank_account_no =AWSKMSAlgorithmUtil.encrypt(st_bank_account_no);
				formData.put("st_hash_bank_account_no", bszst_bank_account_no);


				//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
				//KMS - cck_temp에 암호화데이터 임시저장
//				String bszst_bank_account_no_test = AWSKMSAlgorithmUtil.encrypt(CommonUtil.nvl(formData.get("st_bank_account_no")));
//				formData.put("bszst_bank_account_no_test", bszst_bank_account_no_test);
				String st_bank_account_no_seed = CommonUtil.nvl(formData.get("st_bank_account_no"));
				byte[] plainText = st_bank_account_no_seed.getBytes();
				//byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_EncryptCbc(plainText,0,plainText.length); //현명환 임시주석처리
				byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
				String bszst_bank_account_no_seed = SeedCbcAlgorithmUtil.getString(bszDigest);
				formData.put("bszst_bank_account_no_test", bszst_bank_account_no_seed);
				formData.put("com_code", formData.get("st_com_code"));
				//com_code 기준 데이터 있으면 update, 없으면 insert (temp_04 = 협력사코드 , temp_05 = 계좌번호 평문데이터 , temp_06 = 계좌번호 암호화데이터SeedCbc , temp_07 = 계좌번호 암호화데이터 KMS)
				int chk = sqlSessionTemplate.update("common.mdcp.updateEncryptText", formData);
				if(chk == 0) {
					sqlSessionTemplate.update("common.mdcp.insertEncryptText", formData);
				}
				
		*/
				//////////////////////////추후 데이터 MIGRATION을 위한 로직///////////////////
				
				sqlSessionTemplate.update("seller.mdct.updateSellerMdCtMbrCmpyInfoSuplinfo", formData);
				
				
				
				
				//계좌정보 업데이트 - TODO: 나중에 구현 예정
				//sqlSessionTemplate.update("seller.mdct.updateSellerMdCtBankAccountNoinfo", formData);
				
				
				
				
				Map<String, Object> _pMap = new HashMap<String, Object>();
				_pMap.put("st_com_code", formData.get("st_com_code"));
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
			}

		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 담기에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
