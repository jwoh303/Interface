package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.SellerMpClGoodsDetailInfoPopDao;

@Service("sellerMpClGoodsDetailInfoPopService")
public class SellerMpClGoodsDetailInfoPopServiceImpl implements SellerMpClGoodsDetailInfoPopService {
	
	@Autowired
	private SellerMpClGoodsDetailInfoPopDao sellerMpClGoodsDetailInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClGoodsDetailInfoPopDao.selectList(formData);
	}	
	

}
