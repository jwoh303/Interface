package com.koreab2b.mro.buyer.mcsc.service;

import java.util.List;
import java.util.Map;

public interface BuyerMcScCustomerCenterService {

	// ========================================
	// 공지사항 관련
	// ========================================

	// [공통 공지사항] 조회
	public List<Map<String,String>> getNoticeListCommon(Map<String,String> formData);

	// [거래사별 공지사항] 조회
	public List<Map<String,String>> getNoticeListCompany(Map<String,String> formData);

	// 공지사항 상세
	public Map<String,String> getNoticeDetail(Map<String,String> formData);

	// 공지사항 읽음 처리
	public void markNoticeAsRead(Map<String,String> formData);

	// 공지사항 등록 (관리자)
	public int registerNotice(Map<String,String> formData);

	// 공지사항 수정 (관리자)
	public int updateNotice(Map<String,String> formData);

	// 공지사항 삭제 (관리자)
	public int deleteNotice(Map<String,String> formData);

	// ========================================
	// 1:1 문의(VOC) 관련 - KEPAVCDT
	// ========================================

	// VOC 문의 목록 조회
	public List<Map<String,String>> getInquiryList(Map<String,String> formData);

	// VOC 문의 상세 조회
	public Map<String,String> getInquiryDetail(Map<String,String> formData);

	// VOC 유형 코드 조회
	public List<Map<String,String>> getQtypeCodeList(Map<String,String> formData);

	// VOC 문의 취소
	public int cancelInquiry(Map<String,String> formData);

	// VOC 문의 답변 확인 처리
	public int markInquiryAsRead(Map<String,String> formData);

	// ========================================
	// 내부 공지사항 관련 (BUYERBOARD)
	// ========================================

	// 내부 공지사항 목록 조회
	public List<Map<String,String>> getInternalNoticeList(Map<String,String> formData);

	// 내부 공지사항 상세 조회
	public Map<String,String> getInternalNoticeDetail(Map<String,String> formData);

	// 내부 공지사항 등록
	public int registerInternalNotice(Map<String,String> formData);

	// 내부 공지사항 수정
	public int updateInternalNotice(Map<String,String> formData);

	// 내부 공지사항 삭제
	public int deleteInternalNotice(Map<String,String> formData);

	// 내부 공지사항 읽음 처리 (중복 방지)
	public void markInternalNoticeAsRead(Map<String,String> formData);

	// ========================================
	// 고객사 메인 : 미확인 공지(일반+내부) 건수
	// ========================================

	// 미확인 공지 건수 조회 (TOTAL_UNREAD)
	public Map<String,Object> getBuyerUnreadNoticeCount(Map<String,String> formData);

}
