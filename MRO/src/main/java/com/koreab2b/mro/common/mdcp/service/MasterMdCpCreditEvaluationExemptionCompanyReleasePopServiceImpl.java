package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpCreditEvaluationExemptionCompanyReleasePopDao;

@Service("masterMdCpCreditEvaluationExemptionCompanyReleasePopService")

public class MasterMdCpCreditEvaluationExemptionCompanyReleasePopServiceImpl implements MasterMdCpCreditEvaluationExemptionCompanyReleasePopService {
	@Autowired
	private MasterMdCpCreditEvaluationExemptionCompanyReleasePopDao masterMdCpCreditEvaluationExemptionCompanyReleasePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpCreditEvaluationExemptionCompanyReleasePopDao.selectList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getMdmNote(Map<String,String> formData) {
		return masterMdCpCreditEvaluationExemptionCompanyReleasePopDao.selectMdmList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		return masterMdCpCreditEvaluationExemptionCompanyReleasePopDao.updateSelectedData(formData);
	}
}
