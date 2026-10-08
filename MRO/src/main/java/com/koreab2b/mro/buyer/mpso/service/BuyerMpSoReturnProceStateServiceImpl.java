package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoReturnProceStateDao;

@Service("buyerMpSoReturnProceStateService")
public class BuyerMpSoReturnProceStateServiceImpl implements BuyerMpSoReturnProceStateService {
	
	@Autowired
	private BuyerMpSoReturnProceStateDao buyerMpSoReturnProceStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoReturnProceStateDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpSoReturnProceStateDao.updateSelectedData(formData, gridData);
	}	

}
