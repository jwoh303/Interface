package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoFagkbcAccountPopDao;

@Service("buyerMpSoFagkbcAccountPopService")
public class BuyerMpSoFagkbcAccountPopServiceImpl implements BuyerMpSoFagkbcAccountPopService {
	
	@Autowired
	private BuyerMpSoFagkbcAccountPopDao buyerMpSoFagkbcAccountPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoFagkbcAccountPopDao.selectList(formData);
	}	
	

}
