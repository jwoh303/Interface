package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Service("buyerMpSoOrderInfoService")
public class BuyerMpSoOrderInfoServiceImpl implements BuyerMpSoOrderInfoService {
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoOrderInfoDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return buyerMpSoOrderInfoDao.selectList_v2(formData);
	}
	 
	public List<Map<String,String>> getOrderInfo_v2(Map<String,String> formData) {
		return buyerMpSoOrderInfoDao.getOrderInfo_v2(formData);
	}
	public List<Map<String,String>> getPasslnInfo_v2(Map<String,String> formData) {
		return buyerMpSoOrderInfoDao.getPasslnInfo_v2(formData);
	}
	
	
	//선입고발주 제외대상 업체 조회
	public String getNotPreGoodsCompany(Map<String,String>  formData) {
		return buyerMpSoOrderInfoDao.getNotPreGoodsCompany(formData);
	}	 
	
	public String buyerNewCreateBenit(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.createBuyerNewCreateBenit(formData);
	}	 
	public String aekyApprPriceSend(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.aekyApprPriceSend(formData);
	}	 	  
	public String buyerNewCreateOrder(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.createBuyerNewCreateOrder(formData);
	}
	public String buyerNewCreateOrder_v2(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.createBuyerNewCreateOrder_v2(formData);
	}	
	public List<Map<String, String>> newBuyerCommonPassbiz(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.selectNewBuyerCommonPassbiz(formData);
	}	 
	public String adminBuyerMasterPrCreateMailReg(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.createAdminBuyerMasterPrCreateMailReg(formData);
	}	 	 
	public List<Map<String, String>> cowayBuyerAdminBdgtTempCheck(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.selectCowayBuyerAdminBdgtTempCheck(formData);
	}	  
	public List<Map<String, String>> buyerAdminBdgtTempCheck(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.selectBuyerAdminBdgtTempCheck(formData);
	}	  
	
	
	public String getPassCheck(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.selectPassCheck(formData);
	}	  	   
	public List<Map<String, String>> getCompanyPassflag(Map<String,String>  formData){
		return buyerMpSoOrderInfoDao.selectCompanyPassflag(formData);
	}	  	 
	
	
	public List<Map<String, String>> buyerAdminBdgtTempOrderCheck(Map<String,String>  formData) {
		return buyerMpSoOrderInfoDao.buyerAdminBdgtTempOrderCheck(formData);
	}	  	 
	public String buyerNewReCreateOrder(Map<String,String>  formData) {
		return buyerMpSoOrderInfoDao.buyerNewReCreateOrder(formData);
	}

	@Override
	public List<Map<String, String>> getCowayPointChk(String com_code, String msg, String userId) {
		return buyerMpSoOrderInfoDao.getCowayPointChk(com_code, msg, userId);
	}

	@Override
	public void insertCowayPointHistory(Map<String, Object> data) {
		buyerMpSoOrderInfoDao.insertCowayPointHistory(data);
		
	}

	@Override
	public Map<String, String> buyerNewCreateGroupware(Map<String, String> pFormData) {
		return buyerMpSoOrderInfoDao.createNewCreateGroupware(pFormData);
	}
	
	public List<Map<String, String>> getQuratisGetContents(Map<String, String> formData) {
		return buyerMpSoOrderInfoDao.getQuratisContentsList(formData);
	}
	public List<Map<String, String>> getHongikGetContents(Map<String, String> formData) {
		return buyerMpSoOrderInfoDao.getHongikContentsList(formData);
	}

	
	public String updateBuyerApItemType(Map<String, String> pMap) {
		return buyerMpSoOrderInfoDao.updateApItemType(pMap);
	}


	
	
}
