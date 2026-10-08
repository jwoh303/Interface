package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqEstiReqDao;

@Service("sellerMpRqEstiReqService")
public class SellerMpRqEstiReqServiceImpl implements SellerMpRqEstiReqService {

	@Autowired
	private SellerMpRqEstiReqDao sellerMpRqEstiReqDao;
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData){
		return sellerMpRqEstiReqDao.selectList(formData);
	}
	
	/*등록 요청*/
	@Transactional
	public String updateData(Map<String,String>  formData, List<Object> gridData) {
		return sellerMpRqEstiReqDao.updateData(formData ,gridData);
	}
	

	/*포기*/
	@Transactional
	public String sellerMpRqEstiReqGiveUp(Map<String,String> formData, List<Object> gridData){
		return sellerMpRqEstiReqDao.sellerMpRqEstiReqGiveUp(formData,gridData);
	}
 
}
