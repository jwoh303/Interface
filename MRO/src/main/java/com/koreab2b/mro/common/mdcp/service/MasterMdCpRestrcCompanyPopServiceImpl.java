package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpRestrcCompanyPopDao;

@Service("masterMdCpRestrcCompanyPopService")
public class MasterMdCpRestrcCompanyPopServiceImpl implements MasterMdCpRestrcCompanyPopService {
	
	@Autowired
	private MasterMdCpRestrcCompanyPopDao masterMdCpRestrcCompanyPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpRestrcCompanyPopDao.selectList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMdmList(Map<String,String> formData) {
		return masterMdCpRestrcCompanyPopDao.selectMdmList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		return masterMdCpRestrcCompanyPopDao.updateSelectedData(formData);
	}
	

}
