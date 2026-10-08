package com.koreab2b.mro.master.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdsr.dao.MasterMdSrSrDetailMainDao;

@Service("masterMdSrSrDetailMainService")
public class MasterMdSrSrDetailMainServiceImpl implements MasterMdSrSrDetailMainService {
	
	@Autowired
	private MasterMdSrSrDetailMainDao masterMdSrSrDetailMainDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,String>  param) {
		return masterMdSrSrDetailMainDao.selectList(param);
	}	
}

