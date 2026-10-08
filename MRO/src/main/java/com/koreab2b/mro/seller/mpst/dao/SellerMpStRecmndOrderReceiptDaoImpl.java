package com.koreab2b.mro.seller.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpStRecmndOrderReceiptDao")
@Transactional
public class SellerMpStRecmndOrderReceiptDaoImpl implements SellerMpStRecmndOrderReceiptDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회 (기존)
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpst.selectSellerMpStRecmndOrderReceiptList", formData);
	}
	
	// 날짜 파라미터 포함 조회 (신규)
	public List<Map<String,String>> selectListWithDate(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpst.selectSellerMpStRecmndOrderReceiptListWithDate", formData);
	}

}
