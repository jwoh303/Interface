package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmCmpyCorpManageDao;

@Service("buyerMdAmCmpyCorpManageService")
public class BuyerMdAmCmpyCorpManageServiceImpl implements BuyerMdAmCmpyCorpManageService {
	
	@Autowired
	private BuyerMdAmCmpyCorpManageDao buyerMdAmCmpyCorpManageDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmCmpyCorpManageDao.selectList(formData);
	}
	
	// 조회
		public List<Map<String,String>> getPassList(Map<String,String> formData) {
			return buyerMdAmCmpyCorpManageDao.selectPassList(formData);
		}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return buyerMdAmCmpyCorpManageDao.updateSelectedData(formData);
	}	

}
