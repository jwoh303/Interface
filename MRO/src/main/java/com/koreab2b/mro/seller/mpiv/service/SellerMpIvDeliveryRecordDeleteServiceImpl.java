package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliveryRecordDeleteDao;

@Service("sellerMpIvDeliveryRecordDeleteService")
public class SellerMpIvDeliveryRecordDeleteServiceImpl implements SellerMpIvDeliveryRecordDeleteService {
	
	@Autowired
	private SellerMpIvDeliveryRecordDeleteDao sellerMpIvDeliveryRecordDeleteDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordDeleteDao.selectList(pMap);
	}

	// 삭제
	public String saveSellerMpIvDeliveryRecordDelete(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordDeleteDao.saveSellerMpIvDeliveryRecordDelete(pMap);
	}	
}
