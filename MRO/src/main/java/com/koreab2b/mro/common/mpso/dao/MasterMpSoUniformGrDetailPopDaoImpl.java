package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoUniformGrDetailPopDao")
@Transactional
public class MasterMpSoUniformGrDetailPopDaoImpl implements MasterMpSoUniformGrDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoUniformGrDetailPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectHdList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoUniformGrDetailPopHdList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectDtList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoUniformGrDetailPopDtList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		try{
			// 건별 입고수량 입력
			sqlSessionTemplate.update("common.mpso.updateMasterMpSoUniformGrDetailPop", formData);
			
			// 건별 입고수량 합
			sqlSessionTemplate.update("common.mpso.updateMasterMpSoUniformGrDetailPopSum", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("등록 실패하였습니다.");
		}
		return null;
	}
}
