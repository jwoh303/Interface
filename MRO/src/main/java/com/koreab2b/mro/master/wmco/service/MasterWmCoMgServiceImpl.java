package com.koreab2b.mro.master.wmco.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmco.controller.MasterWmCoMgController;
import com.koreab2b.mro.master.wmco.dao.MasterWmCoMgDao;
import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDao;

@Service("masterWmCoMgService")
public class MasterWmCoMgServiceImpl implements MasterWmCoMgService {
	
	@Autowired
	private MasterWmCoMgDao masterWmCoMgDao;

	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoMgController.class);
	
	// warehouse_code 조회
	public String getForwarehouseCode(Map<String,Object> param) {
		logger.debug("MasterWmCoMgServiceImpl : {}", param);
		return masterWmCoMgDao.getForwarehouseCode(param);
	}	
	
	// warehouse_code 조회
	public String getForwarehouseAgent(Map<String,Object> param) {
		logger.debug("MasterWmCoMgServiceImpl : {}", param);
		return masterWmCoMgDao.getForwarehouseAgent(param);
	}

}
