package com.koreab2b.mro.seller.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpDsAgrchemiPckmtrlDao")
@Transactional
public class SellerMpDsAgrchemiPckmtrlDaoImpl implements SellerMpDsAgrchemiPckmtrlDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsAgrchemiPckmtrlDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpds.selectSellerMpDsAgrchemiPckmtrlList", formData);
	}

	// 조회(SUB)
	public List<Map<String,String>> selectListSub(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpds.selectSellerMpDsAgrchemiPckmtrlListSub", formData);
	}

	
}
