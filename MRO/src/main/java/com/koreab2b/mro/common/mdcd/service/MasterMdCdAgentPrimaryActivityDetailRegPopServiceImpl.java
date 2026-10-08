package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcd.dao.MasterMdCdAgentPrimaryActivityDetailRegPopDao;

@Service("masterMdCdAgentPrimaryActivityDetailRegPopService")
public class MasterMdCdAgentPrimaryActivityDetailRegPopServiceImpl implements MasterMdCdAgentPrimaryActivityDetailRegPopService {
	
	@Autowired
	private MasterMdCdAgentPrimaryActivityDetailRegPopDao masterMdCdAgentPrimaryActivityDetailRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCdAgentPrimaryActivityDetailRegPopDao.selectList(formData);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdCdAgentPrimaryActivityDetailRegPopDao.updateSelectedData(formData);
	}
}
