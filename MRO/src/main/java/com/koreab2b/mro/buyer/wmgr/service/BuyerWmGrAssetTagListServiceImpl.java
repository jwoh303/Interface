package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrAssetTagListDao;

@Service("buyerWmGrAssetTagListService")
public class BuyerWmGrAssetTagListServiceImpl implements BuyerWmGrAssetTagListService {
	
	@Autowired
	private BuyerWmGrAssetTagListDao buyerWmGrAssetTagListDao;

	//조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerWmGrAssetTagListDao.selectList(param);
	}	

	// 코드 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerWmGrAssetTagListDao.updateSelectedData(formData, gridData);
	}	


}
