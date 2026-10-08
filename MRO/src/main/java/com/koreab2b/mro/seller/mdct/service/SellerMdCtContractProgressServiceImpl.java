package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtContractProgressDao;

@Service("sellerMdCtContractProgressService")
public class SellerMdCtContractProgressServiceImpl implements SellerMdCtContractProgressService {
	
	@Autowired
	private SellerMdCtContractProgressDao sellerMdCtContractProgressDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtContractProgressDao.selectList(formData);
	}	

}
