package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.SellerMpClGoodsDetailInfoCowayPopDao;

@Service("sellerMpClGoodsDetailInfoCowayPopService")
public class SellerMpClGoodsDetailInfoCowayPopServiceImpl implements SellerMpClGoodsDetailInfoCowayPopService {
	
	@Autowired
	private SellerMpClGoodsDetailInfoCowayPopDao sellerMpClGoodsDetailInfoCowayPopDao;

	// 조회
	public List<Map<String,String>> getHdList(Map<String,String> formData) {
		return sellerMpClGoodsDetailInfoCowayPopDao.selectHdList(formData);
	}
	// 조회
	public List<Map<String,String>> getDtList(Map<String,String> formData) {
		return sellerMpClGoodsDetailInfoCowayPopDao.selectDtList(formData);
	}
}
