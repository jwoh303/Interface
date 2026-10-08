package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

/**
 * 표준DB 구매정보 매입단가 인상 결재 (DOC_TYPE = SP 단건 / SPM 일괄)
 *
 * ★ 매입단가는 인상이 결재, 인하는 즉시 반영이다. 기준가(BP/BPM)와 반대다.
 * 결재 프레임워크 계약 : KEY_1 = PM_NO, KEY_2 = BUYER, KEY_3 = 상신자 USER_ID.
 */
public interface CommonMdCmBuyPriceApprovalDao {

	// 결재대상 조회
	public List<Map<String,String>> selectBuyPriceApprList(Map<String,String> param);

	// 결재 완료 : 신청 상태 A + CMSPRICE 반영(이력은 F_HST_CMSPRICE 가 남긴다)
	public String buyPriceApprovalA(Map<String,String> param);

	// 반려 : 신청 상태 B. CMSPRICE 는 손대지 않는다
	public String buyPriceApprovalB(Map<String,String> param);

	// 상신 취소 : 신청 상태 D. CMSPRICE 는 손대지 않는다
	public String buyPriceCancel(Map<String,String> param);
}
