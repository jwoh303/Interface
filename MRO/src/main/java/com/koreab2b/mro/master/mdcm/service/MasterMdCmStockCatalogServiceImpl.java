package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmStockCatalogDao;

@Service("masterMdCmStockCatalogService")
public class MasterMdCmStockCatalogServiceImpl implements MasterMdCmStockCatalogService {
	
	@Autowired
	private MasterMdCmStockCatalogDao masterMdCmStockCatalogDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmStockCatalogDao.selectList(param);
	}	
	
	public String getBycaComorgSelect(Map<String,Object> param) {
		return masterMdCmStockCatalogDao.getBycaComorgSelect(param);
	}

}
