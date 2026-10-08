package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrWarehousingRegDao;

@Service("buyerWmGrWarehousingRegService")
public class BuyerWmGrWarehousingRegServiceImpl implements BuyerWmGrWarehousingRegService {
	
	@Autowired
	private BuyerWmGrWarehousingRegDao buyerWmGrWarehousingRegDao;

	// init
	public Map<String,String> getBuyerWmGrWarehousingRegInit(Map<String,String> formData){
		return buyerWmGrWarehousingRegDao.getBuyerWmGrWarehousingRegInit(formData);
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerWmGrWarehousingRegDao.selectList(formData);
	}	
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v2(Map<String,Object> formData) {
		return buyerWmGrWarehousingRegDao.getBuyerWmGrWarehousingRegList_v2(formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v3(Map<String,Object> formData) {
		return buyerWmGrWarehousingRegDao.getBuyerWmGrWarehousingRegList_v3(formData);
	}
	
	
	// 조회조건 - userList 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData) {
		return buyerWmGrWarehousingRegDao.selectUserList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return buyerWmGrWarehousingRegDao.updateSelectedData(formData);
	}	

	// 롯데 칠성 입고 결재 상신
	public Map<String,String> getGrAppSendList(Map<String,String> formData) {
		return buyerWmGrWarehousingRegDao.selectGrAppSendList(formData);
	}

	//롯데칠성 입고 결재 상신 초기화
	public String updateResetGrWarehousingReg(Map<String,String>  formData, List<Object> gridData) {
		return buyerWmGrWarehousingRegDao.updateResetGrWarehousingReg(formData, gridData);
	}
}
