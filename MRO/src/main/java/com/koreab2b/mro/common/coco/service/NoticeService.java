package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

/**
 * 공지사항 Service 인터페이스
 * 테이블: ICOMBOARD_NOTICE, ICOMBOARD_NOTICE_DT
 */
public interface NoticeService {

	/**
	 * 공지사항 목록 조회 (페이징)
	 * @param pMap 검색조건
	 * @return 공지사항 목록
	 */
	public List<Map<String, String>> noticeList(Map<String, String> pMap);

	/**
	 * 공지사항 상세 조회
	 * @param pMap BID, BTYPE
	 * @return 공지사항 상세정보
	 */
	public Map<String, String> noticeDetail(Map<String, String> pMap);

	/**
	 * 공지사항 대상 고객사 목록 조회
	 * @param pMap BID, BTYPE
	 * @return 대상 고객사 목록
	 */
	public List<Map<String, String>> noticeDetailCustomers(Map<String, String> pMap);

	/**
	 * 공지사항 등록 (대상 고객사 포함)
	 * @param pMap 공지사항 정보 (st_open_company_code: @로 구분된 고객사 코드)
	 */
	public void noticeWrite(Map<String, String> pMap);

	/**
	 * 공지사항 수정 (대상 고객사 포함)
	 * @param pMap 공지사항 정보
	 */
	public void noticeUpdate(Map<String, String> pMap);

	/**
	 * 공지사항 삭제 (대상 고객사 포함)
	 * @param pMap BID, BTYPE
	 */
	public void noticeDelete(Map<String, String> pMap);

	/**
	 * 공지사항 승인/승인취소
	 * @param pMap BID, BTYPE, OPEN_FLAG
	 * @return 처리결과 메시지
	 */
	public String noticeConfirm(Map<String, String> pMap);

	/**
	 * 공지사항 승인 권한 체크
	 * @param userId 사용자 ID
	 * @return 권한 보유 여부
	 */
	public boolean hasApprovalAuth(String userId);

}
