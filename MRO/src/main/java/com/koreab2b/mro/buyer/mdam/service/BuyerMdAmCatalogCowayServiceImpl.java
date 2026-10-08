package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmCatalogCowayDao;

@Service("buyerMdAmCatalogCowayService")
public class BuyerMdAmCatalogCowayServiceImpl implements BuyerMdAmCatalogCowayService {
	
	@Autowired
	private BuyerMdAmCatalogCowayDao buyerMdAmCatalogCowayDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmCatalogCowayDao.selectList(formData);
	}	

}
