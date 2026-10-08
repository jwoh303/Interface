package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpsoCowayReturnDao {

	public List<Map<String, String>>  getCowayReturnPeriod(Map<String,String> pMap);
	
	public String setBuyerCowayReturnPeriodPop(Map<String,String> pMap);
}
