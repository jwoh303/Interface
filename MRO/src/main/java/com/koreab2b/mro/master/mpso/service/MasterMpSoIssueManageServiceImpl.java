package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoIssueManageDao;

@Service("masterMpSoIssueManageService")
public class MasterMpSoIssueManageServiceImpl implements MasterMpSoIssueManageService {
	
	@Autowired
	private MasterMpSoIssueManageDao masterMpSoIssueManageDao;
  
	
	// 리스트조회
	public List<Map<String,String>> searchMasterIssueManageList(Map<String,Object>  param) {
		return masterMpSoIssueManageDao.searchMasterMpSoIssueManageList(param);
	}	
}
