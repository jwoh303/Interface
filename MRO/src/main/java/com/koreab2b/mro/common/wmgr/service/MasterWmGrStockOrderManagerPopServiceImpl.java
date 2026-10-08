package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrStockOrderManagerPopDao;

@Service("masterWmGrStockOrderManagerPopService")
public class MasterWmGrStockOrderManagerPopServiceImpl implements MasterWmGrStockOrderManagerPopService {
	
	@Autowired
	private MasterWmGrStockOrderManagerPopDao masterWmGrStockOrderManagerPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrStockOrderManagerPopDao.selectList(formData);
	}	
	
	// 발주 pop 조회
	public List<Map<String,String>> getPop(Map<String,String> formData) {
		return masterWmGrStockOrderManagerPopDao.selectPop(formData);
	}	
	
	// 발주삭제
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPoDel(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockOrderManagerPopDao.deleteMasterWmGrStockOrderManagerPopPoDel(formData, gridData);
	}	

	
	//단가변경
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPriceChange(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockOrderManagerPopDao.deleteMasterWmGrStockOrderManagerPopPriceChange(formData, gridData);
	}	
	
	//공급사변경
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopAgentChange(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockOrderManagerPopDao.deleteMasterWmGrStockOrderManagerPopAgentChange(formData, gridData);
	}	
}
