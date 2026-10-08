package com.koreab2b.mro.seller.mcsc.dao;

import java.util.List;
import java.util.Map;

public interface SellerMCSCNoticeDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	// [공통 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'Y')
	public List<Map<String,String>> selectListCommon(Map<String,String> formData);

	// [거래사별 공지사항] 조회 (ALL_CUSTOMER_FLAG = 'N')
	public List<Map<String,String>> selectListCompany(Map<String,String> formData);

	// 조회
	public List<Map<String,String>> selectListPop(Map<String,String> formData);

	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData);

	// ========================================
	// 공지사항 읽음 처리 관련 메소드
	// ========================================

	// 공지사항 읽음 기록 등록
	public int insertNoticeReadLog(Map<String,String> formData);

	// 공지사항 읽음 여부 체크
	public int selectNoticeReadCount(Map<String,String> formData);

	// ========================================
	// 1:1 문의 관련 메소드
	// ========================================

	// 1:1 문의 목록 조회
	public List<Map<String,String>> selectInquiryList(Map<String,String> formData);

	// 1:1 문의 상세 조회 (문의 + 답변)
	public List<Map<String,String>> selectInquiryDetail(Map<String,String> formData);

	// 1:1 문의 조회수 증가
	public int updateInquiryViewCount(Map<String,String> formData);

	// 문의유형 코드 조회
	public List<Map<String,String>> selectQtypeCodeList(Map<String,String> formData);

	// 1:1 문의 등록
	public int insertInquiry(Map<String,String> formData);

	// 1:1 문의 취소
	public int cancelInquiry(Map<String,String> formData);

}
