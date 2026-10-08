package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.BuyerMpRqQuotationNegoHistoryPopDao;

@Service("buyerMpRqQuotationNegoHistoryPopService")
public class BuyerMpRqQuotationNegoHistoryPopServiceImpl implements BuyerMpRqQuotationNegoHistoryPopService {
	
	@Autowired
	private BuyerMpRqQuotationNegoHistoryPopDao buyerMpRqQuotationNegoHistoryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqQuotationNegoHistoryPopDao.selectList(formData);
	}
}
