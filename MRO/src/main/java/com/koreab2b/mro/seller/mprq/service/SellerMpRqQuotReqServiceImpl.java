package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqQuotReqDao;

@Service("sellerMpRqQuotReqService")
public class SellerMpRqQuotReqServiceImpl implements SellerMpRqQuotReqService {
	
	@Autowired
	private SellerMpRqQuotReqDao sellerMpRqQuotReqDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMpRqQuotReqDao.selectList(param);
	}
	
	// 견적저장
	@Transactional
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpRqQuotReqDao.saveSelectedData(formData, gridData);
	}

}
