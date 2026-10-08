package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrProcWritePopDaoImpl")
@Transactional
public class MasterMdSrSrProcWritePopDaoImpl implements MasterMdSrSrProcWritePopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrProcWritePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrProcWritePop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mdsr.selectMasterMdSrSrProcWritePop", formData);
	}

	// 저장
	public String saveMasterMdSrSrProcWritePop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("common.mdsr.updateMasterMdSrSrProcWritePop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리안을 상신하던중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}


}
