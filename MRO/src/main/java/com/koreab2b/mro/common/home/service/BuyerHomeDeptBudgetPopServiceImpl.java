package com.koreab2b.mro.common.home.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.home.dao.BuyerHomeDeptBudgetPopDao;

@Service("buyerHomeDeptBudgetPopService")
public class BuyerHomeDeptBudgetPopServiceImpl implements BuyerHomeDeptBudgetPopService {
	
	@Autowired
	private BuyerHomeDeptBudgetPopDao buyerHomeDeptBudgetPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return buyerHomeDeptBudgetPopDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,Object> formData) {
		return buyerHomeDeptBudgetPopDao.selectList_v2(formData);
	}
}
