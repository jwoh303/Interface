package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.koreab2b.mro.common.wmgr.dao.MasterWmGrTrOrderManagerPopDao;

@Service("masterWmGrTrOrderManagerPopService")
public class MasterWmGrTrOrderManagerPopServiceImpl implements MasterWmGrTrOrderManagerPopService {
	
	@Autowired
	private MasterWmGrTrOrderManagerPopDao masterWmGrTrOrderManagerPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrTrOrderManagerPopDao.selectList(formData);
	}	
	// 조회
	public List<Map<String,String>> getPop(Map<String,String> formData) {
		return masterWmGrTrOrderManagerPopDao.selectPop(formData);
	}	
}
