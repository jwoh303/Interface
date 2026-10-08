package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocBizGenerateStatePopService {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocBizGenerateStatePop(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocBuyerGenerateStatePop(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocAgntcmpyGenerateStatePop(Map<String,Object>  formData);
}
