package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmUserManageDao;

@Service("masterMdAmUserManageService")
public class MasterMdAmUserManageServiceImpl implements MasterMdAmUserManageService {
	
	@Autowired
	private MasterMdAmUserManageDao masterMdAmUserManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmUserManageDao.selectList(param);
	}	

	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterMdAmUserManageDao.selectDetailList(param);
	}	

	// 저장(상세)
	@Transactional
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmUserManageDao.updateSelectedDetailData(formData, gridData);
	}	

	// 삭제(상세)
	@Transactional
	public String delSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmUserManageDao.deleteSelectedDetailData(formData, gridData);
	}	
}
