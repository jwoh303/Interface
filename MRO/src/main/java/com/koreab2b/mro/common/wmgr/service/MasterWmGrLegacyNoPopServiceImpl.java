package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrLegacyNoPopDao;

@Service("masterWmGrLegacyNoPopService")
public class MasterWmGrLegacyNoPopServiceImpl implements MasterWmGrLegacyNoPopService {
	
	@Autowired
	private MasterWmGrLegacyNoPopDao masterWmGrLegacyNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrLegacyNoPopDao.selectList(formData);
	}	
	
	public List<Map<String,String>> getDetail(Map<String,String>  formData){
		return masterWmGrLegacyNoPopDao.getDetail(formData);
	}
}
