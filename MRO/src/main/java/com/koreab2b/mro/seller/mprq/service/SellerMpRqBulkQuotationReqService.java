package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

public interface SellerMpRqBulkQuotationReqService {
	
	// 프로젝트 조회
	public List<Map<String, String>> getProejctList(Map<String, String> formData);
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 프로젝트 유의사항
	public List<Map<String, String>> getProjectRemark(Map<String, String> formData);
	
	// 견적포기
	public String giveupSellerMpRqBulklQuotationReq(Map<String, String> formData);

	// 견적 제출
	public String updateSellerMpRqBulkQuotationReq(Map<String, String> formData,List<Object> gridData);
	
	//임시저장
	public String updateSellerMpRqBulkQuotationReqTemp(Map<String, String> formData,List<Object> gridData);

	// 제출 취소
	public String updateSellerMpRqBulkQuotationReqCancelSubmit(Map<String, String> formData);

	// 동일단가 적용
	public String updateSellerMpRqBulkQuotationReqSamePrice(Map<String, String> formData, List<Object> gridData);

	// 물류수수료율
	public String getLogisFee(Map<String, String> formData);


}
