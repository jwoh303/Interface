package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

/**
 * 표준DB 기준가 인하 결재 (DOC_TYPE = BP / BPM)
 *
 * 결재 프레임워크 계약 : KEY_1 = PM_NO, KEY_2 = BUYER, KEY_3 = 상신자 USER_ID.
 */
public interface CommonMdCmBasePriceApprovalDao {

	// 결재대상 조회 (s12 그리드)
	public List<Map<String,String>> selectBasePriceApprList(Map<String,String> param);

	// 결재 완료 : 신청 상태 A + CMSCATLG 반영(이력은 F_HST_CMSCATLG 가 남긴다)
	public String basePriceApprovalA(Map<String,String> param);

	// 반려 : 신청 상태 B. CMSCATLG 는 손대지 않는다
	public String basePriceApprovalB(Map<String,String> param);

	// 상신 취소 : 신청 상태 D. CMSCATLG 는 손대지 않는다
	public String basePriceCancel(Map<String,String> param);
}
