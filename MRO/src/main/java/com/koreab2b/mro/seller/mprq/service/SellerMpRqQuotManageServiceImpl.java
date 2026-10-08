package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqQuotManageDao;

@Service("sellerMpRqQuotManageService")
public class SellerMpRqQuotManageServiceImpl implements SellerMpRqQuotManageService {
	
	@Autowired
	private SellerMpRqQuotManageDao sellerMpRqQuotManageDao;

	/*리뉴얼 > 전체탭 > 조회*/
	public List<Map<String,String>> getSellerMpRqQuotaList_v2(Map<String,Object>  formData){
		return sellerMpRqQuotManageDao.getSellerMpRqQuotaList_v2(formData);
	}
	
	/*리뉴얼  > 견적상세팝업 > 견적요청,포기*/
	public Map<String, Object> saveSellerMpRqQuotaDetailReqList_v2(Map<String,String>  formData){
		return sellerMpRqQuotManageDao.saveSellerMpRqQuotaDetailReqList_v2(formData);
	}
	
	/*리뉴얼  > 견적상세팝업 > 저장*/
	public Map<String, Object> saveSellerMpRqQuotaDetailProceList_v2(Map<String,String>  formData){
		return sellerMpRqQuotManageDao.saveSellerMpRqQuotaDetailProceList_v2(formData);
	}

	/*리뉴얼 > 견적요청탭 > 조회*/
	public List<Map<String,String>> getSellerMpRqQuotaReqList_v2(Map<String,Object>  formData){
		return sellerMpRqQuotManageDao.getSellerMpRqQuotaReqList_v2(formData);
	}
	
	/*리뉴얼 > 견적요청탭 > 견적제출,포기*/
	@Transactional
	public String saveSellerMpRqQuotaReqList_v2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpRqQuotManageDao.saveSellerMpRqQuotaReqList_v2(formData, gridData);
	}
	
	/*리뉴얼 > 견적요청탭 > 저장*/
	@Transactional
	public String saveSellerMpRqQuotaList_v2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpRqQuotManageDao.saveSellerMpRqQuotaList_v2(formData, gridData);
	}
	
	

	
}
