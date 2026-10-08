package com.koreab2b.extern.buyer.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.koreab2b.extern.buyer.dao.SgsDao;
import com.koreab2b.extern.buyer.dao.SgsDaoDevImpl;
import com.koreab2b.extern.buyer.dao.SgsDaoLiveImpl;

@Service("sgsService")
public class SgsServiceImpl implements SgsService {
	
	private Logger LOGGER = LoggerFactory.getLogger(SgsServiceImpl.class);
	
	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps, Map<String, String> pMap) throws Exception{
		
		String db_conn = pMap.get("db_conn");
		
		SgsDao sgsDao = null;
		
		if ("2".equals(db_conn)) {
			sgsDao = new SgsDaoLiveImpl();
		} else {
			sgsDao = new SgsDaoDevImpl();
		}
		
		return sgsDao.saveSgsPurchaseOrder(pMaps);
	}

	public void saveLog(Map<String, String> pMap) throws Exception {
		
		String db_conn = pMap.get("db_conn");
		
		SgsDao sgsDao = null;
		
		if ("2".equals(db_conn)) {
			sgsDao = new SgsDaoLiveImpl();
		} else {
			sgsDao = new SgsDaoDevImpl();
		}
		
		sgsDao.saveLog(pMap);
	}
}