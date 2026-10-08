package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMenuManageDao;

@Service("masterMdAmMenuManageService")
public class MasterMdAmMenuManageServiceImpl implements MasterMdAmMenuManageService {
	
	@Autowired
	private MasterMdAmMenuManageDao masterMdAmMenuManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmMenuManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMenuManageDao.updateSelectedData(formData, gridData);
	}	

	
	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterMdAmMenuManageDao.selectDetailList(param);
	}	

	// 저장(상세)
	@Transactional
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMenuManageDao.updateSelectedDetailData(formData, gridData);
	}	

	// 삭제(상세)
	@Transactional
	public String delSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMenuManageDao.deleteSelectedDetailData(formData, gridData);
	}	
}
