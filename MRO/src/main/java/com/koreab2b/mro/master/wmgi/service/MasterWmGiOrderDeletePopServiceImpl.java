package com.koreab2b.mro.master.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgi.dao.MasterWmGiOrderDeleteDao;
import com.koreab2b.mro.master.wmgi.dao.MasterWmGiOrderDeletePopDao;

@Service("masterWmGiOrderDeletePopService")
public class MasterWmGiOrderDeletePopServiceImpl implements MasterWmGiOrderDeletePopService {
	
	@Autowired
	private MasterWmGiOrderDeletePopDao masterWmGiOrderDeletePopDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object>  param){
		return masterWmGiOrderDeletePopDao.selectList(param);
	}	

	
	//  조회
	public List<Map<String,String>> getPop(Map<String, String> pMap){
		return masterWmGiOrderDeletePopDao.selectListPop(pMap);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGiOrderDeletePopDao.updateSelectedData(formData, gridData);
	}	
}
