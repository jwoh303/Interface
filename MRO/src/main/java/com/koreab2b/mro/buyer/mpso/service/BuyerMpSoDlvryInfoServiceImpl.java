package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoDlvryInfoDao;

@Service("buyerMpSoDlvryInfoService")
public class BuyerMpSoDlvryInfoServiceImpl implements BuyerMpSoDlvryInfoService {
	
	@Autowired
	private BuyerMpSoDlvryInfoDao buyerMpSoDlvryInfoDao;
	
	public List<Map<String, String>>  getList(Map<String,String>  formData) {
		return buyerMpSoDlvryInfoDao.getList(formData);
	}
 
	// 우편번호검증
	public String checkZipCode(Map<String,String> formData) {
		return buyerMpSoDlvryInfoDao.checkZipCode(formData);
	}	
	
	// 기본 배송정보 입력 
	public String setUserInfoUpdate(Map<String,String>  formData) {
		return buyerMpSoDlvryInfoDao.setUserInfoUpdate(formData);
	}	
	
	// 수령희망일 입력
	public List<Map<String, String>>  getBuyerMpSoRecvDateRegisterPop(Map<String,String>  formData) {
		return buyerMpSoDlvryInfoDao.getBuyerMpSoRecvDateRegisterPop(formData);
	}
	
	// 배송조회
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoStatusList(Map<String,String>  formData)  {
		return buyerMpSoDlvryInfoDao.getBuyerMpSoDlvryInfoStatusList(formData);
	}
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList(Map<String,String>  formData)  {
		return buyerMpSoDlvryInfoDao.getBuyerMpSoDlvryInfoDtlList(formData);
	}
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList_v2(Map<String,String>  formData)  {
		return buyerMpSoDlvryInfoDao.getBuyerMpSoDlvryInfoDtlList_v2(formData);
	}

	// 부서조회(ICOMCOD2 C001)
	public String getdeptYn(Map<String, String> formData) {		
		return buyerMpSoDlvryInfoDao.getdeptYn(formData);
	}
	
	

}
