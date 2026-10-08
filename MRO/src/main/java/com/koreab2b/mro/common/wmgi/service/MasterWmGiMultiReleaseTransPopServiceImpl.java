package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiMultiReleaseTransPopDao;

@Service("masterWmGiMultiReleaseTransPopService")
public class MasterWmGiMultiReleaseTransPopServiceImpl implements MasterWmGiMultiReleaseTransPopService {
	
	@Autowired
	private MasterWmGiMultiReleaseTransPopDao masterWmGiMultiReleaseTransPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData){
		return masterWmGiMultiReleaseTransPopDao.selectList(formData);
	}
	
	// TR다중출고지시 
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData){
		return masterWmGiMultiReleaseTransPopDao.updateSelectedData(formData, gridData);
	}
}