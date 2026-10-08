package com.koreab2b.mro.master.mpso.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoSellerDiDao;

@Service("masterMpSoSellerDiService")
public class MasterMpSoSellerDiServiceImpl implements MasterMpSoSellerDiService {
	
	@Autowired
	private MasterMpSoSellerDiDao masterMpSoSellerDiDao;
  
	
	// 리스트조회
	public List<Map<String,String>> getMasterMpSoSellerDiList_v2(Map<String,Object>  param) {
		return masterMpSoSellerDiDao.getMasterMpSoSellerDiList_v2(param);
	}	

	// 저장
	public String saveMpSoSellerDiTaxType_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoSellerDiDao.saveMpSoSellerDiTaxType_v2(formData, gridData);
	}	
	
	//재고합계금액 팝업 조회
	public List<Map<String,String>> getMasterMpSoSellerDiStockSumPopList_v2(Map<String,Object>  param) {
		return masterMpSoSellerDiDao.getMasterMpSoSellerDiStockSumPopList_v2(param);
	}
}
