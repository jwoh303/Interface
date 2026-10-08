package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.SellerMdCtPrivateInfoPopDao;

@Service("sellerMdCtPrivateInfoPopService")
public class SellerMdCtPrivateInfoPopServiceImpl implements SellerMdCtPrivateInfoPopService {
	
	@Autowired
	private SellerMdCtPrivateInfoPopDao sellerMdCtPrivateInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtPrivateInfoPopDao.selectList(formData);
	}	
	

}
