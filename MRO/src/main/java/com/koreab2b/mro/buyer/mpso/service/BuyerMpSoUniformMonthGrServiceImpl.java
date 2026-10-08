package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoUniformMonthGrDao;

@Service("buyerMpSoUniformMonthGrService")
public class BuyerMpSoUniformMonthGrServiceImpl implements BuyerMpSoUniformMonthGrService {
	
	@Autowired
	private BuyerMpSoUniformMonthGrDao buyerMpSoUniformMonthGrDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMpSoUniformMonthGrDao.selectList(param);
	}	
}
