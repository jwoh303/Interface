package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBuyerCategoryChoiceDooPopDao")
public class CommonCoCoBuyerCategoryChoiceDooPopDaoImpl implements CommonCoCoBuyerCategoryChoiceDooPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getCategoryComText(Map<String,String> pMap) {
		return sqlSessionTemplate.selectOne("common.coco.getCategoryComDooText", pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearch(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerCategoryDooSearch", pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearchReqValue(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getBuyerCategorySearchReqDooValue", pMap);
	}
	
}
