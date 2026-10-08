package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliveryProgressStateDao;

@Service("sellerMpIvDeliveryProgressStateService")
public class SellerMpIvDeliveryProgressStateServiceImpl implements SellerMpIvDeliveryProgressStateService {
	
	@Autowired
	private SellerMpIvDeliveryProgressStateDao sellerMpIvDeliveryProgressStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvDeliveryProgressStateDao.selectList(formData);
	}	
	
	// 납품예정일 변경요청
	public String updateSellerMpIvDsDateChangeReq(Map<String,String> pMap) {
		return sellerMpIvDeliveryProgressStateDao.updateSellerMpIvDsDateChangeReq(pMap);
	}
	
	// 수주접수 초기화요청
	public String updateSellerMpIvIvInfoChangeReq(Map<String,String> pMap) {
		return sellerMpIvDeliveryProgressStateDao.updateSellerMpIvIvInfoChangeReq(pMap);
	}
	
	// 리뉴얼 > 조회
	public List<Map<String,String>> getSellerMpIvDeliveryProgressStateList_v2(Map<String,Object> formData) {
		return sellerMpIvDeliveryProgressStateDao.getSellerMpIvDeliveryProgressStateList_v2(formData);
	}
}
