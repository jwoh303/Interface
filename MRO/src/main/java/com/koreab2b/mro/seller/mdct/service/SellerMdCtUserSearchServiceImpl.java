package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtUserSearchDao;

@Service("sellerMdCtUserSearchService")
public class SellerMdCtUserSearchServiceImpl implements SellerMdCtUserSearchService {
	
	@Autowired
	private SellerMdCtUserSearchDao sellerMdCtUserSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtUserSearchDao.selectList(formData);
	}

	// 리뉴얼용 조회 (페이징 없음)
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return sellerMdCtUserSearchDao.selectList_v2(formData);
	}

	// 삭제
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMdCtUserSearchDao.updateSelectedData(formData);
	}

}
