package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoUniformChoicePopDao;

@Service("buyerMpSoUniformChoicePopService")
public class BuyerMpSoUniformChoicePopServiceImpl implements BuyerMpSoUniformChoicePopService {
	
	@Autowired
	private BuyerMpSoUniformChoicePopDao buyerMpSoUniformChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoUniformChoicePopDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		return buyerMpSoUniformChoicePopDao.updateSelectedData(formData);
	}
}
