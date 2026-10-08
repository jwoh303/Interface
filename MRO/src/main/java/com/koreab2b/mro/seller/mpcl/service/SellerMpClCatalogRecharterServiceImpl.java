package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClCatalogRecharterDao;

@Service("sellerMpClCatalogRecharterService")
public class SellerMpClCatalogRecharterServiceImpl implements SellerMpClCatalogRecharterService {
	
	@Autowired
	private SellerMpClCatalogRecharterDao sellerMpClCatalogRecharterDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMpClCatalogRecharterDao.selectList(param);
	}
	
	// 재계약 제출
	@Transactional
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpClCatalogRecharterDao.saveSelectedData(formData, gridData);
	}
	
	//재계약 이력팝업
	public List<Map<String,String>> getSellerMpClCatalogRecharterHistoryPop(Map<String,Object> param) {
		return sellerMpClCatalogRecharterDao.getSellerMpClCatalogRecharterHistoryPop(param);
	}
	
	// 재계약 포기
	@Transactional
	public String rejectSellerMpClCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpClCatalogRecharterDao.rejectSellerMpClCatalogRecharter(formData, gridData);
	}
}
