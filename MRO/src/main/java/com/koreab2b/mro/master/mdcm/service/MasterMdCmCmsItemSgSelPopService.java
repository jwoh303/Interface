package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemSgSelPopService {

	// 카테고리(KEPSGMG) 목록 조회 - 페이징 없음
	public List<Map<String,String>> getList(Map<String,String> formData);

}
