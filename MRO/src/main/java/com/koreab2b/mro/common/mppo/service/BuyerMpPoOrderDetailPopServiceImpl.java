package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mppo.dao.BuyerMpPoOrderDetailPopDao;

@Service("buyerMpPoOrderDetailPopService")
public class BuyerMpPoOrderDetailPopServiceImpl implements BuyerMpPoOrderDetailPopService {
	
	@Autowired
	private BuyerMpPoOrderDetailPopDao buyerMpPoOrderDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoOrderDetailPopDao.selectList(formData);
	}	
	

}
