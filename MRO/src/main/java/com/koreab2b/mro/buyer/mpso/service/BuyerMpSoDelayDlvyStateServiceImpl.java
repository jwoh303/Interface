package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoDelayDlvyStateDao;

@Service("buyerMpSoDelayDlvyStateService")
public class BuyerMpSoDelayDlvyStateServiceImpl implements BuyerMpSoDelayDlvyStateService {
	
	@Autowired
	private BuyerMpSoDelayDlvyStateDao buyerMpSoDelayDlvyStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoDelayDlvyStateDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpSoDelayDlvyStateDao.updateSelectedData(formData, gridData);
	}	

}
