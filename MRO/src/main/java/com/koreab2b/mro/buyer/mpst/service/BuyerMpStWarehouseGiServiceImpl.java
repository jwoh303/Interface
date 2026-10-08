package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStWarehouseGiDao;


@Service("buyerMpStWarehouseGiService")
public class BuyerMpStWarehouseGiServiceImpl implements BuyerMpStWarehouseGiService {
	
	@Autowired
	private BuyerMpStWarehouseGiDao buyerMpStWarehouseGiDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMpStWarehouseGiDao.selectList(param);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpStWarehouseGiDao.deleteSelectedData(formData, gridData);
	}
	
	// 출고
	@Transactional
	public String setSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpStWarehouseGiDao.setSelectedData(formData, gridData);
	}
}
