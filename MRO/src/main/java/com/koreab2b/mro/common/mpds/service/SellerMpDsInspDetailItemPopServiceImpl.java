package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsInspDetailItemPopDao;

@Service("sellerMpDsInspDetailItemPopService")
public class SellerMpDsInspDetailItemPopServiceImpl implements SellerMpDsInspDetailItemPopService {
	
	@Autowired
	private SellerMpDsInspDetailItemPopDao sellerMpDsInspDetailItemPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsInspDetailItemPopDao.selectList(formData);
	}	
	

}
