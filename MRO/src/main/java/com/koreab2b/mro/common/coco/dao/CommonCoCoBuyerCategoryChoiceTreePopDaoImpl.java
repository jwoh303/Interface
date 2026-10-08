package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBuyerCategoryChoiceTreePopDao")
public class CommonCoCoBuyerCategoryChoiceTreePopDaoImpl implements CommonCoCoBuyerCategoryChoiceTreePopDao {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerCategoryChoiceTreePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getCategoryComText(Map<String,String> pMap) {
		return sqlSessionTemplate.selectOne("common.coco.getCategoryComText", pMap);
	}
	
	public List<Map<String,String>> getCategoryTreeRootSelect(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getCategoryTreeRootSelect", pMap);
	}
	
	public List<Map<String,String>> getCategoryTreeChildSelect(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getCategoryTreeChildSelect", pMap);
	}

}
