package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqQuotaProceStateAdminDao;

@Service("buyerMpRqQuotaProceStateAdminService")
public class BuyerMpRqQuotaProceStateAdminServiceImpl implements BuyerMpRqQuotaProceStateAdminService {
	
	@Autowired
	private BuyerMpRqQuotaProceStateAdminDao buyerMpRqQuotaProceStateAdminDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqQuotaProceStateAdminDao.selectList(formData);
	}	
	//신규품목현황
	public List<Map<String,String>> getSourcList(Map<String,String> formData) {
		return buyerMpRqQuotaProceStateAdminDao.selectSourcList(formData);
	}		
	//신규발주현황
	public List<Map<String,String>> getNewPoList(Map<String,String> formData) {
		return buyerMpRqQuotaProceStateAdminDao.selectNewPoList(formData);
	}
}
