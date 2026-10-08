package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.SellerMpClTranBuyerChoicePopDao;

@Service("sellerMpClTranBuyerChoicePopService")
public class SellerMpClTranBuyerChoicePopServiceImpl implements SellerMpClTranBuyerChoicePopService {
	
	@Autowired
	private SellerMpClTranBuyerChoicePopDao sellerMpClTranBuyerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClTranBuyerChoicePopDao.selectList(formData);
	}	
	

}
