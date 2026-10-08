package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationReceiptSendDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 네고
	public Map<String,String> negoQuotationReceiptSend(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

	public List<Map<String,String>> getListHd(Map<String,Object> formData);
	
	public String negoRequest(Map<String,String>  formData);
	public String negoCancel(Map<String,String>  formData);
	public String negoApproval(Map<String,String>  formData);
	public String negoReject(Map<String,String>  formData);
	public List<Map<String,String>> negoResultList(Map<String,String> param);
	
}
