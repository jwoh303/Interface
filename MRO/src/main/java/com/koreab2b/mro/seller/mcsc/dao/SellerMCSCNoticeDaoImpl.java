package com.koreab2b.mro.seller.mcsc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Repository("SellerMCSCNoticeDao")
@Transactional
public class SellerMCSCNoticeDaoImpl  implements SellerMCSCNoticeDao{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectSellerMCSCNoticeList", formData);
	}

	@Override
	public List<Map<String, String>> selectListCommon(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectSellerMCSCNoticeListCommon", formData);
	}

	@Override
	public List<Map<String, String>> selectListCompany(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectSellerMCSCNoticeListCompany", formData);
	}

	@Override
	public List<Map<String, String>> selectListPop(Map<String, String> formData) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<String, String> selectDetail(Map<String, String> formData) {

		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("BTYPE", formData.get("st_btype"));
		pMap.put("BID", formData.get("st_bid"));

		// 카운트 증가 (ICOMBOARD_NOTICE 테이블)
		sqlSessionTemplate.update("seller.mcsc.updateSellerMCSCNoticeLCount", pMap);

		// 상세 정보 조회 (ICOMBOARD_NOTICE 테이블)
		return sqlSessionTemplate.selectOne("seller.mcsc.selectSellerMCSCNoticeDetail", pMap);
	}

	// ========================================
	// 공지사항 읽음 처리 관련 메소드 구현
	// ========================================

	@Override
	public int insertNoticeReadLog(Map<String, String> formData) {
		return sqlSessionTemplate.insert("seller.mcsc.insertNoticeReadLog", formData);
	}

	@Override
	public int selectNoticeReadCount(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("seller.mcsc.selectNoticeReadCount", formData);
	}

	// ========================================
	// 1:1 문의 관련 메소드 구현
	// ========================================

	@Override
	public List<Map<String, String>> selectInquiryList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectInquiryList", formData);
	}

	@Override
	public List<Map<String, String>> selectInquiryDetail(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectInquiryDetail", formData);
	}

	@Override
	public int updateInquiryViewCount(Map<String, String> formData) {
		return sqlSessionTemplate.update("seller.mcsc.updateInquiryViewCount", formData);
	}

	@Override
	public List<Map<String, String>> selectQtypeCodeList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("seller.mcsc.selectQtypeCodeList", formData);
	}

	@Override
	public int insertInquiry(Map<String, String> formData) {
		return sqlSessionTemplate.insert("seller.mcsc.insertInquiry", formData);
	}

	@Override
	public int cancelInquiry(Map<String, String> formData) {
		return sqlSessionTemplate.update("seller.mcsc.cancelInquiry", formData);
	}

}
