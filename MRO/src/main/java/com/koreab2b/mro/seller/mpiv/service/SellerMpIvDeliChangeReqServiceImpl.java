package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliChangeReqDao;

@Service("sellerMpIvDeliChangeReqService")
public class SellerMpIvDeliChangeReqServiceImpl implements SellerMpIvDeliChangeReqService {
	
	@Autowired
	private SellerMpIvDeliChangeReqDao sellerMpIvDeliChangeReqDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvDeliChangeReqDao.selectList(formData);
	}
	public List<Map<String,String>> getSellerMpIvDeliChangeReqList_v2(Map<String,Object> formData) {
		return sellerMpIvDeliChangeReqDao.getSellerMpIvDeliChangeReqList_v2(formData);
	}
	
	// 취소요청
	public String updateSellerMpIvDeliChangeReqCancel(Map<String,String> pMap) {
		return sellerMpIvDeliChangeReqDao.updateSellerMpIvDeliChangeReqCancel(pMap);
	}
	
	// 요청사항 상세 팝업
	public List<Map<String,String>> getSellerMpIvDeliChangeReqDetailPop(Map<String,String>  pMap){
		return sellerMpIvDeliChangeReqDao.getSellerMpIvDeliChangeReqDetailPop(pMap);
	}
}
