package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoBuyerPopDao;

@Service("masterWmCoBuyerPopService")
public class MasterWmCoBuyerPopServiceImpl implements MasterWmCoBuyerPopService {
	
	@Autowired
	private MasterWmCoBuyerPopDao masterWmCoBuyerPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoBuyerPopDao.selectList(formData);
	}	
	

}
