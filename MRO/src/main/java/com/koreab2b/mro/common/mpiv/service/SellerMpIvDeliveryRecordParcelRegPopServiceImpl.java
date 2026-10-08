package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvDeliveryRecordParcelRegPopDao;

@Service("sellerMpIvDeliveryRecordParcelRegPopService")
public class SellerMpIvDeliveryRecordParcelRegPopServiceImpl implements SellerMpIvDeliveryRecordParcelRegPopService {
	
	@Autowired
	private SellerMpIvDeliveryRecordParcelRegPopDao sellerMpIvDeliveryParcelRegPopDao;
	
	// 송장정보 저장
	public String setParcel(Map<String,String>  formData) {
		return sellerMpIvDeliveryParcelRegPopDao.saveParcel(formData);
	}
	
	// 저장된 정보 조회
	@Override
	public List<Map<String,String>> getNewParcel(Map<String, String> formData) {
		return sellerMpIvDeliveryParcelRegPopDao.selectNew(formData);
	}
}
