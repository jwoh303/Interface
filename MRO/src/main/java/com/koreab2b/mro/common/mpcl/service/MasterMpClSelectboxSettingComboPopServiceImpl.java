package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.MasterMpClSelectboxSettingComboPopDao;

@Service("masterMpClSelectboxSettingComboPopService")
public class MasterMpClSelectboxSettingComboPopServiceImpl implements MasterMpClSelectboxSettingComboPopService {
	
	@Autowired
	private MasterMpClSelectboxSettingComboPopDao masterMpClSelectboxSettingComboPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpClSelectboxSettingComboPopDao.selectList(formData);
	}	
	

}
