package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqKepStndrdCategorySelPopDao")
@Transactional
public class MasterMpRqKepStndrdCategorySelPopDaoImpl implements MasterMpRqKepStndrdCategorySelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqKepStndrdCategorySelPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectCategorySelPop", formData);
	}
	
}
