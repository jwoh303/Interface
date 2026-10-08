package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStDailyBlncingaccntListPopDao;

@Service("masterWmStDailyBlncingaccntListPopService")
public class MasterWmStDailyBlncingaccntListPopServiceImpl implements MasterWmStDailyBlncingaccntListPopService {
	
	@Autowired
	private MasterWmStDailyBlncingaccntListPopDao masterWmStDailyBlncingaccntListPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStDailyBlncingaccntListPopDao.selectList(formData);
	}	
	

}
