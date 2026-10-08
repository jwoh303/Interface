package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpvo.dao.MasterMpVoVocCompanyPopDao;

@Service("masterMpVoVocCompanyPopServiceImpl")
public class MasterMpVoVocCompanyPopServiceImpl implements MasterMpVoVocCompanyPopService {
	
	@Autowired
	private MasterMpVoVocCompanyPopDao masterMpVoVocCompanyPopDao;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocCompanyPop(Map<String,Object> formData) {
		return masterMpVoVocCompanyPopDao.getMasterMpVoVocCompanyPop(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocAgntcmpyPop(Map<String,Object> formData) {
		return masterMpVoVocCompanyPopDao.getMasterMpVoVocAgntcmpyPop(formData);
	}
}
