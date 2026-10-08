package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderInfoHistoryViewPopDao;

@Service("masterMpSoOrderInfoHistoryViewPopService")
public class MasterMpSoOrderInfoHistoryViewPopServiceImpl implements MasterMpSoOrderInfoHistoryViewPopService {
	
	@Autowired
	private MasterMpSoOrderInfoHistoryViewPopDao masterMpSoOrderInfoHistoryViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderInfoHistoryViewPopDao.selectList(formData);
	}	
	

}
