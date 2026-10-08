package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmWmsHomeDao;

@Service("masterMdAmWmsHomeService")
public class MasterMdAmWmsHomeServiceImpl implements MasterMdAmWmsHomeService {
	
	@Autowired
	private MasterMdAmWmsHomeDao masterMdAmWmsHomeDao;

	// 물류센터 공지사항 리스트조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmWmsHomeDao.selectList(param);
	}

}
