package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerQuotationReceiptSendCntPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	// 품목정비 이력
	public List<Map<String,String>> selectQuotationItemMdreqHistList(Map<String,Object> formData);
	// 추가정비 이력
	public List<Map<String,String>> selectQuotationAfterItemMdreqHistList(Map<String,Object> formData);
	// 견적특이사항 조회
	public List<Map<String,String>> selectQuotationRemarkList(Map<String,Object> formData);
	// 견적 특이사항 저장
	public String saveMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData);
	// 견적 특이사항 삭제
	public String delMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData);
	// 네고정비 이력
	public List<Map<String,String>> selectQuotationNegoItemMdreqHistList(Map<String,Object> formData);
	// SG지정 이력
	public List<Map<String,String>> selectQuotationSgDHistList(Map<String,Object> formData);
}
