package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoChangeAccountPopDao;

@Service("buyerMpSoChangeAccountPopService")
public class BuyerMpSoChangeAccountPopServiceImpl implements BuyerMpSoChangeAccountPopService {
	@Autowired
	private BuyerMpSoChangeAccountPopDao buyerMpSoChangeAccountPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoChangeAccountPopDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return buyerMpSoChangeAccountPopDao.selectList_v2(formData);
	}
	
	// 저장
	@Transactional
	public String saveBuyerMpSoChangeAccountPop(Map<String,String>  formData) {
		return buyerMpSoChangeAccountPopDao.saveBuyerMpSoChangeAccountPop(formData);
	}
}
