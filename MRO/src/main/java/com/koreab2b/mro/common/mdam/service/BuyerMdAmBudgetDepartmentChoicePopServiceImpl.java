package com.koreab2b.mro.common.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdam.dao.BuyerMdAmBudgetDepartmentChoicePopDao;

@Service("buyerMdAmBudgetDepartmentChoicePopService")
public class BuyerMdAmBudgetDepartmentChoicePopServiceImpl implements BuyerMdAmBudgetDepartmentChoicePopService {
	
	@Autowired
	private BuyerMdAmBudgetDepartmentChoicePopDao buyerMdAmBudgetDepartmentChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmBudgetDepartmentChoicePopDao.selectList(formData);
	}	
	

}
