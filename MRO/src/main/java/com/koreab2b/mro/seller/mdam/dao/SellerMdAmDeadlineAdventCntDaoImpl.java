package com.koreab2b.mro.seller.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMdAmDeadlineAdventCntDao")
@Transactional
public class SellerMdAmDeadlineAdventCntDaoImpl implements SellerMdAmDeadlineAdventCntDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdam.selectSellerMdAmDeadlineAdventCntList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectListPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdam.selectDeliveryDelayListPop", formData);
	}
	
}
