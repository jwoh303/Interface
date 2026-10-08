package com.koreab2b.mro.seller.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.none.dao.SellerNoNeSaleshookProposalDao;

@Service("sellerNoNeSaleshookProposalService")
public class SellerNoNeSaleshookProposalServiceImpl implements SellerNoNeSaleshookProposalService {
	
	@Autowired
	private SellerNoNeSaleshookProposalDao sellerNoNeSaleshookProposalDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerNoNeSaleshookProposalDao.selectList(formData);
	}
	
	public String saveSellerNoNeSaleshookProposal(Map<String,String> formData) {
		return sellerNoNeSaleshookProposalDao.insertSellerNoNeSaleshookProposal(formData);
	}
	
	
}
