package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsOrderInfoConfirmPopDao;

@Service("masterMpDsOrderInfoConfirmPopService")
public class MasterMpDsOrderInfoConfirmPopServiceImpl implements MasterMpDsOrderInfoConfirmPopService {
	
	@Autowired
	private MasterMpDsOrderInfoConfirmPopDao masterMpDsOrderInfoConfirmPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpDsOrderInfoConfirmPopDao.selectList(formData);
	}	
	//주문취소
	@Transactional
	public String cancelOrderInfo(Map<String, String> formData){
		return masterMpDsOrderInfoConfirmPopDao.delOrderInfo( formData);
	}	
	//주문수정
	@Transactional
	public String modifyOrderInfo(Map<String, String> formData){
		return masterMpDsOrderInfoConfirmPopDao.updateOrderInfo( formData);
	}	
	//발주생성
	@Transactional
	public String regOrderInfo(Map<String, String> formData){
		return masterMpDsOrderInfoConfirmPopDao.insertOrderInfo( formData);
	}
}
