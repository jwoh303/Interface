 package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmGoodsCategDao;

@Service("buyerMdCmGoodsCategService")
public class BuyerMdCmGoodsCategServiceImpl implements BuyerMdCmGoodsCategService {
	
	@Autowired
	private BuyerMdCmGoodsCategDao buyerMdCmGoodsCategDao;
	// 코드 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMdCmGoodsCategDao.selectList(param);
	}	
	// 코드 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdCmGoodsCategDao.updateSelectedData(formData, gridData);
	}
	@Transactional
	public int updateBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		return buyerMdCmGoodsCategDao.updateBuyerMdAmGoodsCategLis_v2(formData);
	}
	
	// 코드 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdCmGoodsCategDao.deleteSelectedData(formData, gridData);
	}
	@Transactional
	public int delBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		return buyerMdCmGoodsCategDao.delBuyerMdAmGoodsCategLis_v2(formData);
	}
	
	// 코드 추가
	@Transactional
	public int saveBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		return buyerMdCmGoodsCategDao.saveBuyerMdAmGoodsCategLis_v2(formData);
	}
}
