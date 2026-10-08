package com.koreab2b.mro.common.coco.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.NoticeDao;
import com.koreab2b.mro.util.CommonUtil;

/**
 * 공지사항 Service 구현체
 * 테이블: ICOMBOARD_NOTICE, ICOMBOARD_NOTICE_DT
 */
@Service("noticeService")
public class NoticeServiceImpl implements NoticeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeServiceImpl.class);

	@Autowired
	private NoticeDao noticeDao;

	/**
	 * 공지사항 목록 조회 (페이징)
	 */
	@Override
	public List<Map<String, String>> noticeList(Map<String, String> pMap) {
		return noticeDao.noticeList(pMap);
	}

	/**
	 * 공지사항 상세 조회
	 */
	@Override
	public Map<String, String> noticeDetail(Map<String, String> pMap) {
		return noticeDao.noticeDetail(pMap);
	}

	/**
	 * 공지사항 대상 고객사 목록 조회
	 */
	@Override
	public List<Map<String, String>> noticeDetailCustomers(Map<String, String> pMap) {
		return noticeDao.noticeDetailCustomers(pMap);
	}

	/**
	 * 공지사항 등록 (대상 고객사 포함)
	 * st_open_company_code: @로 구분된 고객사 코드 (예: "COM001@COM002@COM003")
	 * st_open_company_name: @로 구분된 고객사명 (예: "회사1@회사2@회사3")
	 */
	@Override
	@Transactional
	public void noticeWrite(Map<String, String> pMap) {
		// 디버깅: NOTICE_TYPE 값 확인
		LOGGER.info("========== noticeWrite 파라미터 확인 ==========");
		LOGGER.info("NOTICE_TYPE: [{}]", pMap.get("NOTICE_TYPE"));
		LOGGER.info("ALL_CUSTOMER_FLAG: [{}]", pMap.get("ALL_CUSTOMER_FLAG"));
		LOGGER.info("===============================================");

		// 1. 공지사항 등록
		noticeDao.noticeWrite(pMap);

		// 2. 대상 고객사 등록 (st_open_company_code가 있는 경우)
		String companyCodeStr = CommonUtil.nvl(pMap.get("st_open_company_code"));
		String companyNameStr = CommonUtil.nvl(pMap.get("st_open_company_name"));

		if (!"".equals(companyCodeStr)) {
			String[] companyCodes = companyCodeStr.split("@");
			String[] companyNames = companyNameStr.split("@");

			for (int i = 0; i < companyCodes.length; i++) {
				if (!"".equals(companyCodes[i])) {
					Map<String, String> customerMap = new HashMap<String, String>();
					customerMap.put("BID", pMap.get("BID"));
					customerMap.put("BTYPE", pMap.get("BTYPE"));
					customerMap.put("COMPANY", pMap.get("COMPANY"));
					customerMap.put("COM_CODE", companyCodes[i]);
					customerMap.put("COM_NAME", (i < companyNames.length) ? companyNames[i] : "");
					customerMap.put("REG_USER_ID", pMap.get("REG_USER_ID"));

					noticeDao.noticeWriteCustomer(customerMap);
				}
			}

			LOGGER.info("공지사항 대상 고객사 {} 건 등록 - BID: {}", companyCodes.length, pMap.get("BID"));
		}
	}

	/**
	 * 공지사항 수정 (대상 고객사 포함)
	 * 기존 대상 고객사 삭제 후 재등록
	 */
	@Override
	@Transactional
	public void noticeUpdate(Map<String, String> pMap) {
		// 디버깅: NOTICE_TYPE 값 확인
		LOGGER.info("========== noticeUpdate 파라미터 확인 ==========");
		LOGGER.info("NOTICE_TYPE: [{}]", pMap.get("NOTICE_TYPE"));
		LOGGER.info("ALL_CUSTOMER_FLAG: [{}]", pMap.get("ALL_CUSTOMER_FLAG"));
		LOGGER.info("===============================================");

		// 1. 공지사항 수정
		noticeDao.noticeUpdate(pMap);

		// 2. 기존 대상 고객사 삭제
		noticeDao.noticeDeleteCustomers(pMap);

		// 3. 대상 고객사 재등록 (st_open_company_code가 있는 경우)
		String companyCodeStr = CommonUtil.nvl(pMap.get("st_open_company_code"));
		String companyNameStr = CommonUtil.nvl(pMap.get("st_open_company_name"));

		if (!"".equals(companyCodeStr)) {
			String[] companyCodes = companyCodeStr.split("@");
			String[] companyNames = companyNameStr.split("@");

			for (int i = 0; i < companyCodes.length; i++) {
				if (!"".equals(companyCodes[i])) {
					Map<String, String> customerMap = new HashMap<String, String>();
					customerMap.put("BID", pMap.get("BID"));
					customerMap.put("BTYPE", pMap.get("BTYPE"));
					customerMap.put("COMPANY", pMap.get("COMPANY"));
					customerMap.put("COM_CODE", companyCodes[i]);
					customerMap.put("COM_NAME", (i < companyNames.length) ? companyNames[i] : "");
					customerMap.put("REG_USER_ID", pMap.get("REG_USER_ID"));

					noticeDao.noticeWriteCustomer(customerMap);
				}
			}

			LOGGER.info("공지사항 대상 고객사 {} 건 재등록 - BID: {}", companyCodes.length, pMap.get("BID"));
		}
	}

	/**
	 * 공지사항 삭제 (대상 고객사 포함)
	 */
	@Override
	@Transactional
	public void noticeDelete(Map<String, String> pMap) {
		noticeDao.noticeDelete(pMap);
	}

	/**
	 * 공지사항 승인/승인취소
	 */
	@Override
	public String noticeConfirm(Map<String, String> pMap) {
		return noticeDao.noticeConfirm(pMap);
	}

	/**
	 * 공지사항 승인 권한 체크
	 */
	@Override
	public boolean hasApprovalAuth(String userId) {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("USER_ID", userId);
		return noticeDao.checkBoardApprovalAuth(pMap) > 0;
	}

}
