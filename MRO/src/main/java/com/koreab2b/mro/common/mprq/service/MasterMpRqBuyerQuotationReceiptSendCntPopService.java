package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerQuotationReceiptSendCntPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	// 품목정비 이력
	public List<Map<String,String>> getQuotationItemMdreqHistList(Map<String,Object>  formData);
	// 추가정비 이력
	public List<Map<String,String>> getQuotationAfterItemMdreqHistList(Map<String,Object>  formData);
	// 견적특이사항 조회
	public List<Map<String,String>> getMasterMpRqQuotationRemarkList(Map<String,Object>  formData);
	// 저장
	public String saveMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData);
	// 삭제
	public String delMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData);
	// 네고정비 이력
	public List<Map<String,String>> getQuotationNegoItemMdreqHistList(Map<String,Object>  formData);
	// SG지정 이력
	public List<Map<String,String>> getQuotationSgDHistList(Map<String,Object>  formData);
}
