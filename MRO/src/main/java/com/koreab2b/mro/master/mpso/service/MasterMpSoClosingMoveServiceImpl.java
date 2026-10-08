package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoClosingMoveDao;

@Service("masterMpSoClosingMoveService")
public class MasterMpSoClosingMoveServiceImpl implements MasterMpSoClosingMoveService {
	
	@Autowired
	private MasterMpSoClosingMoveDao masterMpSoClosingMoveDao;
  
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoClosingMoveList(Map<String,Object>  param) {
		return masterMpSoClosingMoveDao.searchMasterMpSoClosingMoveList(param);
	}	
}
