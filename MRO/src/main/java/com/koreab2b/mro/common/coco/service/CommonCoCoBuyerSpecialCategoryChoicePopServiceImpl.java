package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBuyerSpecialCategoryChoicePopDao;

@Service("commonCoCoBuyerSpecialCategoryChoicePopService")
public class CommonCoCoBuyerSpecialCategoryChoicePopServiceImpl implements CommonCoCoBuyerSpecialCategoryChoicePopService {
	
	@Autowired
	private CommonCoCoBuyerSpecialCategoryChoicePopDao commonCoCoBuyerSpecialCategoryChoicePopDao;
	
	public List<Map<String,String>> getSpecialStdCategLevel1(Map<String,String> pMap) {
		return commonCoCoBuyerSpecialCategoryChoicePopDao.getSpecialStdCategLevel1(pMap);
	}
	
	public List<Map<String,String>> getBuyerSpecialCategorySearch(Map<String,String> pMap) {
		return commonCoCoBuyerSpecialCategoryChoicePopDao.getBuyerSpecialCategorySearch(pMap);
	}
	
	public List<Map<String,String>> getBuyerSpecialCategorySearchReqValue(Map<String,String> pMap) {
		return commonCoCoBuyerSpecialCategoryChoicePopDao.getBuyerSpecialCategorySearchReqValue(pMap);
	}
	
}
