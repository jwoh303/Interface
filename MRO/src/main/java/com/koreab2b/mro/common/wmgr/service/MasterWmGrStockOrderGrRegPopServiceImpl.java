package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrStockOrderGrRegPopDao;

@Service("masterWmGrStockOrderGrRegPopService")
public class MasterWmGrStockOrderGrRegPopServiceImpl implements MasterWmGrStockOrderGrRegPopService {
	
	@Autowired
	private MasterWmGrStockOrderGrRegPopDao masterWmGrStockOrderGrRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrStockOrderGrRegPopDao.selectList(formData);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockOrderGrRegPopDao.updateSelectedData(formData, gridData);
	}	

}
