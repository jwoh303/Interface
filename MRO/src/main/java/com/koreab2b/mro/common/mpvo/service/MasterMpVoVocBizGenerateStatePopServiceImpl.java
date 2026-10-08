package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpvo.dao.MasterMpVoVocBizGenerateStatePopDao;

@Service("masterMpVoVocBizGenerateStatePopServiceImpl")
public class MasterMpVoVocBizGenerateStatePopServiceImpl  implements MasterMpVoVocBizGenerateStatePopService {
	@Autowired
	private MasterMpVoVocBizGenerateStatePopDao masterMpVoVocBizGenerateStatePopDao;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocBizGenerateStatePop(Map<String,Object> formData) {
		return masterMpVoVocBizGenerateStatePopDao.getMasterMpVoVocBizGenerateStatePop(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocBuyerGenerateStatePop(Map<String,Object> formData) {
		return masterMpVoVocBizGenerateStatePopDao.getMasterMpVoVocBuyerGenerateStatePop(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocAgntcmpyGenerateStatePop(Map<String,Object> formData) {
		return masterMpVoVocBizGenerateStatePopDao.getMasterMpVoVocAgntcmpyGenerateStatePop(formData);
	}

}
