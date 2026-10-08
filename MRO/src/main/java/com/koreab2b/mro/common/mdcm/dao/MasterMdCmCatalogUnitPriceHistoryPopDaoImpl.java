package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCatalogUnitPriceHistoryPopDao")
@Transactional
public class MasterMdCmCatalogUnitPriceHistoryPopDaoImpl implements MasterMdCmCatalogUnitPriceHistoryPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String, String>> getMasterMdCmCatalogUnitPriceHistoryPop(Map<String, Object> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmCatalogUnitPriceHistoryPop", formData);
	}


	
}
