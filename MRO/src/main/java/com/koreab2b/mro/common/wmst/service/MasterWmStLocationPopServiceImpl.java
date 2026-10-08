package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStLocationPopDao;

@Service("masterWmStLocationPopService")
public class MasterWmStLocationPopServiceImpl implements MasterWmStLocationPopService {
	
	@Autowired
	private MasterWmStLocationPopDao masterWmStLocationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStLocationPopDao.selectList(formData);
	}	
	

}
