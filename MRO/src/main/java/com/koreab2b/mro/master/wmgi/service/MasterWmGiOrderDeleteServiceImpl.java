package com.koreab2b.mro.master.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.wmgi.dao.MasterWmGiOrderDeleteDao;

@Service("masterWmGiOrderDeleteService")
public class MasterWmGiOrderDeleteServiceImpl implements MasterWmGiOrderDeleteService {
	
	@Autowired
	private MasterWmGiOrderDeleteDao masterWmGiOrderDeleteDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmGiOrderDeleteDao.selectList(param);
	}	

}
