package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtMbrCmpyInfoDao;

@Service("sellerMdCtMbrCmpyInfoService")
public class SellerMdCtMbrCmpyInfoServiceImpl implements SellerMdCtMbrCmpyInfoService {
	
	@Autowired
	private SellerMdCtMbrCmpyInfoDao sellerMdCtMbrCmpyInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtMbrCmpyInfoDao.selectList(formData);
	}
	// 조회
	public List<Map<String,String>> getDelyAreaList(Map<String,String> formData) {
		return sellerMdCtMbrCmpyInfoDao.selectDelyAreaList(formData);
	}
	// 저장 (레거시)
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMdCtMbrCmpyInfoDao.updateSelectedData(formData);
	}
	// 저장 (리뉴얼)
	public String updateSelectedData_v2(Map<String,String> formData) {
		return sellerMdCtMbrCmpyInfoDao.updateSelectedData_v2(formData);
	}

}
