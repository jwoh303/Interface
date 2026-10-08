package com.koreab2b.mro.buyer.none.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerNoNeNoticeDao")
@Transactional
public class BuyerNoNeNoticeDaoImpl implements BuyerNoNeNoticeDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.none.selectbuyerNoNeNoticeList", formData);
	}
	
	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData) {
		// 카운트 증가
		sqlSessionTemplate.update("buyer.none.updateBuyerBoardLCount",formData);
		// 상세 정보 조회
		return sqlSessionTemplate.selectOne("buyer.none.boardBuyerDetail", formData);
	}

}
