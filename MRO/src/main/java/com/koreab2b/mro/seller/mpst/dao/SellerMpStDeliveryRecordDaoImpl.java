package com.koreab2b.mro.seller.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpStDeliveryRecordDao")
@Transactional
public class SellerMpStDeliveryRecordDaoImpl implements SellerMpStDeliveryRecordDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpst.selectSellerMpStDeliveryRecordList", formData);
	}

}
