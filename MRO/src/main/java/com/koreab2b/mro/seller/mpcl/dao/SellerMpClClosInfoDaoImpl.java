package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpClClosInfoDao")
@Transactional
public class SellerMpClClosInfoDaoImpl implements SellerMpClClosInfoDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosInfoList", param);
	}

	// 리뉴얼 버전 마감 확정 내역 리스트 조회 (검색조건 추가)
	public List<Map<String,String>> selectList_V2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosInfoList_V2", param);
	}

	// 마감 대상 내역 조회
	public List<Map<String,String>> selectTargetList_V2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosTargetInfoList_V2", param);
	}
	public List<Map<String,String>> selectTargetList_V3(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosTargetInfoList_V3", param);
	}

	// 탭5 전용 리스트 조회
	public List<Map<String,String>> selectTab5List(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosInfoTab5List", param);
	}
	public List<Map<String,String>> selectTab5List_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClClosInfoTab5List_v2", param);
	}
}
