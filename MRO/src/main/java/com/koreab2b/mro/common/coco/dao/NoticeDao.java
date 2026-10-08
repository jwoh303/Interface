package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

/**
 * 공지사항 DAO 인터페이스
 * 테이블: ICOMBOARD_NOTICE, ICOMBOARD_NOTICE_DT
 */
public interface NoticeDao {

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
	 * 공지사항 등록
	 * @param pMap 공지사항 정보
	 */
	public void noticeWrite(Map<String, String> pMap);

	/**
	 * 공지사항 대상 고객사 등록
	 * @param pMap 대상 고객사 정보
	 */
	public void noticeWriteCustomer(Map<String, String> pMap);

	/**
	 * 공지사항 수정
	 * @param pMap 공지사항 정보
	 */
	public void noticeUpdate(Map<String, String> pMap);

	/**
	 * 공지사항 대상 고객사 삭제 (BID 기준 전체 삭제)
	 * @param pMap BID, BTYPE
	 */
	public void noticeDeleteCustomers(Map<String, String> pMap);

	/**
	 * 공지사항 삭제
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
	 * @param pMap USER_ID
	 * @return 권한 보유 시 1 이상, 없으면 0
	 */
	public int checkBoardApprovalAuth(Map<String, String> pMap);

}
