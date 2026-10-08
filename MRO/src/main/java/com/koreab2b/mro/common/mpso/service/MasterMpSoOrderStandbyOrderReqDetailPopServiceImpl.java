package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderStandbyOrderReqDetailPopDao;

@Service("masterMpSoOrderStandbyOrderReqDetailPopService")
public class MasterMpSoOrderStandbyOrderReqDetailPopServiceImpl implements MasterMpSoOrderStandbyOrderReqDetailPopService {
	
	@Autowired
	private MasterMpSoOrderStandbyOrderReqDetailPopDao masterMpSoOrderStandbyOrderReqDetailPopDao;

	// 조회(헤더)
	public List<Map<String,String>> getHeader(Map<String,String> formData) {
		return masterMpSoOrderStandbyOrderReqDetailPopDao.selectHeader(formData);
	}	
	// 조회(상세)
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderStandbyOrderReqDetailPopDao.selectList(formData);
	}	

	//저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderStandbyOrderReqDetailPopDao.updateSelectedData(formData, gridData);
	}
	

}
