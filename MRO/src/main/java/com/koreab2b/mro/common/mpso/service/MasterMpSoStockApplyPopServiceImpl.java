package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoStockApplyPopDao;

@Service("masterMpSoStockApplyPopService")
public class MasterMpSoStockApplyPopServiceImpl implements MasterMpSoStockApplyPopService {
	
	@Autowired
	private MasterMpSoStockApplyPopDao masterMpSoStockApplyPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoStockApplyPopDao.selectList(formData);
	}	
	
	// 조회(상세)
	public List<Map<String,String>> getListDetail(Map<String,Object> formData) {
		return masterMpSoStockApplyPopDao.selectListDetail(formData);
	}
	
	//저장
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoStockApplyPopDao.saveSelectedData(formData, gridData);
	}	
}
