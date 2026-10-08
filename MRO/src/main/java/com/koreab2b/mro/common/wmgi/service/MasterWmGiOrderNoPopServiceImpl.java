package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiOrderNoPopDao;

@Service("masterWmGiOrderNoPopService")
public class MasterWmGiOrderNoPopServiceImpl implements MasterWmGiOrderNoPopService {
	
	@Autowired
	private MasterWmGiOrderNoPopDao masterWmGiOrderNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGiOrderNoPopDao.selectList(formData);
	}	
	//출고지시 
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData){
		return masterWmGiOrderNoPopDao.updateSelectedData(formData,gridData);
	}

}
