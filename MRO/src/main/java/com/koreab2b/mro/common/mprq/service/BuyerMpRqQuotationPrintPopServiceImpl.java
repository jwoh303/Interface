package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.BuyerMpRqQuotationPrintPopDao;

@Service("buyerMpRqQuotationPrintPopService")
public class BuyerMpRqQuotationPrintPopServiceImpl implements BuyerMpRqQuotationPrintPopService {
	
	@Autowired
	private BuyerMpRqQuotationPrintPopDao buyerMpRqQuotationPrintPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqQuotationPrintPopDao.selectList(formData);
	}	
	

}
