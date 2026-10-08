package com.koreab2b.mro.seller.mcsc.service;

import java.util.List;
import java.util.Map;

public interface SellerMCSCNoticeService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// [공통 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'Y')
	public List<Map<String,String>> getListCommon(Map<String,String>  formData);

	// [거래사별 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'N')
	public List<Map<String,String>> getListCompany(Map<String,String>  formData);

	// 조회
	public List<Map<String,String>> getListPop(Map<String,String>  formData);

	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData);

	// ========================================
	// 공지사항 읽음 처리 관련 메소드
	// ========================================

	// 공지사항 읽음 처리
	public void markAsRead(Map<String,String> formData);

	// ========================================
	// 1:1 문의 관련 메소드
	// ========================================

	// 1:1 문의 목록 조회
	public List<Map<String,String>> getInquiryList(Map<String,String> formData);

	// 1:1 문의 상세 조회 (문의 + 답변)
	public List<Map<String,String>> getInquiryDetail(Map<String,String> formData);

	// 문의유형 코드 조회
	public List<Map<String,String>> getQtypeCodeList(Map<String,String> formData);

	// 1:1 문의 등록
	public int registerInquiry(Map<String,String> formData);

	// 1:1 문의 취소
	public int cancelInquiry(Map<String,String> formData);

}
