package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBuyerCategoryChoiceTreePopDao;

@Service("commonCoCoBuyerCategoryChoiceTreePopService")
public class CommonCoCoBuyerCategoryChoiceTreePopServiceImpl implements CommonCoCoBuyerCategoryChoiceTreePopService {
	
	@Autowired
	private CommonCoCoBuyerCategoryChoiceTreePopDao commonCoCoBuyerCategoryChoiceTreePopDao;
	
	public String getCategoryComText(Map<String, String> pMap) {
		return commonCoCoBuyerCategoryChoiceTreePopDao.getCategoryComText(pMap);
	}
	
	public List<Map<String,String>> getCategoryTreeRootSelect(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoiceTreePopDao.getCategoryTreeRootSelect(pMap);
	}
	
	public List<Map<String,String>> getCategoryTreeChildSelect(Map<String,String> pMap) {
		return commonCoCoBuyerCategoryChoiceTreePopDao.getCategoryTreeChildSelect(pMap);
	}

}
