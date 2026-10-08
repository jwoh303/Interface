package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStSgResultDao;

@Service("masterMpStSgResultService")
public class MasterMpStSgResultServiceImpl implements MasterMpStSgResultService {
	
	@Autowired
	private MasterMpStSgResultDao masterMpStSgResultDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStSgResultDao.selectList(param);
	}	
	
	// 팝업 조회
	public List<Map<String,String>> getPopList(Map<String,Object> param) {
		return masterMpStSgResultDao.selectPopList(param);
	}	
}
