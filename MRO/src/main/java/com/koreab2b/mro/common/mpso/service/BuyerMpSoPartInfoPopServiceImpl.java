package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoPartInfoPopDao;

@Service("buyerMpSoPartInfoPopService")
public class BuyerMpSoPartInfoPopServiceImpl implements BuyerMpSoPartInfoPopService {
	
	@Autowired
	private BuyerMpSoPartInfoPopDao buyerMpSoPartInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoPartInfoPopDao.selectList(formData);
	}	
	

}
