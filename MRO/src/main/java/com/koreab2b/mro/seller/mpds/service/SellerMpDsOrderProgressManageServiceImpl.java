package com.koreab2b.mro.seller.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpds.dao.SellerMpDsOrderProgressManageDao;

@Service("sellerMpDsOrderProgressManageService")
public class SellerMpDsOrderProgressManageServiceImpl implements SellerMpDsOrderProgressManageService {
	
	@Autowired
	private SellerMpDsOrderProgressManageDao sellerMpDsOrderProgressManageDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsOrderProgressManageDao.selectList(formData);
	}	
	
	//납품실적등록
	public String updateSelectedDataDiReg(Map<String,String> formData, List<Object> gridData) {
		return sellerMpDsOrderProgressManageDao.updateSelectedDataDiReg(formData, gridData);
	}	
	
	// 납품실적취소	
	public String updateSelectedDataDiCancel(Map<String,String> formData, List<Object> gridData) {
		return sellerMpDsOrderProgressManageDao.updateSelectedDataDiCancel(formData, gridData);
	}	
	
	// 거래명세서삭제
	public String updateSelectedDataIvCancel(Map<String,String> formData, List<Object> gridData) {
		return sellerMpDsOrderProgressManageDao.updateSelectedDataIvCancel(formData, gridData);
	}		
}
