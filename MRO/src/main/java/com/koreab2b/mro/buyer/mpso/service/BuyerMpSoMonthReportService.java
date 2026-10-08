package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoMonthReportService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
}
