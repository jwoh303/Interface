package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonNoNeBuyerChoiceMultiPopDao")
@Transactional
public class CommonNoNeBuyerChoiceMultiPopDaoImpl implements CommonNoNeBuyerChoiceMultiPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getCommonNoNeBuyerChoiceMultiPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.none.selectCommonNoNeBuyerChoiceMultiPopList", formData);
	}
}
