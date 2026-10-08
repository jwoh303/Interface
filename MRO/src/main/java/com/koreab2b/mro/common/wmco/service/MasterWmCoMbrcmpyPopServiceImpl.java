package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoMbrcmpyPopDao;

@Service("masterWmCoMbrcmpyPopService")
public class MasterWmCoMbrcmpyPopServiceImpl implements MasterWmCoMbrcmpyPopService {
	
	@Autowired
	private MasterWmCoMbrcmpyPopDao masterWmCoMbrcmpyPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getCountList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectCountList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getIKList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectIKList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getSingleList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectSingleList(formData);
	}
	
	// 일괄출고지시 고객사 조회
	public List<Map<String,String>> getBpIKList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectBpIKList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getNewIKList(Map<String,Object> formData) {
		return masterWmCoMbrcmpyPopDao.selectNewIKList(formData);
	}
}
