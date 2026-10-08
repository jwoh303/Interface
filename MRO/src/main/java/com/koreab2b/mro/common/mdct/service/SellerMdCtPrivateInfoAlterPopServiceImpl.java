package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.SellerMdCtPrivateInfoAlterPopDao;

@Service("sellerMdCtPrivateInfoAlterPopService")
public class SellerMdCtPrivateInfoAlterPopServiceImpl implements SellerMdCtPrivateInfoAlterPopService {
	
	@Autowired
	private SellerMdCtPrivateInfoAlterPopDao sellerMdCtPrivateInfoAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtPrivateInfoAlterPopDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMdCtPrivateInfoAlterPopDao.updateSelectedData(formData);
	}
}
