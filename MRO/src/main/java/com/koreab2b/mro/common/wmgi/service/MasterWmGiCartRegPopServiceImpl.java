package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiCartRegPopDao;

@Service("masterWmGiCartRegPopService")
public class MasterWmGiCartRegPopServiceImpl implements MasterWmGiCartRegPopService {
	
	@Autowired
	private MasterWmGiCartRegPopDao masterWmGiCartRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGiCartRegPopDao.selectList(formData);
	}	
	
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData){
		return masterWmGiCartRegPopDao.updateSelectedData(formData,gridData);
	}

}
