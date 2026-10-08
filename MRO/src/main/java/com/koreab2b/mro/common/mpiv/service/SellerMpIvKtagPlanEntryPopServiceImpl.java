package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvKtagPlanEntryPopDao;

@Service("sellerMpIvKtagPlanEntryPopService")
public class SellerMpIvKtagPlanEntryPopServiceImpl implements SellerMpIvKtagPlanEntryPopService {
	
	@Autowired
	private SellerMpIvKtagPlanEntryPopDao sellerMpIvKtagPlanEntryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvKtagPlanEntryPopDao.selectList(formData);
	}	
	
	public String updateSelectedData(Map<String, String> formData) {
		return sellerMpIvKtagPlanEntryPopDao.updateSelectedData(formData);
	}
	
	
	

}
