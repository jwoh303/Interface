package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqReqNegoReceiptDao {
	
	/*리스트 조회*/
	public List<Map<String,String>> selectList(Map<String,Object> param);

	/*조회*/
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	/*고객사 Nego견적제출*/
	public String negoSelectedData(Map<String,String>  formData, List<Object> gridData);

	/*삭제*/
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 네고정비 요청
	public String updateNegoItemChgReqData(Map<String,String>  formData, List<Object> gridData);
	
	// 네고정비 제출
	public String updateMasterMpRqNegoItmCheSend(Map<String,String>  formData, List<Object> gridData);
}
