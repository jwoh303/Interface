package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStAssmblNoPopDao;

@Service("masterWmStAssmblNoPopService")
public class MasterWmStAssmblNoPopServiceImpl implements MasterWmStAssmblNoPopService {
	
	@Autowired
	private MasterWmStAssmblNoPopDao masterWmStAssmblNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStAssmblNoPopDao.selectList(formData);
	}	
	
	// 상단조회
	public List<Map<String,String>> getPop(Map<String,Object> formData) {
		return masterWmStAssmblNoPopDao.selectPopList(formData);
	}		

	
	// 조립취소
	public String updateSelectedData(Map<String,String> formData,List<Object> gridData) {
		return masterWmStAssmblNoPopDao.updateSelectedData(formData,gridData);
	}	
	
	
	// 조립완료 
	public String updateSelectedDataCom(Map<String,String> formData,List<Object> gridData) {
		return masterWmStAssmblNoPopDao.updateSelectedDataCom(formData,gridData);
	}
}
