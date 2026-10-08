package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpRqBulkQuotationReqDao {
	
	// 프로젝트 조회
	public List<Map<String, String>> selectProjectList(Map<String, String> formData);
	
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  formData);
	
	// 프로젝트 유의사항 조회
	public List<Map<String, String>> selectPrjRemarkList(Map<String, String> formData);

	// 견적 포기
	public String updateGiveupData(Map<String, String> formData);

	// 견적 제출
	public String saveData(Map<String, String> formData, List<Object> gridData);

	//임시저장
	public String updateTempData(Map<String, String> formData, List<Object> gridData);

	// 견적제출 취소
	public String updateCancelSubmit(Map<String, String> formData);

	// (재계약) 동일단가 적용
	public String updateSamePrice(Map<String, String> formData, List<Object> gridData);
	
	// 물류수수료율
	public String selectLogisFee(Map<String, String> formData);


}
