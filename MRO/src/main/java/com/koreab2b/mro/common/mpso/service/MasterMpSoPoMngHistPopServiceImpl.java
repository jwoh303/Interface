package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoPoMngHistPopDao;

@Service("masterMpSoPoMngHistPopService")
public class MasterMpSoPoMngHistPopServiceImpl implements MasterMpSoPoMngHistPopService {
	
	@Autowired
	private MasterMpSoPoMngHistPopDao masterMpSoPoMngHistPopDao;
  
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoPoMngHistList(Map<String,Object>  param) {
		return masterMpSoPoMngHistPopDao.searchMasterMpSoPoMngHistList(param);
	}	
}
