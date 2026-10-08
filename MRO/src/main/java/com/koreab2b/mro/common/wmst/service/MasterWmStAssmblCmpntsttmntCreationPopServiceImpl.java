package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStAssmblCmpntsttmntCreationPopDao;

@Service("masterWmStAssmblCmpntsttmntCreationPopService")
public class MasterWmStAssmblCmpntsttmntCreationPopServiceImpl implements MasterWmStAssmblCmpntsttmntCreationPopService {
	
	@Autowired
	private MasterWmStAssmblCmpntsttmntCreationPopDao masterWmStAssmblCmpntsttmntCreationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStAssmblCmpntsttmntCreationPopDao.selectList(formData);
	}	
	
	// 하단 조회
	public List<Map<String,String>> getBotList(Map<String,Object> formData) {
		return masterWmStAssmblCmpntsttmntCreationPopDao.selectBotList(formData);
	}	
	
	//조립 부품생성 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData){
		return masterWmStAssmblCmpntsttmntCreationPopDao.updateSelectedData(formData, gridData);
	}
}
