package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

public interface BuyerMpStGiReleaseDirectionsService {

	// 리스트 조회
	public List<Map<String,String>> getBuyerMpStGiReleaseDirectionsList(Map<String,Object>  param);
	
	// 출고
	public String updateSelectedGiData(Map<String,String> formData, List<Object> gridData);
	
	// 출고취소
	public String updateSelectedGiCancelData(Map<String,String> formData, List<Object> gridData);
	
	// 확정
	public String updateSelectedGiCompleteData(Map<String,String> formData, List<Object> gridData);
	
}
