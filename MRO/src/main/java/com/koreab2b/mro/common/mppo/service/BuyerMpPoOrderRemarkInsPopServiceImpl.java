package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mppo.dao.BuyerMpPoOrderRemarkInsPopDao;

@Service("buyerMpPoOrderRemarkInsPopService")
public class BuyerMpPoOrderRemarkInsPopServiceImpl implements BuyerMpPoOrderRemarkInsPopService {
	
	@Autowired
	private BuyerMpPoOrderRemarkInsPopDao buyerMpPoOrderRemarkInsPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoOrderRemarkInsPopDao.selectList(formData);
	}	
	

}
