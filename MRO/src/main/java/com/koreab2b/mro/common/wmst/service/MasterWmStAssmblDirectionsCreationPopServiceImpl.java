package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStAssmblDirectionsCreationPopDao;

@Service("masterWmStAssmblDirectionsCreationPopService")
public class MasterWmStAssmblDirectionsCreationPopServiceImpl implements MasterWmStAssmblDirectionsCreationPopService {
	
	@Autowired
	private MasterWmStAssmblDirectionsCreationPopDao masterWmStAssmblDirectionsCreationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStAssmblDirectionsCreationPopDao.selectList(formData);
	}	

	// 조회
	public List<Map<String,String>> getList2(Map<String,Object> formData) {
		return masterWmStAssmblDirectionsCreationPopDao.selectList2(formData);
	}	

	
	public List<Map<String,String>> getChangeList(Map<String,Object> formData) {
		return masterWmStAssmblDirectionsCreationPopDao.getChangeList(formData);
	}	
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData){
		return masterWmStAssmblDirectionsCreationPopDao.updateSelectedData(formData,gridData);
	}
}
