package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmStDailyReleaseListPopDao;

@Service("masterWmStDailyReleaseListPopService")
public class MasterWmStDailyReleaseListPopServiceImpl implements MasterWmStDailyReleaseListPopService {
	
	@Autowired
	private MasterWmStDailyReleaseListPopDao masterWmStDailyReleaseListPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmStDailyReleaseListPopDao.selectList(formData);
	}	
	// exel 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> formData) {
		return masterWmStDailyReleaseListPopDao.getExcelList(formData);
	}	

}
