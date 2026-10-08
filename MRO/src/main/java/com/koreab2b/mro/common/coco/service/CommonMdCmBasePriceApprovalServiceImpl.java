package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;
import com.koreab2b.mro.common.coco.dao.CommonMdCmBasePriceApprovalDao;

/**
 * 표준DB 기준가 인하 결재 (DOC_TYPE = BP 단건 / BPM 일괄)
 *
 * 상신·승인·반려·취소의 공통 처리는 CommonApprovalDao 가 맡고,
 * 업무 반영(신청 상태 + CMSCATLG 기준가)만 여기서 붙인다. SCA(표준카탈로그등록) 계열과 같은 구조다.
 */
@Service("CommonMdCmBasePriceApprovalService")
@Transactional
public class CommonMdCmBasePriceApprovalServiceImpl implements CommonMdCmBasePriceApprovalService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonMdCmBasePriceApprovalServiceImpl.class);

	@Autowired
	private CommonApprovalDao commonApprovalDao;

	@Autowired
	private CommonMdCmBasePriceApprovalDao commonMdCmBasePriceApprovalDao;

	/**
	 * 결재 / 반려.
	 *
	 * 공통 approval() 이 돌려주는 pass_status :
	 *   9 임시저장 / 0 결재중 / 1 반려 / 2 참조진행 / 3 결재완료
	 *
	 * ★ 기준가는 "3(결재완료)" 일 때만 CMSCATLG 에 반영한다.
	 *   상신·중간결재 시점에 반영하면 반려된 건까지 이력에 남는다.
	 */
	public String approval(Map<String, String> _pMap) {

		String pass_status = commonApprovalDao.approval(_pMap); // 결재,반려 공통

		LOGGER.debug("기준가 결재 pass_status : {}", pass_status);

		if ("3".equals(pass_status)) {          // 결재 완료 -> 기준가 반영
			commonMdCmBasePriceApprovalDao.basePriceApprovalA(_pMap);
		} else if ("1".equals(pass_status)) {   // 반려 -> 신청만 B 로 닫는다
			commonMdCmBasePriceApprovalDao.basePriceApprovalB(_pMap);
		}
		return "OK";
	}

	public String cancel(Map<String, String> _pMap) {
		String status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
		commonMdCmBasePriceApprovalDao.basePriceCancel(_pMap);
		return status;
	}

	public String request(Map<String, String> _pMap) {
		_pMap.put("KEY_2", _pMap.get("PARAM1"));  // 회사코드
		_pMap.put("KEY_3", _pMap.get("PARAM2"));  // 상신자
		String DOCU_NO = commonApprovalDao.request(_pMap); // 상신 공통
		return DOCU_NO;
	}

	public List<Map<String,String>> getApprList(Map<String, String> _pMap) {
		return commonMdCmBasePriceApprovalDao.selectBasePriceApprList(_pMap);
	}
}
