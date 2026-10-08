package com.koreab2b.mro.seller.none.service;

import java.util.List;
import java.util.Map;

public interface SellerNoNeSaleshookProposalService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public String saveSellerNoNeSaleshookProposal(Map<String,String> formData);
}
