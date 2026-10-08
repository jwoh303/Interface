package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiReleasePrPopDao;

@Service("masterWmGiReleasePrPopService")
public class MasterWmGiReleasePrPopServiceImpl implements MasterWmGiReleasePrPopService {
	
	@Autowired
	private MasterWmGiReleasePrPopDao masterWmGiReleasePrPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGiReleasePrPopDao.selectList(formData);
	}	
	
	//출고지시 
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData){
		return masterWmGiReleasePrPopDao.updateSelectedData(formData,gridData);
	}
}
