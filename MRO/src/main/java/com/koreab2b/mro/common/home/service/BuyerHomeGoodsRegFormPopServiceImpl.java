package com.koreab2b.mro.common.home.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.home.dao.BuyerHomeGoodsRegFormPopDao;

@Service("buyerHomeGoodsRegFormPopService")
public class BuyerHomeGoodsRegFormPopServiceImpl implements BuyerHomeGoodsRegFormPopService {
	
	@Autowired
	private BuyerHomeGoodsRegFormPopDao buyerHomeGoodsRegFormPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return buyerHomeGoodsRegFormPopDao.selectList(formData);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerHomeGoodsRegFormPopDao.updateSelectedData(formData, gridData);
	}
	
	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerHomeGoodsRegFormPopDao.deleteSelectedData(formData, gridData);
	}
}
