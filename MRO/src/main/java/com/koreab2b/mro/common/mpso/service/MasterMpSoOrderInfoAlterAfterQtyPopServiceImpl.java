package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderInfoAlterAfterQtyPopDao;

@Service("masterMpSoOrderInfoAlterAfterQtyPopService")
public class MasterMpSoOrderInfoAlterAfterQtyPopServiceImpl implements MasterMpSoOrderInfoAlterAfterQtyPopService {
	
	@Autowired
	private MasterMpSoOrderInfoAlterAfterQtyPopDao masterMpSoOrderInfoAlterAfterQtyPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderInfoAlterAfterQtyPopDao.selectList(formData);
	}	
	
	
	public List<Map<String,String>> getSysopOrderChangePoAfterHDPop(Map<String,String>  formData) {
		return masterMpSoOrderInfoAlterAfterQtyPopDao.getSysopOrderChangePoAfterHDPop(formData);
	}	
	public List<Map<String,String>> getSysopOrderChangePoAfterDTPop(Map<String, Object>  formData) {
		return masterMpSoOrderInfoAlterAfterQtyPopDao.getSysopOrderChangePoAfterDTPop(formData);
	}	
	
	
	public String setSysopOrderChangeAfterQtyChange(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterAfterQtyPopDao.setSysopOrderChangeAfterQtyChange(formData,gridData);
	}	

}
