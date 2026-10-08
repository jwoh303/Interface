package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoReturnLisPopDao;

@Service("masterWmCoReturnLisPopService")
public class MasterWmCoReturnLisPopServiceImpl implements MasterWmCoReturnLisPopService {
	
	@Autowired
	private MasterWmCoReturnLisPopDao masterWmCoReturnLisPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoReturnLisPopDao.selectList(formData);
	}	
	

}
