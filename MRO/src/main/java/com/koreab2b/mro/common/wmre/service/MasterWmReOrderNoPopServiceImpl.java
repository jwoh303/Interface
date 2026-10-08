package com.koreab2b.mro.common.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmre.dao.MasterWmReOrderNoPopDao;

@Service("masterWmReOrderNoPopService")
public class MasterWmReOrderNoPopServiceImpl implements MasterWmReOrderNoPopService {
	
	@Autowired
	private MasterWmReOrderNoPopDao masterWmReOrderNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmReOrderNoPopDao.selectList(formData);
	}	
	

}
