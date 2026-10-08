package com.koreab2b.mro.common.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("sellerMpClGoodsDetailInfoCowayPopDao")
@Transactional
public class SellerMpClGoodsDetailInfoCowayPopDaoImpl implements SellerMpClGoodsDetailInfoCowayPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectHdList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpcl.selectBuyerMpClGoodsDetailInfoCowayHdPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectDtList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpcl.selectBuyerMpClGoodsDetailInfoCowayDtPopList", formData);
	}
}
