package com.koreab2b.mro.seller.mcsc.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.koreab2b.mro.seller.mcsc.dao.*;
import com.koreab2b.mro.seller.mdam.dao.SellerMdAmDeadlineAdventCntDao;;;

@Service("SellerMCSCNoticeServiceImpl")
public class SellerMCSCNoticeServiceImpl implements SellerMCSCNoticeService {

	
	@Autowired
	private SellerMCSCNoticeDao sellerMCSCNoticeDao;
	
	@Override
	public List<Map<String, String>> getList(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectList(formData);
	}

	@Override
	public List<Map<String, String>> getListCommon(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectListCommon(formData);
	}

	@Override
	public List<Map<String, String>> getListCompany(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectListCompany(formData);
	}

	@Override
	public List<Map<String, String>> getListPop(Map<String, String> formData) {
		return  sellerMCSCNoticeDao.selectList(formData);
	}

	@Override
	public Map<String, String> getDetail(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectDetail(formData);
	}

	// ========================================
	// 공지사항 읽음 처리 관련 메소드 구현
	// ========================================

	@Override
	public void markAsRead(Map<String, String> formData) {
		// 이미 읽은 공지사항인지 체크
		int count = sellerMCSCNoticeDao.selectNoticeReadCount(formData);
		if (count == 0) {
			// 읽음 기록 등록
			sellerMCSCNoticeDao.insertNoticeReadLog(formData);
		}
	}

	// ========================================
	// 1:1 문의 관련 메소드 구현
	// ========================================

	@Override
	public List<Map<String, String>> getInquiryList(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectInquiryList(formData);
	}

	@Override
	public List<Map<String, String>> getInquiryDetail(Map<String, String> formData) {
		// 조회수 증가
		sellerMCSCNoticeDao.updateInquiryViewCount(formData);

		// 상세 조회 (문의 + 답변)
		return sellerMCSCNoticeDao.selectInquiryDetail(formData);
	}

	@Override
	public List<Map<String, String>> getQtypeCodeList(Map<String, String> formData) {
		return sellerMCSCNoticeDao.selectQtypeCodeList(formData);
	}

	@Override
	public int registerInquiry(Map<String, String> formData) {
		return sellerMCSCNoticeDao.insertInquiry(formData);
	}

	@Override
	public int cancelInquiry(Map<String, String> formData) {
		return sellerMCSCNoticeDao.cancelInquiry(formData);
	}

}
