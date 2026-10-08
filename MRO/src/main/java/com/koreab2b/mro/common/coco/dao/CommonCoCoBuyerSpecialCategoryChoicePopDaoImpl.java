package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBuyerSpecialCategoryChoicePopDao")
public class CommonCoCoBuyerSpecialCategoryChoicePopDaoImpl implements CommonCoCoBuyerSpecialCategoryChoicePopDao {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerSpecialCategoryChoicePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String,String>> getSpecialStdCategLevel1(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.coco.getSpecialStdCategLevel1", pMap);
	};
	
	public List<Map<String,String>> getBuyerSpecialCategorySearch(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerSpecialCategorySearch", pMap);
	}
	
	public List<Map<String,String>> getBuyerSpecialCategorySearchReqValue(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerSpecialCategorySearchReqValue", pMap);
	}
	
}
