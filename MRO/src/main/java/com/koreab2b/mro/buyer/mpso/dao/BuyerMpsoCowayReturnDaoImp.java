package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("buyerMpsoCowayReturnDao")
public class BuyerMpsoCowayReturnDaoImp implements BuyerMpsoCowayReturnDao {


	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpsoCowayReturnDaoImp.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Override
	public List<Map<String, String>> getCowayReturnPeriod(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("buyer.mpso.getCowayReturnPeriod", pMap);
	}
	@Override
	public String setBuyerCowayReturnPeriodPop(Map<String, String> pMap) {
		String rtn	= "OK";
		
		int rCnt	= sqlSessionTemplate.update("buyer.mpso.setCowayReturnPeriod", pMap);
		
		if (rCnt == 1) {
			rtn	= "OK";
		} else {
			rtn	= "ERROR";
		}
		
		return rtn;
	}
}
