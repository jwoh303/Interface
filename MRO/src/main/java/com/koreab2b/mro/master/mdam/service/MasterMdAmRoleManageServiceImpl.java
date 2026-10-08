package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmRoleManageDao;

@Service("masterMdAmRoleManageService")
public class MasterMdAmRoleManageServiceImpl implements MasterMdAmRoleManageService {
	
	@Autowired
	private MasterMdAmRoleManageDao masterMdAmRoleManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmRoleManageDao.selectList(param);
	}	

	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterMdAmRoleManageDao.selectDetailList(param);
	}	

	// 저장(상세)
	@Transactional
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmRoleManageDao.updateSelectedDetailData(formData, gridData);
	}	

	// 삭제(상세)
	@Transactional
	public String delSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmRoleManageDao.deleteSelectedDetailData(formData, gridData);
	}	
}
