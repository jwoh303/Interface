package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

/**
 * 공지사항 DAO 구현체
 * 테이블: ICOMBOARD_NOTICE, ICOMBOARD_NOTICE_DT
 */
@Repository("noticeDao")
@Transactional
public class NoticeDaoImpl implements NoticeDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 공지사항 목록 조회 (페이징)
	 */
	@Override
	public List<Map<String, String>> noticeList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("notice.noticeList", pMap);
	}

	/**
	 * 공지사항 상세 조회
	 */
	@Override
	public Map<String, String> noticeDetail(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("notice.noticeDetail", pMap);
	}

	/**
	 * 공지사항 대상 고객사 목록 조회
	 */
	@Override
	public List<Map<String, String>> noticeDetailCustomers(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("notice.noticeDetailCustomers", pMap);
	}

	/**
	 * 공지사항 등록
	 */
	@Override
	@Transactional
	public void noticeWrite(Map<String, String> pMap) {
		// 등록일시 설정
		pMap.put("REG_DATE", DateTimeUtil.getFormatString("yyyyMMdd"));
		pMap.put("REG_TIME", DateTimeUtil.getFormatString("HHmmss"));

		// 디버깅: 체크박스 관련 파라미터 확인
		LOGGER.info("공지사항 등록 파라미터 - IMPORTANT_FLAG: [" + pMap.get("IMPORTANT_FLAG")
				+ "], ALWAYS_SHOW_FLAG: [" + pMap.get("ALWAYS_SHOW_FLAG")
				+ "], ALL_CUSTOMER_FLAG: [" + pMap.get("ALL_CUSTOMER_FLAG") + "]");

		// 공지사항 INSERT (BID는 selectKey로 자동 생성)
		sqlSessionTemplate.insert("notice.noticeWrite", pMap);

		// 파일 업로드 플래그 업데이트
		String imageKey = CommonUtil.nvl(pMap.get("IMAGE_KEY"));
		if (!"".equals(imageKey)) {
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", pMap);
		}

		LOGGER.info("공지사항 등록 완료 - BID: {}", pMap.get("BID"));
	}

	/**
	 * 공지사항 대상 고객사 등록
	 */
	@Override
	public void noticeWriteCustomer(Map<String, String> pMap) {
		// 등록일시 설정
		pMap.put("REG_DATE", DateTimeUtil.getFormatString("yyyyMMdd"));

		sqlSessionTemplate.insert("notice.noticeWriteCustomer", pMap);
	}

	/**
	 * 공지사항 수정
	 */
	@Override
	@Transactional
	public void noticeUpdate(Map<String, String> pMap) {
		// 디버깅: 체크박스 관련 파라미터 확인
		LOGGER.info("공지사항 수정 파라미터 - BID: [" + pMap.get("BID")
				+ "], IMPORTANT_FLAG: [" + pMap.get("IMPORTANT_FLAG")
				+ "], ALWAYS_SHOW_FLAG: [" + pMap.get("ALWAYS_SHOW_FLAG")
				+ "], ALL_CUSTOMER_FLAG: [" + pMap.get("ALL_CUSTOMER_FLAG") + "]");

		sqlSessionTemplate.update("notice.noticeUpdate", pMap);

		// 파일 업로드 플래그 업데이트
		String imageKey = CommonUtil.nvl(pMap.get("IMAGE_KEY"));
		if (!"".equals(imageKey)) {
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", pMap);
		}

		LOGGER.info("공지사항 수정 완료 - BID: {}", pMap.get("BID"));
	}

	/**
	 * 공지사항 대상 고객사 삭제 (BID 기준 전체 삭제)
	 */
	@Override
	public void noticeDeleteCustomers(Map<String, String> pMap) {
		sqlSessionTemplate.delete("notice.noticeDeleteCustomers", pMap);
	}

	/**
	 * 공지사항 삭제
	 */
	@Override
	@Transactional
	public void noticeDelete(Map<String, String> pMap) {
		// 대상 고객사 먼저 삭제
		sqlSessionTemplate.delete("notice.noticeDeleteStatusCustomers", pMap);
		// 공지사항 삭제
		sqlSessionTemplate.delete("notice.noticeDelete", pMap);

		LOGGER.info("공지사항 삭제 완료 - BID: {}", pMap.get("BID"));
	}

	/**
	 * 공지사항 승인/승인취소
	 */
	@Override
	public String noticeConfirm(Map<String, String> pMap) {
		sqlSessionTemplate.update("notice.noticeConfirm", pMap);

		String openFlag = CommonUtil.nvl(pMap.get("OPEN_FLAG"));
		String msg = "Y".equals(openFlag) ? "승인되었습니다." : "승인취소되었습니다.";

		LOGGER.info("공지사항 {} - BID: {}", msg, pMap.get("BID"));
		return msg;
	}

	/**
	 * 공지사항 승인 권한 체크
	 */
	@Override
	public int checkBoardApprovalAuth(Map<String, String> pMap) {
		Integer result = sqlSessionTemplate.selectOne("notice.checkBoardApprovalAuth", pMap);
		return (result != null) ? result.intValue() : 0;
	}

}
