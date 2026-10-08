package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStRecinpayStateDao;

@Service("buyerMpStRecinpayStateService")
public class BuyerMpStRecinpayStateServiceImpl implements BuyerMpStRecinpayStateService {
	
	@Autowired
	private BuyerMpStRecinpayStateDao buyerMpStRecinpayStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpStRecinpayStateDao.selectList(formData);
	}	

}
