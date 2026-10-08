package com.koreab2b.mro.common.cmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.cmco.dao.MasterCmCoSelectboxSettingComboPopDao;

@Service("masterCmCoSelectboxSettingComboPopService")
public class MasterCmCoSelectboxSettingComboPopServiceImpl implements MasterCmCoSelectboxSettingComboPopService {
	
	@Autowired
	private MasterCmCoSelectboxSettingComboPopDao masterCmCoSelectboxSettingComboPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterCmCoSelectboxSettingComboPopDao.selectList(formData);
	}	
	

}
