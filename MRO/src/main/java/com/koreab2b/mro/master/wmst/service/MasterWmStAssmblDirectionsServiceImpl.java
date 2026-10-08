package com.koreab2b.mro.master.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmst.dao.MasterWmStAssmblDirectionsDao;

@Service("masterWmStAssmblDirectionsService")
public class MasterWmStAssmblDirectionsServiceImpl implements MasterWmStAssmblDirectionsService {
	
	@Autowired
	private MasterWmStAssmblDirectionsDao masterWmStAssmblDirectionsDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmStAssmblDirectionsDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmStAssmblDirectionsDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmStAssmblDirectionsDao.deleteSelectedData(formData, gridData);
	}
}
