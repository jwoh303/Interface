package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqSpecChkResDao;

@Service("buyerMpRqSpecChkResService")
public class BuyerMpRqSpecChkResServiceImpl implements BuyerMpRqSpecChkResService {

	@Autowired
	private BuyerMpRqSpecChkResDao buyerMpRqSpecChkResDao;
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData){
		return buyerMpRqSpecChkResDao.selectList(formData);
	}
	
	/*등록 요청*/
	@Transactional
	public String regData(List<Object> gridData, Map<String,String>  formData){
		return buyerMpRqSpecChkResDao.updateData(gridData, formData);
	}
	
	/*장바구니 담기*/
	@Transactional
	public String addData(List<Object> gridData, Map<String,String>  formData){
		return buyerMpRqSpecChkResDao.insertData(gridData, formData);
	}

	/*장바구니 담기*/
	@Transactional
	public String delData(List<Object> gridData, Map<String,String>  formData){
		return buyerMpRqSpecChkResDao.deleteData(gridData, formData);
	}
 
}
