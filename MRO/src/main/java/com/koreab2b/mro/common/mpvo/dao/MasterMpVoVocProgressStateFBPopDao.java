package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocProgressStateFBPopDao {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStatePop(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStateFBPop(Map<String,Object> formData);
	
	// 저장
	public String saveMasterMpVoVocDsUserInfo(Map<String,String>  formData);
	
	// 저장
	public String saveMasterMpVoVocProgressStatePop(Map<String,String>  formData);
	
	// 저장
	public String saveMasterMpVoVocProgressStateFbChangePop(Map<String,String>  formData);
	
	// VOC 이력
	public List<Map<String, String>> getMasterMpVoVocHistPop(Map<String, Object> formData);
	
	// VOC 이력 저장
	public int saveVocRevisionPop(Map<String, String> formData);
	// VOC 이력 저장시 update
	public String updateMasterMpVoVocProgressStateReReqPop(Map<String, String> formData);
	// VOC 중간 저장
	public String saveMasterMpVoVocProgressPCPop(Map<String,String>  formData);

}
