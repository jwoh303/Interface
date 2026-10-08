package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIvQuotationSendDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectLngtermDelayPopList(Map<String,Object> formData);
	
	public String insertMasterMpIvQuotationSendDelayReasonPop(Map<String,String> pMap);
	
	// 견적지연사유
	public List<Map<String,String>> getRqdtDelayReasonPop(Map<String,String>  pMap);
	
	// 견적 세부진행상태
	public List<Map<String,String>> getRqdtDelayDetailPop(Map<String,String>  pMap);
}
