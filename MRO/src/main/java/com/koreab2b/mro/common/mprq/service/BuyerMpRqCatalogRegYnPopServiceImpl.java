package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.BuyerMpRqCatalogRegYnPopDao;

@Service("buyerMpRqCatalogRegYnPopService")
public class BuyerMpRqCatalogRegYnPopServiceImpl implements BuyerMpRqCatalogRegYnPopService {
	
	@Autowired
	private BuyerMpRqCatalogRegYnPopDao buyerMpRqCatalogRegYnPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqCatalogRegYnPopDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return buyerMpRqCatalogRegYnPopDao.selectList_v2(formData);
	}
	

}
