package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiMultiHubReleaseTransPopDao;

@Service("masterWmGiMultiHubReleaseTransPopService")
public class MasterWmGiMultiHubReleaseTransPopServiceImpl implements MasterWmGiMultiHubReleaseTransPopService {
	
	@Autowired
	private MasterWmGiMultiHubReleaseTransPopDao masterWmGiMultiHubReleaseTransPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData){
		return masterWmGiMultiHubReleaseTransPopDao.selectList(formData);
	}
	
	// 간선다중출고지시 
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData){
		return masterWmGiMultiHubReleaseTransPopDao.updateSelectedData(formData, gridData);
	}
}