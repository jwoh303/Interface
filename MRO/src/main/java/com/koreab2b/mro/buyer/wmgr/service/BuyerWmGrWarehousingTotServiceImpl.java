package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrWarehousingTotDao;

@Service("buyerWmGrWarehousingTotService")
public class BuyerWmGrWarehousingTotServiceImpl implements BuyerWmGrWarehousingTotService {
	
	@Autowired
	private BuyerWmGrWarehousingTotDao buyerWmGrWarehousingTotDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerWmGrWarehousingTotDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingTotList_v2(Map<String,Object> formData) {
		return buyerWmGrWarehousingTotDao.getBuyerWmGrWarehousingTotList_v2(formData);
	}
	
	// 팝업조회
	public List<Map<String,String>> getPopList(Map<String,String> formData) {
		return buyerWmGrWarehousingTotDao.selectPopList(formData);
	}
	public List<Map<String,String>> getPopList_v2(Map<String,Object> formData) {
		return buyerWmGrWarehousingTotDao.selectPopList_v2(formData);
	}
}
