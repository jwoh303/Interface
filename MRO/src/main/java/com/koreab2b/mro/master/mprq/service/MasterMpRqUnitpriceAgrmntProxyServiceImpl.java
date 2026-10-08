package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqUnitpriceAgrmntProxyDao;

@Service("masterMpRqUnitpriceAgrmntProxyService")
public class MasterMpRqUnitpriceAgrmntProxyServiceImpl implements MasterMpRqUnitpriceAgrmntProxyService {
	
	@Autowired
	private MasterMpRqUnitpriceAgrmntProxyDao masterMpRqUnitpriceAgrmntProxyDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqUnitpriceAgrmntProxyDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqUnitpriceAgrmntProxyDao.updateSelectedData(formData, gridData);
	}	
}
