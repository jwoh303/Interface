package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCtBuyerReContractPopDao")
@Transactional
public class MasterMdCtBuyerReContractPopDaoImpl implements MasterMdCtBuyerReContractPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerReContractPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 팝업 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerReContractPopList", formData);
	}
	
	// 저장
	public String saveSelectedData(Map<String,String> formData) {
		
		String _rtnMsg = "";
		
		try {
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtBuyerReContractPop", formData);

			_rtnMsg = "OK";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return _rtnMsg; 
	}
}
