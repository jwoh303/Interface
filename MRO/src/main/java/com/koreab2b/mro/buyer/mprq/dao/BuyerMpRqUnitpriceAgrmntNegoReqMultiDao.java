package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqUnitpriceAgrmntNegoReqMultiDao {

	// 조회
	public List<Map<String,String>> selectListMulti(Map<String,String> formData);
	public List<Map<String,String>> getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(Map<String,Object> formData);
	
	// 저장
	public String updateSelectedDataMulti(Map<String,String> formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntMulti(Map<String,String> formData, List<Object> gridData);
	// 견적종료
	public Map<String,String> saveBuyerMpRqCloseRemarkMulti(Map<String,String> formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPassMulti(Map<String,String> formData, List<Object> gridData);
	                                     
	
	public String nsRequestMulti(Map<String,String>  formData);
	public String nsCancelMulti(Map<String,String>  formData);
	public String nsApprovalMulti(Map<String,String>  formData);
	public String nsRejectMulti(Map<String,String>  formData);
	public List<Map<String,String>> nsResultListMulti(Map<String,String>  formData);
}
