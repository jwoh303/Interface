package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoCatalogAlterPopDao")
public class CommonCoCoCatalogAlterPopDaoImpl  implements CommonCoCoCatalogAlterPopDao {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoCatalogAlterPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.coco.selectCommonCoCoCatalogAlterList", param);
	}

}
