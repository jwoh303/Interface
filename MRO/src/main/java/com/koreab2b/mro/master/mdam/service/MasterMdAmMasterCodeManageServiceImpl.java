package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMasterCodeManageDao;

@Service("masterMdAmMasterCodeManageService")
public class MasterMdAmMasterCodeManageServiceImpl implements MasterMdAmMasterCodeManageService {
	
	@Autowired
	private MasterMdAmMasterCodeManageDao masterMdAmMasterCodeManageDao;

	// 코드 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmMasterCodeManageDao.selectList(param);
	}
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return masterMdAmMasterCodeManageDao.selectList_v2(param);
	}	

	// 코드 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMasterCodeManageDao.updateSelectedData(formData, gridData);
	}	

	// 코드 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMasterCodeManageDao.deleteSelectedData(formData, gridData);
	}
}
