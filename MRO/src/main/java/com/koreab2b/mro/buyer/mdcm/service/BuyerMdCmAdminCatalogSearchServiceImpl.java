package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmAdminCatalogSearchDao;

@Service("buyerMdCmAdminCatalogSearchService")
public class BuyerMdCmAdminCatalogSearchServiceImpl implements BuyerMdCmAdminCatalogSearchService {
	
	@Autowired
	private BuyerMdCmAdminCatalogSearchDao buyerMdCmAdminCatalogSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmAdminCatalogSearchDao.getList(formData);
	}	

}
