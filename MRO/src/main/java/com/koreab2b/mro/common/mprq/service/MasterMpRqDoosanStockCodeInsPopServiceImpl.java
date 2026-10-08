package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqDoosanStockCodeInsPopDao;

@Service("masterMpRqDoosanStockCodeInsPopService")
public class MasterMpRqDoosanStockCodeInsPopServiceImpl implements MasterMpRqDoosanStockCodeInsPopService {
	
	@Autowired
	private MasterMpRqDoosanStockCodeInsPopDao masterMpRqDoosanStockCodeInsPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqDoosanStockCodeInsPopDao.selectList(formData);
	}	
	
	@Transactional
	public String saveDoosanStockCode(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqDoosanStockCodeInsPopDao.saveDoosanStockCode(formData, gridData);
	}	
}
