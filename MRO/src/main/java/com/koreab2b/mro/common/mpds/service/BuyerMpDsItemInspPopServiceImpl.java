package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsItemInspPopDao;

@Service("buyerMpDsItemInspPopService")
public class BuyerMpDsItemInspPopServiceImpl implements BuyerMpDsItemInspPopService {
	
	@Autowired
	private BuyerMpDsItemInspPopDao buyerMpDsItemInspPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsItemInspPopDao.selectList(formData);
	}	
	

}
