package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocProgressStateFBPopService {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStatePop(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStateFBPop(Map<String,Object>  formData);
	
	// 저장
	public String saveMasterMpVoVocDsUserInfo(Map<String,String>  formData);
	
	// 저장
	public String saveMasterMpVoVocProgressStatePop(Map<String,String>  formData);
	
	// 저장
	public String saveMasterMpVoVocProgressStateFbChangePop(Map<String,String>  formData);
	
	// VOC차수 팝업
	public List<Map<String,String>> getMasterMpVoVocHistPop(Map<String,Object>  formData);
	
	// VOC 재요청 저장
	public int saveVocRevisionPop(Map<String, String>  pMap);
	
	// VOC 재요청 저장시 update
	public String updateVocRevisionPop(Map<String, String> formData);
	
	// VOC중간 저장
	public String saveMasterMpVoVocProgressPCPop(Map<String,String>  formData);
}
