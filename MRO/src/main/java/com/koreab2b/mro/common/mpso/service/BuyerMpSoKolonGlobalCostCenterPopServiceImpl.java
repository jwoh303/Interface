package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoKolonGlobalCostCenterPopDao;

@Service("buyerMpSoKolonGlobalCostCenterPopService")
public class BuyerMpSoKolonGlobalCostCenterPopServiceImpl implements BuyerMpSoKolonGlobalCostCenterPopService {
	
	@Autowired
	private BuyerMpSoKolonGlobalCostCenterPopDao buyerMpSoKolonGlobalCostCenterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoKolonGlobalCostCenterPopDao.selectList(formData);
	}	
	

}
