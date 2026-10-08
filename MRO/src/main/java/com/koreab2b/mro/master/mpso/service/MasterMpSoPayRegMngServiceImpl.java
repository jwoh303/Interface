package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoPayRegMngDao;

@Service("masterMpSoPayRegMngService")
public class MasterMpSoPayRegMngServiceImpl implements MasterMpSoPayRegMngService {
	
	@Autowired
	private MasterMpSoPayRegMngDao masterMpSoSubmitIssueDao;
  
	
	// 리스트조회
	public List<Map<String,String>> getMasterMpSoPayRegMngList(Map<String,Object>  param) {
		return masterMpSoSubmitIssueDao.getMasterMpSoPayRegMngList(param);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoSubmitIssueDao.updateSelectedData(formData, gridData);		
	}
	
	// 예정일 변경 사유 저장
	public String saveRemark(Map<String, String> param) {
		return masterMpSoSubmitIssueDao.saveRemark(param);
	}

	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoSubmitIssueDao.deleteSelectedData(formData, gridData);	
	}

	// 품의 상신
	public String approvalSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoSubmitIssueDao.approvalSelectedData(formData, gridData);	
	}

}
