package com.koreab2b.mro.common.mdct.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCtContractProgressPopDao")
@Transactional
public class MasterMdCtContractProgressPopDaoImpl implements MasterMdCtContractProgressPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtContractProgressPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtContractProgressPopList", formData);
	}
	
	// 저장
	public String updateReasonData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _ecrjNo = "";
		
		try {
			_ecrjNo = sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtContractProgressPopRjno",formData);
			formData.put("st_rj_no", _ecrjNo);
			sqlSessionTemplate.insert("common.mdct.insertMasterMdCtContractProgressPopIcomecrj",formData);
			sqlSessionTemplate.update("common.mdct.updateMasterMdCtContractProgressPopIcomecct",formData);
			if (formData.get("st_mode").equals("contCancel")) {	// 계약 해지
				sqlSessionTemplate.update("common.mdct.closeMasterMdCtContractProgressPopIcomecct",formData);
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("계약서 회수에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 저장
	public String updateVendorData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		
		try {
			sqlSessionTemplate.insert("common.mdct.insertMasterMdCtContractProgressPopIcomecsv",formData);
			sqlSessionTemplate.update("common.mdct.updateMasterMdCtContractProgressPopIcomecct",formData);
		} catch(Exception e) {
			_rtnMsg = "ERR";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("계약서 전자서명에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 저장
	public String updateMasterData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _ecrjNo = "";

		try {
			
			sqlSessionTemplate.insert("common.mdct.insertMasterMdCtContractProgressPopIcomecsv", formData);
			sqlSessionTemplate.update("common.mdct.updateMasterMdCtContractProgressPopIcomecct",formData);
			sqlSessionTemplate.update("common.mdct.updateMasterMdCtContractProgressPopIcomcmpy",formData);
			/*
			if (formData.get("st_cont_status").equals("OS1") && formData.get("st_cont_chg_type").equals("M")) {
				formData.put("st_cont_count", formData.get("st_before_cont_count"));
			}
			
			if (formData.get("st_cont_status").equals("OS2") || (formData.get("st_cont_status").equals("OS1") && formData.get("st_cont_chg_type").equals("M"))) {
				_ecrjNo = sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtContractProgressPopRjno", formData);
				formData.put("st_rj_no", _ecrjNo);
				sqlSessionTemplate.insert("common.mdct.insertMasterMdCtContractProgressPopIcomecrj",formData);
			}
			*/

			if (!formData.get("st_cont_status").equals("OS2") && (formData.get("st_cont_chg_type").equals("R") || formData.get("st_cont_chg_type").equals("M"))) {
				formData.put("contStatus", "FNL");
				formData.put("st_cont_count", formData.get("st_before_cont_count"));
				_ecrjNo = sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtContractProgressPopRjno", formData);
				formData.put("st_rj_no", _ecrjNo);
				sqlSessionTemplate.insert("common.mdct.insertMasterMdCtContractProgressPopIcomecrj",formData);
				sqlSessionTemplate.update("common.mdct.closeMasterMdCtContractProgressPopIcomecct", formData);
			}

		} catch(Exception e) {
			_rtnMsg = "ERR";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("계약서 전자서명에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
}
