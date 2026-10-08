package com.koreab2b.mro.master.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcp.dao.MasterMdCpSAgntcmpyRegManageDao;

@Service("masterMdCpSAgntcmpyRegManageService")
public class MasterMdCpSAgntcmpyRegManageServiceImpl implements MasterMdCpSAgntcmpyRegManageService {
	
	@Autowired
	private MasterMdCpSAgntcmpyRegManageDao masterMdCpSAgntcmpyRegManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCpSAgntcmpyRegManageDao.selectList(param);
	}
	
	// 리스트 조회
	public Map<String, String> getSAgentList(Map<String,String> param) {
		return masterMdCpSAgntcmpyRegManageDao.selectSAgentList(param);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSAgntcmpyRegManageDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSAgntcmpyRegManageDao.deleteSelectedData(formData, gridData);
	}
}
