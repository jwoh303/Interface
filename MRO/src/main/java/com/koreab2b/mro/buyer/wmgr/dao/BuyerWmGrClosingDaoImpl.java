package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerWmGrClosingDao")
@Transactional
public class BuyerWmGrClosingDaoImpl implements BuyerWmGrClosingDao {
//	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrClosingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrClosingList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrClosingList_v2", formData);
	}

	// [v2] AR 요약 목록
	public List<Map<String,String>> selectArSummaryList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrClosingArSummaryList", formData);
	}

	// [v2] AR 상세 내역 (팝업)
	public List<Map<String,String>> selectArDetailList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrClosingArDetailList", formData);
	}

	// [v2] AR 헤더 정보 (팝업 상단)
	public Map<String,String> selectArHeaderInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrClosingArHeaderInfo", formData);
	}
}
