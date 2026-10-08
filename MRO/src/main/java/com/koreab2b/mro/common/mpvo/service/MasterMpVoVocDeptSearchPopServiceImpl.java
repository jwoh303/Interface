package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpvo.dao.MasterMpVoVocDeptSearchPopDao;

@Service("masterMpVoVocDeptSearchPopServiceImp")
public class MasterMpVoVocDeptSearchPopServiceImpl implements MasterMpVoVocDeptSearchPopService {
	@Autowired
	private MasterMpVoVocDeptSearchPopDao masterMpVoVocDeptSearchPopDao;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocDeptSearchPop(Map<String,Object> formData) {
		return masterMpVoVocDeptSearchPopDao.getMasterMpVoVocDeptSearchPop(formData);
	}

}
