package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpClLogisRateDetailDao")
@Transactional
public class SellerMpClLogisRateDetailDaoImpl implements SellerMpClLogisRateDetailDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회 (레거시)
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClLogisRateDetailList", param);
	}

	// 리스트 조회 (리뉴얼)
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClLogisRateDetailList_v2", param);
	}
	public List<Map<String,String>> selectList_v3(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClLogisRateDetailList_v3", param);
	}
}
