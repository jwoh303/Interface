package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpStWarehouseStockDao")
@Transactional
public class BuyerMpStWarehouseStockDaoImpl implements BuyerMpStWarehouseStockDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpStWarehouseStockDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStWarehouseStockList", formData);
	}
	
}
