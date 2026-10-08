package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoYuHanKimChonPopDao;

@Service("buyerMpSoYuHanKimChonPopService")
public class BuyerMpSoYuHanKimChonPopServiceImpl implements BuyerMpSoYuHanKimChonPopService {
	
	@Autowired
	private BuyerMpSoYuHanKimChonPopDao buyerMpSoYuHanKimChonPopDao;

	// 조회 
	public List<Map<String,String>> getLegacyUserId(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectLegacyUserIdList(formData);
	}	
	public List<Map<String,String>> getRefHdInfo(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectRefHdInfoList(formData);
	}	

	public String  getUserNameLoc(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectUserNameLoc(formData);
	}	
	public String  getUserAddressLoc(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectUserAddressLoc(formData);
	}	
	public String  getCenterCode(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectCenterCode(formData);
	}	
	public String  getprofitSegmentCode(Map<String,String>  formData){
		return buyerMpSoYuHanKimChonPopDao.selectprofitSegmentCode(formData);
	}	
	
	public String  saveBuyerYuhanRetUpdate(Map<String,String>  formData) {
		return buyerMpSoYuHanKimChonPopDao.saveBuyerYuhanRetUpdate(formData);
	}	
	 
	
}
