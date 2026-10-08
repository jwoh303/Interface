package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsOrderCreationPopDao;

@Service("masterMpDsOrderCreationPopService")
public class MasterMpDsOrderCreationPopServiceImpl implements MasterMpDsOrderCreationPopService {
	
	@Autowired
	private MasterMpDsOrderCreationPopDao masterMpDsOrderCreationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsOrderCreationPopDao.selectList(formData);
	}	
	public List<Map<String,String>> moveList(Map<String,Object> formData) {
		return masterMpDsOrderCreationPopDao.moveList(formData);
	}	

	// 등록
	public String insertSelectedData(Map<String,String> formData, List<Object> gridData) {
		return masterMpDsOrderCreationPopDao.insertSelectedData(formData, gridData);
	}		

}
