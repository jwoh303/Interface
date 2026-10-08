package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsInspDetailItemPopDao;

@Service("buyerMpDsInspDetailItemPopService")
public class BuyerMpDsInspDetailItemPopServiceImpl implements BuyerMpDsInspDetailItemPopService {
	
	@Autowired
	private BuyerMpDsInspDetailItemPopDao buyerMpDsInspDetailItemPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsInspDetailItemPopDao.selectList(formData);
	}	
	

}
