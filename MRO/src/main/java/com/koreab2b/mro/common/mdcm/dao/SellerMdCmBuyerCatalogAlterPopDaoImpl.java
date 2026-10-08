package com.koreab2b.mro.common.mdcm.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMdCmBuyerCatalogAlterPopDao")
@Transactional
public class SellerMdCmBuyerCatalogAlterPopDaoImpl implements SellerMdCmBuyerCatalogAlterPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCmBuyerCatalogAlterPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectData(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdcm.selectSellerMdCmBuyerCatalogAlterPop", formData);
	};
	
}
