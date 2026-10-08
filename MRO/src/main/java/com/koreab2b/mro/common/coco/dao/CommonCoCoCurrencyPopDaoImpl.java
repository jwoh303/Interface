package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoCurrencyPopDao")
public class CommonCoCoCurrencyPopDaoImpl implements CommonCoCoCurrencyPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String,String>> getCommonCoCoCurrencyPop(Map<String,Object> pMap) {
		
		return sqlSessionTemplate.selectList("common.coco.selectCommonCoCoCurrencyPop", pMap);
		
	}
}
