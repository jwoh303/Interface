package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmLogManageDao;

@Service("masterMdAmLogManageService")
public class MasterMdAmLogManageServiceImpl implements MasterMdAmLogManageService {
	
	@Autowired
	private MasterMdAmLogManageDao masterMdAmLogManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmLogManageDao.selectList(param);
	}	

	// 감사로그 기록
	public void saveLog(Map<String,Object> param) {
		masterMdAmLogManageDao.saveLog(param);
	}
}
