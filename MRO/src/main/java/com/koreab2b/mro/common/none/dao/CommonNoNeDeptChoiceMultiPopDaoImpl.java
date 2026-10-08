package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonNoNeDeptChoiceMultiPopDao")
@Transactional
public class CommonNoNeDeptChoiceMultiPopDaoImpl implements CommonNoNeDeptChoiceMultiPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getCommonNoNeDeptChoiceMultiPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.none.selectCommonNoNeDeptChoiceMultiPopList", formData);
	}
}
