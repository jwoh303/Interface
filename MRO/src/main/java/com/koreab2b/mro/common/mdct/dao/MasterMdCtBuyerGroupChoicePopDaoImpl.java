package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("MasterMdCtBuyerGroupChoicePopDao")
@Transactional
public class MasterMdCtBuyerGroupChoicePopDaoImpl implements MasterMdCtBuyerGroupChoicePopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdct.selectmasterMdCtBuyerGroupChoicePopList", formData);
	}

}
