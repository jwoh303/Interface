package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIvQuotationSendService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getLngtermDelayPopList(Map<String,Object>  formData);
	
	public String setMasterMpIvQuotationSendDelayReasonPop(Map<String,String> pMap);
	
	// 견적지연사유.
	public List<Map<String,String>> getRqdtDelayReasonPop(Map<String,String>  pMap);
	
	// 견적 세부진행상태
	public List<Map<String,String>> getRqdtDelayDetailPop(Map<String,String>  pMap);
}
