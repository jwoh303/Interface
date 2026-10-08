package com.koreab2b.mro.master.mdpp.service;

import java.util.List;
import java.util.Map;

public interface MasterMdPpPropListService {
	
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 상세 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropDetailPop(Map<String,Object>  formData);
	
	// 평가 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropArpsPop(Map<String,Object>  formData);
	
	// 평가
	public String saveMasterMdPpPropArps(Map<String,String>  pMap);

	// 불채택
	public String rejectMasterMdPpPropArps(Map<String,String>  pMap);
	
	// 불채택 사유 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropRejectPop(Map<String,Object>  formData);
}
