package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrStockWarehousingManagerPopDao;

@Service("masterWmGrStockWarehousingManagerPopService")
public class MasterWmGrStockWarehousingManagerPopServiceImpl implements MasterWmGrStockWarehousingManagerPopService {
	
	@Autowired
	private MasterWmGrStockWarehousingManagerPopDao masterWmGrStockWarehousingManagerPopDao;

	// 상단 조회
	public List<Map<String,String>> getPop(Map<String,String> formData) {
		return masterWmGrStockWarehousingManagerPopDao.selectPop(formData);
	}	
	
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrStockWarehousingManagerPopDao.selectList(formData);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockWarehousingManagerPopDao.delSelectedData(formData, gridData);
	}	

}
