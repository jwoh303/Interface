package com.koreab2b.mro.master.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDao;

@Service("masterWmGrStockGrCreService")
public class MasterWmGrStockGrCreServiceImpl implements MasterWmGrStockGrCreService {
	
	@Autowired
	private MasterWmGrStockGrCreDao masterWmGrStockGrCreDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmGrStockGrCreDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockGrCreDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrStockGrCreDao.deleteSelectedData(formData, gridData);
	}
}
