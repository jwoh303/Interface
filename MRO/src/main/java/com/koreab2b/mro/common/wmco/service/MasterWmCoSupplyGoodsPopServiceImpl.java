package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoSupplyGoodsPopDao;

@Service("masterWmCoSupplyGoodsPopService")
public class MasterWmCoSupplyGoodsPopServiceImpl implements MasterWmCoSupplyGoodsPopService {
	
	@Autowired
	private MasterWmCoSupplyGoodsPopDao masterWmCoSupplyGoodsPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoSupplyGoodsPopDao.selectList(formData);
	}	
	

}
