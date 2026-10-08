package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mppo.dao.BuyerMpPoOrderProgressDao;

@Service("buyerMpPoOrderProgressService")
public class BuyerMpPoOrderProgressServiceImpl implements BuyerMpPoOrderProgressService {
	
	@Autowired
	private BuyerMpPoOrderProgressDao buyerMpPoOrderProgressDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoOrderProgressDao.selectList(formData);
	}	
 
	// 부서별 집계
	public List<Map<String,String>> getDeptTotalList(Map<String,String> formData) {
		return buyerMpPoOrderProgressDao.selectDeptTotalList(formData);
	}

	// 협력사별 집계
	public List<Map<String,String>> getSuplTotalList(Map<String,String> formData) {
		return buyerMpPoOrderProgressDao.selectSuplTotalList(formData);
	}
	
	// 관리번호별 집계
	public List<Map<String,String>> getRefTotalList(Map<String,String> formData) {
		return buyerMpPoOrderProgressDao.selectRefTotalList(formData);
	}
}
