package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmGoodsInfoDetailPopDao")
@Transactional
public class MasterMdCmGoodsInfoDetailPopDaoImpl implements MasterMdCmGoodsInfoDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmGoodsInfoDetailPopList", formData);
	}
	
	// 속성정보 조회
	public List<Map<String,String>> selectList2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmGoodsInfoDetailPopList2", formData);
	}
	
	// 매핑정보 조회
	public List<Map<String,String>> selectList3(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmGoodsInfoDetailPopList3", formData);
	}
	
}
