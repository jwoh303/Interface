package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmCatalogUnitPriceHistoryPopDao;


@Service("masterMdCmCatalogUnitPriceHistoryPopService")
public class MasterMdCmCatalogUnitPriceHistoryPopServiceImpl implements MasterMdCmCatalogUnitPriceHistoryPopService {
	
	@Autowired
	private MasterMdCmCatalogUnitPriceHistoryPopDao masterMdCmCatalogUnitPriceHistoryPopDao;

	

	// 조회
	public List<Map<String, String>> getMasterMdCmCatalogUnitPriceHistoryPop(Map<String, Object> formData) {
		// TODO Auto-generated method stub
		return masterMdCmCatalogUnitPriceHistoryPopDao.getMasterMdCmCatalogUnitPriceHistoryPop(formData);
	}	
	

}
