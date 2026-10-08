package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStRecinpayListDao;

@Service("buyerMpStRecinpayListService")
public class BuyerMpStRecinpayListServiceImpl implements BuyerMpStRecinpayListService {
	
	@Autowired
	private BuyerMpStRecinpayListDao buyerMpStRecinpayListDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpStRecinpayListDao.selectList(formData);
	}	
	
	// 사용자 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData) {
		return buyerMpStRecinpayListDao.selectUserList(formData);
	}	
	
	// 부서 조회
	public List<Map<String,String>> getDeptList(Map<String,String> formData) {
		return buyerMpStRecinpayListDao.selectDeptList(formData);
	}	
	
}
