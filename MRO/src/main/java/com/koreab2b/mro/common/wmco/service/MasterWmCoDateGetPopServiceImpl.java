package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoDateGetPopDao;

@Service("masterWmCoDateGetPopService")
public class MasterWmCoDateGetPopServiceImpl implements MasterWmCoDateGetPopService {
	
	@Autowired
	private MasterWmCoDateGetPopDao masterWmCoDateGetPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoDateGetPopDao.selectList(formData);
	}	
	

}
