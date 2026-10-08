package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.SellerMdCtStndrdContractPopDao;

@Service("sellerMdCtStndrdContractPopService")
public class SellerMdCtStndrdContractPopServiceImpl implements SellerMdCtStndrdContractPopService {
	
	@Autowired
	private SellerMdCtStndrdContractPopDao sellerMdCtStndrdContractPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtStndrdContractPopDao.selectList(formData);
	}	
	

}
