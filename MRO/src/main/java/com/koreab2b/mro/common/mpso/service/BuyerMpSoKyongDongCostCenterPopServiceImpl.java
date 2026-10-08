package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoKyongDongCostCenterPopDao;

@Service("buyerMpSoKyongDongCostCenterPopService")
public class BuyerMpSoKyongDongCostCenterPopServiceImpl implements BuyerMpSoKyongDongCostCenterPopService {
	
	@Autowired
	private BuyerMpSoKyongDongCostCenterPopDao buyerMpSoKyongDongCostCenterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoKyongDongCostCenterPopDao.selectList(formData);
	}	
	

}
