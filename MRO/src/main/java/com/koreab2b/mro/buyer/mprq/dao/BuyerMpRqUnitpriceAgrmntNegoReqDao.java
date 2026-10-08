package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqUnitpriceAgrmntNegoReqDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	// 취소
	public String updateSelectedCancleData(Map<String,String> formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmnt(Map<String,String> formData, List<Object> gridData);
	// 견적종료
	public Map<String,String> saveBuyerMpRqCloseRemark(Map<String,String> formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPass(Map<String,String> formData, List<Object> gridData);
	// 결재상신
	public Map<String,String> getAppSendList(Map<String,String> formData, List<Object> gridData);
	
	public String nsRequest(Map<String,String>  formData);
	public String nsCancel(Map<String,String>  formData);
	public String nsApproval(Map<String,String>  formData);
	public String nsReject(Map<String,String>  formData);
	public List<Map<String,String>> nsResultList(Map<String,String>  formData);
	public List<Map<String,String>> nsResultList_v2(Map<String,Object>  formData);
	
	// 단가합의 비고
	public Map<String, String> saveBuyerMpRqUnitpriceAgrmntNegoReqPop(Map<String, String> formData);
	
	// 취소
	public String updateSelectedCancleData_v2(Map<String,String> formData, List<Object> gridData);
	// 견적합의대상 _v2
	public List<Map<String, String>> selectList_v2(Map<String, Object> formData);
	// 저장(네고요청)_v2
	public String updateSelectedData_v2(Map<String, String> _pMap, List<Object> _list);
}
