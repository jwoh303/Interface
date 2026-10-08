package com.koreab2b.mro.buyer.mcsc.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMcScCustomerCenterDao {

	// ========================================
	// 공지사항 관련
	// ========================================

	// [공통 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'Y')
	public List<Map<String,String>> selectNoticeListCommon(Map<String,String> formData);

	// [거래사별 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'N')
	public List<Map<String,String>> selectNoticeListCompany(Map<String,String> formData);

	// 공지사항 상세
	public Map<String,String> selectNoticeDetail(Map<String,String> formData);

	// 공지사항 읽음 기록 등록
	public int insertNoticeReadLog(Map<String,String> formData);

	// 공지사항 읽음 여부 체크
	public int selectNoticeReadCount(Map<String,String> formData);

	// 공지사항 등록 (관리자)
	public int insertNotice(Map<String,String> formData);

	// 공지사항 대상 고객사 등록
	public int insertNoticeCustomer(Map<String,String> formData);

	// 공지사항 수정 (관리자)
	public int updateNotice(Map<String,String> formData);

	// 공지사항 대상 고객사 삭제 (수정 시)
	public int deleteNoticeCustomers(Map<String,String> formData);

	// 공지사항 삭제 (관리자)
	public int deleteNotice(Map<String,String> formData);

	// ========================================
	// 1:1 문의(VOC) 관련 - KEPAVCDT
	// ========================================

	// VOC 문의 목록 조회
	public List<Map<String,String>> selectInquiryList(Map<String,String> formData);

	// VOC 문의 상세 조회
	public Map<String,String> selectInquiryDetail(Map<String,String> formData);

	// VOC 유형 코드 조회
	public List<Map<String,String>> selectQtypeCodeList(Map<String,String> formData);

	// VOC 문의 취소
	public int deleteInquiry(Map<String,String> formData);

	// VOC 문의 답변 확인 처리 (KEPAVCDT.ANSWER_READ_DATE 갱신)
	public int updateInquiryRead(Map<String,String> formData);

	// ========================================
	// 내부 공지사항 관련 (BUYERBOARD)
	// ========================================

	// 내부 공지사항 목록 조회
	public List<Map<String,String>> selectInternalNoticeList(Map<String,String> formData);

	// 내부 공지사항 상세 조회
	public Map<String,String> selectInternalNoticeDetail(Map<String,String> formData);

	// 내부 공지사항 등록
	public int insertInternalNotice(Map<String,String> formData);

	// 내부 공지사항 수정
	public int updateInternalNotice(Map<String,String> formData);

	// 내부 공지사항 삭제
	public int deleteInternalNotice(Map<String,String> formData);

	// 내부 공지사항 읽음 기록 등록 (ICOMBOARD_NOTICE_READ 재사용, BTYPE='NTC')
	public int insertInternalNoticeReadLog(Map<String,String> formData);

	// 내부 공지사항 읽음 여부 체크
	public int selectInternalNoticeReadCount(Map<String,String> formData);

	// ========================================
	// 고객사 메인 : 미확인 공지(일반+내부) 건수
	// ========================================

	// 미확인 공지 건수 조회 (TOTAL_UNREAD)
	public Map<String,Object> selectBuyerUnreadNoticeCount(Map<String,String> formData);

}
