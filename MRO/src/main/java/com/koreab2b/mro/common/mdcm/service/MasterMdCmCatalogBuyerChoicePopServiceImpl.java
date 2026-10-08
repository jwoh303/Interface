package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmCatalogBuyerChoicePopDao;

@Service("masterMdCmCatalogBuyerChoicePopService")
public class MasterMdCmCatalogBuyerChoicePopServiceImpl implements MasterMdCmCatalogBuyerChoicePopService {
	
	@Autowired
	private MasterMdCmCatalogBuyerChoicePopDao masterMdCmCatalogBuyerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmCatalogBuyerChoicePopDao.selectList(formData);
	}	
	

}
