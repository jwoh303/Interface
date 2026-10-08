package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBuyerCategoryChoiceDooPopDao;

@Service("commonCoCoBuyerCategoryChoiceDooPopService")
public class CommonCoCoBuyerCategoryChoiceDooPopServiceImpl implements CommonCoCoBuyerCategoryChoiceDooPopService {
	
	@Autowired
	private CommonCoCoBuyerCategoryChoiceDooPopDao commonCoCoBuyerCategoryChoiceDooPopDao;
	
	public String getCategoryComText(Map<String, String> pMap) {
		return commonCoCoBuyerCategoryChoiceDooPopDao.getCategoryComText(pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearch(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoiceDooPopDao.getBuyerCategorySearch(pMap);
	}
	
	public List<Map<String,String>> getBuyerCategorySearchReqValue(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoiceDooPopDao.getBuyerCategorySearchReqValue(pMap);
	}
	
}
