package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpRestrcCompanyReleasePopDao;

@Service("masterMdCpRestrcCompanyReleasePopService")
public class MasterMdCpRestrcCompanyReleasePopServiceImpl implements MasterMdCpRestrcCompanyReleasePopService {
	@Autowired
	private MasterMdCpRestrcCompanyReleasePopDao masterMdCpRestrcCompanyReleasePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpRestrcCompanyReleasePopDao.selectList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMdmNote(Map<String,String> formData) {
		return masterMdCpRestrcCompanyReleasePopDao.selectMdmList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		return masterMdCpRestrcCompanyReleasePopDao.updateSelectedData(formData);
	}
}
