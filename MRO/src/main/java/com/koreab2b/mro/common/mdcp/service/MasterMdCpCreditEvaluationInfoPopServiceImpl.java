package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpCreditEvaluationInfoPopDao;

@Service("masterMdCpCreditEvaluationInfoPopService")
public class MasterMdCpCreditEvaluationInfoPopServiceImpl implements MasterMdCpCreditEvaluationInfoPopService {
	
	@Autowired
	private MasterMdCpCreditEvaluationInfoPopDao masterMdCpCreditEvaluationInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpCreditEvaluationInfoPopDao.selectList(formData);
	}	
	

}
