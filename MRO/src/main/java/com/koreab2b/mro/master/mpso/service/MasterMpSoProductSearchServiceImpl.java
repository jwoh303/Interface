package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoProductSearchDao;

@Service("masterMpSoProductSearchServiceImpl")
public class MasterMpSoProductSearchServiceImpl implements MasterMpSoProductSearchService {
	
	@Autowired
	private MasterMpSoProductSearchDao masterMpSoProductSearchDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoProductSearchDao.selectList(param);
	}	
	
	// 리스트 조회
	public List<Map<String,String>> getRootTreeList(Map<String,Object> param) {
		return masterMpSoProductSearchDao.selectRootTreeList(param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getChildTreeList(Map<String,Object> param) {
		return masterMpSoProductSearchDao.selectChildTreeList(param);
	}
	
	@Transactional
	public String insertWmsCart(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoProductSearchDao.insertWmsCart(formData, gridData);
	}

}
