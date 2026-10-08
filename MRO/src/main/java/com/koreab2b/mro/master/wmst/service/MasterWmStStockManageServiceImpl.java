package com.koreab2b.mro.master.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmst.dao.MasterWmStStockManageDao;

@Service("masterWmStStockManageService")
public class MasterWmStStockManageServiceImpl implements MasterWmStStockManageService {
	
	@Autowired
	private MasterWmStStockManageDao masterWmStStockManageDao;

	// 코드 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmStStockManageDao.selectList(param);
	}	

	// 코드 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmStStockManageDao.updateSelectedData(formData, gridData);
	}	

	// 코드 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmStStockManageDao.deleteSelectedData(formData, gridData);
	}
}
