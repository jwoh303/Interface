package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBottomOrgCodeMultiPopDao")
public class CommonCoCoBottomOrgCodeMultiPopDaoImpl implements CommonCoCoBottomOrgCodeMultiPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String,String>> getCommonCoCoBottomOrgCodeMultiPop(Map<String,String> pMap) {
		
		List<Map<String,String>> resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodeMultiPop", pMap);
		
		if(resultList.size() <= 1){
			resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodeMultiPop_self", pMap);
		}
		
		return resultList;
	}
}
