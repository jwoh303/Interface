package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoUniformStockDao;

@Service("buyerMpSoUniformStockService")
public class BuyerMpSoUniformStockServiceImpl implements BuyerMpSoUniformStockService {
	
	@Autowired
	private BuyerMpSoUniformStockDao buyerMpSoUniformStockDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMpSoUniformStockDao.selectList(param);
	}	
}
