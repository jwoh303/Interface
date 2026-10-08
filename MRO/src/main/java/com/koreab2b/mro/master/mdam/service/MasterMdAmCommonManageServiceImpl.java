package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmCommonManageDao;

@Service("masterMdAmCommonManageService")
public class MasterMdAmCommonManageServiceImpl implements MasterMdAmCommonManageService {
	
	@Autowired
	private MasterMdAmCommonManageDao masterMdAmCommonManageDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmCommonManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmCommonManageDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmCommonManageDao.deleteSelectedData(formData, gridData);
	}
	
	
	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterMdAmCommonManageDao.selectDetailList(param);
	}	

	// 저장(상세)
	@Transactional
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmCommonManageDao.updateSelectedDetailData(formData, gridData);
	}	

	// 삭제(상세)
	@Transactional
	public String delSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmCommonManageDao.deleteSelectedDetailData(formData, gridData);
	}	
}
