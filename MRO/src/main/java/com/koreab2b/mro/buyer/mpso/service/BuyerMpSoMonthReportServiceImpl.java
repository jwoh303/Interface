package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoMonthReportDao;

@Service("buyerMpSoMonthReportService")
public class BuyerMpSoMonthReportServiceImpl  implements BuyerMpSoMonthReportService {
	
	@Autowired
	private BuyerMpSoMonthReportDao buyerMpSoMonthReportDao;

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param) {
		return buyerMpSoMonthReportDao.selectList(param);
	}
}
