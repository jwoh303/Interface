package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfDivsnPopDao;

@Service("masterMpIfDivsnPopService")
public class MasterMpIfDivsnPopServiceImpl implements MasterMpIfDivsnPopService {
	
	@Autowired
	private MasterMpIfDivsnPopDao masterMpIfDivsnPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfDivsnPopDao.selectList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getDivsnList(Map<String,String> formData) {
		return masterMpIfDivsnPopDao.selectDivsnList(formData);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfDivsnPopDao.updateSelectedData(formData, gridData);
	}
		
	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfDivsnPopDao.deleteSelectedData(formData, gridData);
	}
}
