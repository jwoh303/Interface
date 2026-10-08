package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBuyerCategoryChoicePopDao;

@Service("commonCoCoBuyerCategoryChoicePopService")
public class CommonCoCoBuyerCategoryChoicePopServiceImpl implements CommonCoCoBuyerCategoryChoicePopService {
	
	@Autowired
	private CommonCoCoBuyerCategoryChoicePopDao commonCoCoBuyerCategoryChoicePopDao;
	
	public String getCategoryComText(Map<String, String> pMap) {
		return commonCoCoBuyerCategoryChoicePopDao.getCategoryComText(pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearch(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoicePopDao.getBuyerCategorySearch(pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearchReqValue(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoicePopDao.getBuyerCategorySearchReqValue(pMap);
	}
	
}
