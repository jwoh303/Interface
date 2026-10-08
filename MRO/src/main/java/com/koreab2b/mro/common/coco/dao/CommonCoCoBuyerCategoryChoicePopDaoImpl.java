package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBuyerCategoryChoicePopDao")
public class CommonCoCoBuyerCategoryChoicePopDaoImpl implements CommonCoCoBuyerCategoryChoicePopDao {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerCategoryChoicePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getCategoryComText(Map<String,String> pMap) {
		return sqlSessionTemplate.selectOne("common.coco.getCategoryComText", pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearch(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerCategorySearch", pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearchReqValue(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerCategorySearchReqValue", pMap);
	}
	
}
