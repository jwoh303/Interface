package com.koreab2b.mro.common.mdct.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCtContractAlterPopDao")
@Transactional
public class MasterMdCtContractAlterPopDaoImpl implements MasterMdCtContractAlterPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtContractAlterPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtContractAlterPopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";

		try {
			if ("C001".equals(formData.get("st_company_type"))) {
				formData.put("st_cco_id", formData.get("st_com_code"));
				formData.put("st_cco_nm", formData.get("st_com_name"));
				formData.put("st_spplr_id", "");
				formData.put("st_spplr_nm", "");
			} else if("C002".equals(formData.get("st_company_type"))) {
				formData.put("st_cco_id", "");
				formData.put("st_cco_nm", "");
				formData.put("st_spplr_id", formData.get("st_com_code"));
				formData.put("st_spplr_nm", formData.get("st_com_name"));
			}

			sqlSessionTemplate.insert("common.mdct.updateMasterMdCtContractAlterPop",formData);
		} catch(Exception e) {
			_rtnMsg = "ERR";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("계약서 수정에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
		
}
