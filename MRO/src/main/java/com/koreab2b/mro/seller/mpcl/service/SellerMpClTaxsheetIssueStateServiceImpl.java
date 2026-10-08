package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClTaxsheetIssueStateDao;

@Service("sellerMpClTaxsheetIssueStateService")
public class SellerMpClTaxsheetIssueStateServiceImpl implements SellerMpClTaxsheetIssueStateService {
	
	@Autowired
	private SellerMpClTaxsheetIssueStateDao sellerMpClTaxsheetIssueStateDao;

	// 조회 (레거시)
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClTaxsheetIssueStateDao.selectList(formData);
	}

	// 조회 (리뉴얼)
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return sellerMpClTaxsheetIssueStateDao.selectList_v2(formData);
	}

}
