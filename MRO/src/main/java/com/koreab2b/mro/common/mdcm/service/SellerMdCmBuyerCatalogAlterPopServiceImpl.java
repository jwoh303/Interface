package com.koreab2b.mro.common.mdcm.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.SellerMdCmBuyerCatalogAlterPopDao;

@Service("sellerMdCmBuyerCatalogAlterPopService")
public class SellerMdCmBuyerCatalogAlterPopServiceImpl implements SellerMdCmBuyerCatalogAlterPopService {
	
	@Autowired
	private SellerMdCmBuyerCatalogAlterPopDao sellerMdCmBuyerCatalogAlterPopDao;

	// 조회
	public Map<String,String> getData(Map<String,String>  formData) {
		return sellerMdCmBuyerCatalogAlterPopDao.selectData(formData);
	}	
	
}
