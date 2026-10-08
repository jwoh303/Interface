package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmCatalogDao;

@Service("buyerMdAmCatalogService")
public class BuyerMdAmCatalogServiceImpl implements BuyerMdAmCatalogService {
	
	@Autowired
	private BuyerMdAmCatalogDao buyerMdAmCatalogDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmCatalogDao.selectList(formData);
	}	

}
