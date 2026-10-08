package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.ArrayList;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMdCmUniformSearchDao")
@Transactional
public class BuyerMdCmUniformSearchDaoImpl implements BuyerMdCmUniformSearchDao {
	private static final Logger LOGGER  = LoggerFactory.getLogger(BuyerMdCmUniformSearchDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmUniformSearchList", formData);
	}
	
	
}
