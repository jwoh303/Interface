package com.koreab2b.mro.common.mdct.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdam.dao.BuyerMdAmPrivateInfoAlterPopDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCtStndrdContractWritePopDao")
@Transactional
public class MasterMdCtStndrdContractWritePopDaoImpl implements MasterMdCtStndrdContractWritePopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtStndrdContractWritePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtStndrdContractWritePopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		
		try {
			if (formData.get("st_form_no").equals("")) {
				String _formNo = 	sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtStndrdContractWritePopFormNo", formData);
				formData.put("st_form_no", _formNo);
				sqlSessionTemplate.insert("common.mdct.insertMasterMdCtStndrdContractWritePop",formData);
			} else {
				sqlSessionTemplate.update("common.mdct.updateMasterMdCtStndrdContractWritePop",formData);
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("표준계약서 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
}
