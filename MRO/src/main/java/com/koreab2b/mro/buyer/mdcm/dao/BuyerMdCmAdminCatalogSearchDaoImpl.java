package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdCmAdminCatalogSearchDao")
@Transactional
public class BuyerMdCmAdminCatalogSearchDaoImpl implements BuyerMdCmAdminCatalogSearchDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmAdminCatalogSearch", formData);
	} 

}

