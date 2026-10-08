package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderDeleteReasonInsPopDao;

@Service("masterMpSoOrderDeleteReasonInsPopService")
public class MasterMpSoOrderDeleteReasonInsPopServiceImpl implements MasterMpSoOrderDeleteReasonInsPopService {
	
	@Autowired
	private MasterMpSoOrderDeleteReasonInsPopDao masterMpSoOrderDeleteReasonInsPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderDeleteReasonInsPopDao.selectList(formData);
	}	
	

}
