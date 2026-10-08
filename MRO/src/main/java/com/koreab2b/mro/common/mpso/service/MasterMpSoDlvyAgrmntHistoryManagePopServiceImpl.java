package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoDlvyAgrmntHistoryManagePopDao;

@Service("masterMpSoDlvyAgrmntHistoryManagePopService")
public class MasterMpSoDlvyAgrmntHistoryManagePopServiceImpl implements MasterMpSoDlvyAgrmntHistoryManagePopService {
	
	@Autowired
	private MasterMpSoDlvyAgrmntHistoryManagePopDao masterMpSoDlvyAgrmntHistoryManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoDlvyAgrmntHistoryManagePopDao.selectList(formData);
	}	
	

}
