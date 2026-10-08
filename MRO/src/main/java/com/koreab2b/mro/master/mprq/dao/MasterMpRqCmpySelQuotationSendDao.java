package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqCmpySelQuotationSendDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 팝업
	public List<Map<String,String>> getMasterMpRqReqUserSelPop(Map<String,Object> param);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 초기화
	public Map<String,String> initSelectedData(Map<String,String>  formData, List<Object> gridData);

	public String rcRequest(Map<String,String>  formData);
	public String rcCancel(Map<String,String>  formData);
	public String rcApproval(Map<String,String>  formData);
	public String rcReject(Map<String,String>  formData);
	public List<Map<String,String>> rcResultList(Map<String,String>  formData);
	
	// 추가정비 요청
	public String updateAfterItemChgReqData(Map<String,String>  formData, List<Object> gridData);
	
	// 추가정비 제출
	public String updateMasterMpRqAfterItmCheSend(Map<String,String>  formData, List<Object> gridData);
	
	// 견적초기화(결재 X)
	public Map<String,String> initNewSelectedData(Map<String,String>  formData, List<Object> gridData);
}
