package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStWarehouseStockDao;

@Service("buyerMpStWarehouseStockService")
public class BuyerMpStWarehouseStockServiceImpl implements BuyerMpStWarehouseStockService {
	
	@Autowired
	private BuyerMpStWarehouseStockDao buyerMpStWarehouseStockDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return buyerMpStWarehouseStockDao.selectList(formData);
	}	
}
