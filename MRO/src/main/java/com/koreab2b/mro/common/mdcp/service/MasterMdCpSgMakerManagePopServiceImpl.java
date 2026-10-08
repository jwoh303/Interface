package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpSgMakerManagePopDao;

@Service("masterMdCpSgMakerManagePopService")
public class MasterMdCpSgMakerManagePopServiceImpl implements MasterMdCpSgMakerManagePopService {
	@Autowired
	private MasterMdCpSgMakerManagePopDao masterMdCpSgMakerManagePopDao;

	// 조회
	public List<Map<String,String>> getCompyList(Map<String,String> formData) {
		return masterMdCpSgMakerManagePopDao.selectCompyList(formData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getKepSgList(Map<String,Object> param) {
		return masterMdCpSgMakerManagePopDao.selectKepSgList(param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getKepMkList(Map<String,Object> param) {
		return masterMdCpSgMakerManagePopDao.selectKepMkList(param);
	}
	
	// 저장
	@Transactional
	public String updateRemarkData(Map<String,String>  formData) {
		return masterMdCpSgMakerManagePopDao.updateRemarkData(formData);
	}

	// 저장
	@Transactional
	public String updateKepMkData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManagePopDao.updateKepMkData(formData, gridData);
	}
	
	// MK승인
	@Transactional
	public String updateConfMkData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManagePopDao.updateConfMkData(formData, gridData);
	}
	
	// MK복원
	@Transactional
	public String updateModMkData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManagePopDao.updateModMkData(formData, gridData);
	}
	
	// SG삭제
	@Transactional
	public String deleteKepSgData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManagePopDao.deleteKepSgData(formData, gridData);
	}
	
	// MK삭제
	@Transactional
	public String deleteKepMkData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManagePopDao.deleteKepMkData(formData, gridData);
	}

}
