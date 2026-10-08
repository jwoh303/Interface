package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClCatalogRecharterMngDao;

@Service("sellerMpClCatalogRecharterMngService")
public class SellerMpClCatalogRecharterMngServiceImpl implements SellerMpClCatalogRecharterMngService {
	
	@Autowired
	private SellerMpClCatalogRecharterMngDao sellerMpClCatalogRecharterMngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMpClCatalogRecharterMngDao.selectList(param);
	}
	

}
