package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrDetailPopDaoImpl")
@Transactional
public class MasterMdSrSrDetailPopDaoImpl implements MasterMdSrSrDetailPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrDetailPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrDetailPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectMasterMdSrSrDetailPop", formData);
	}

	// 저장
	public String saveMasterMdSrSrDetailPop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("common.mdsr.updateMasterMdSrSrDetailPop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 하던중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 조회
	public List<Map<String,String>> srResultList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectSrResultList", formData);
	}
	// 엑셀조회
	public List<Map<String,String>> getExcelMasterPoGrList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectMasterMdSrExcelPoGr", formData);
	}
	// 엑셀조회
	public List<Map<String,String>> getExcelMasterReList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectMasterMdSrExcelRe", formData);
	}
}
