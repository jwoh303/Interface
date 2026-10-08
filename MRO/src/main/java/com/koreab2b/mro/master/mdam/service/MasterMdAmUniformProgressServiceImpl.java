package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmUniformProgressDao;

@Service("masterMdAmUniformProgressService")
public class MasterMdAmUniformProgressServiceImpl implements MasterMdAmUniformProgressService {
	
	@Autowired
	private MasterMdAmUniformProgressDao masterMdAmUniformProgressDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmUniformProgressDao.selectList(param);
	}
}
