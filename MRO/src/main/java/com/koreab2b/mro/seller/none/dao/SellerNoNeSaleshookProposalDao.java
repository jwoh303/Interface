package com.koreab2b.mro.seller.none.dao;

import java.util.List;
import java.util.Map;

public interface SellerNoNeSaleshookProposalDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	public String insertSellerNoNeSaleshookProposal(Map<String,String> formData);
}
