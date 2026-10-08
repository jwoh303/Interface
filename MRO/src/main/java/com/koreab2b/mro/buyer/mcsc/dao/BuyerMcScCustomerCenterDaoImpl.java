package com.koreab2b.mro.buyer.mcsc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("BuyerMcScCustomerCenterDao")
@Transactional
public class BuyerMcScCustomerCenterDaoImpl implements BuyerMcScCustomerCenterDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// ========================================
	// 공지사항 관련
	// ========================================

	@Override
	public List<Map<String, String>> selectNoticeListCommon(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mcsc.selectBuyerNoticeListCommon", formData);
	}

	@Override
	public List<Map<String, String>> selectNoticeListCompany(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mcsc.selectBuyerNoticeListCompany", formData);
	}

	@Override
	public Map<String, String> selectNoticeDetail(Map<String, String> formData) {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("BTYPE", formData.get("st_btype") != null ? formData.get("st_btype") : "NT");
		pMap.put("BID", formData.get("st_bid"));

		// 조회수 증가
		sqlSessionTemplate.update("buyer.mcsc.updateBuyerNoticeLCount", pMap);

		// 상세 정보 조회
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerNoticeDetail", pMap);
	}

	@Override
	public int insertNoticeReadLog(Map<String, String> formData) {
		return sqlSessionTemplate.insert("buyer.mcsc.insertBuyerNoticeReadLog", formData);
	}

	@Override
	public int selectNoticeReadCount(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerNoticeReadCount", formData);
	}

	@Override
	public int insertNotice(Map<String, String> formData) {
		return sqlSessionTemplate.insert("buyer.mcsc.insertBuyerNotice", formData);
	}

	@Override
	public int insertNoticeCustomer(Map<String, String> formData) {
		return sqlSessionTemplate.insert("buyer.mcsc.insertBuyerNoticeCustomer", formData);
	}

	@Override
	public int updateNotice(Map<String, String> formData) {
		return sqlSessionTemplate.update("buyer.mcsc.updateBuyerNotice", formData);
	}

	@Override
	public int deleteNoticeCustomers(Map<String, String> formData) {
		return sqlSessionTemplate.delete("buyer.mcsc.deleteBuyerNoticeCustomers", formData);
	}

	@Override
	public int deleteNotice(Map<String, String> formData) {
		return sqlSessionTemplate.update("buyer.mcsc.deleteBuyerNotice", formData);
	}

	// ========================================
	// 1:1 문의(VOC) 관련 - KEPAVCDT
	// ========================================

	@Override
	public List<Map<String, String>> selectInquiryList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mcsc.selectBuyerInquiryList", formData);
	}

	@Override
	public Map<String, String> selectInquiryDetail(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerInquiryDetail", formData);
	}

	@Override
	public List<Map<String, String>> selectQtypeCodeList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mcsc.selectBuyerQtypeCodeList", formData);
	}

	@Override
	public int deleteInquiry(Map<String, String> formData) {
		return sqlSessionTemplate.update("buyer.mcsc.cancelBuyerInquiry", formData);
	}

	@Override
	public int updateInquiryRead(Map<String, String> formData) {
		return sqlSessionTemplate.update("buyer.mcsc.updateBuyerInquiryRead", formData);
	}

	// ========================================
	// 내부 공지사항 관련 (BUYERBOARD)
	// ========================================

	@Override
	public List<Map<String, String>> selectInternalNoticeList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mcsc.selectBuyerInternalNoticeList", formData);
	}

	@Override
	public Map<String, String> selectInternalNoticeDetail(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerInternalNoticeDetail", formData);
	}

	@Override
	public int insertInternalNotice(Map<String, String> formData) {
		return sqlSessionTemplate.insert("buyer.mcsc.insertBuyerInternalNotice", formData);
	}

	@Override
	public int updateInternalNotice(Map<String, String> formData) {
		return sqlSessionTemplate.update("buyer.mcsc.updateBuyerInternalNotice", formData);
	}

	@Override
	public int deleteInternalNotice(Map<String, String> formData) {
		return sqlSessionTemplate.delete("buyer.mcsc.deleteBuyerInternalNotice", formData);
	}

	@Override
	public int insertInternalNoticeReadLog(Map<String, String> formData) {
		return sqlSessionTemplate.insert("buyer.mcsc.insertBuyerInternalNoticeReadLog", formData);
	}

	@Override
	public int selectInternalNoticeReadCount(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerInternalNoticeReadCount", formData);
	}

	// ========================================
	// 고객사 메인 : 미확인 공지(일반+내부) 건수
	// ========================================

	@Override
	public Map<String, Object> selectBuyerUnreadNoticeCount(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mcsc.selectBuyerUnreadNoticeCount", formData);
	}

}
