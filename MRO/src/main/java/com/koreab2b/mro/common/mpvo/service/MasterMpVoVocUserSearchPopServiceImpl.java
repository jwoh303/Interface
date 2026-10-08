package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpvo.dao.MasterMpVoVocUserSearchPopDao;

@Service("masterMpVoVocUserSearchPopServiceImpl")
public class MasterMpVoVocUserSearchPopServiceImpl implements MasterMpVoVocUserSearchPopService {
	@Autowired
	private MasterMpVoVocUserSearchPopDao masterMpVoVocUserSearchPopDao;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocUserSearchPop(Map<String,Object> formData) {
		return masterMpVoVocUserSearchPopDao.getMasterMpVoVocUserSearchPop(formData);
	}
}
