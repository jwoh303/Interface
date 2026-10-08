package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpst.dao.SellerMpStDeliveryRecordDao;

@Service("sellerMpStDeliveryRecordService")
public class SellerMpStDeliveryRecordServiceImpl implements SellerMpStDeliveryRecordService {
	
	@Autowired
	private SellerMpStDeliveryRecordDao sellerMpStDeliveryRecordDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpStDeliveryRecordDao.selectList(formData);
	}

}
