package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqCmpySelQuotationSendService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 팝업
	public List<Map<String,String>> getMasterMpRqReqUserSelPop(Map<String,Object>  param);
	
	// 견적취소
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 저장
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 견적초기화
	public Map<String,String> initSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 추가정비 요청
	public String updateAfterItemChgReqData(Map<String,String>  formData, List<Object> gridData);
	
	// 추가정비 제출
	public String updateMasterMpRqAfterItmCheSend(Map<String,String>  formData, List<Object> gridData);
	
	// 견적초기화(결재 X)
	public Map<String,String> initNewSelectedData(Map<String,String>  formData, List<Object> gridData);
}
