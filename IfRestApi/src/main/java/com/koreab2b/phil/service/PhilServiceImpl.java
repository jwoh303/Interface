package com.koreab2b.phil.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.phil.dao.PhilDao;
import com.koreab2b.phil.dao.PhilPrmtDao;

@Service("PhilService")
public class PhilServiceImpl implements PhilService {
	private static final Logger LOGGER = LoggerFactory.getLogger(PhilServiceImpl.class);
	
	@Autowired
	private PhilDao philDao; 
	
	@Autowired
	private PhilPrmtDao philPrmtDao; 
	
	public void insertPhilPointInfo(List<Map<String, Object>> pointList) throws Exception {
		try {
			philPrmtDao.insertPointBatch(pointList);
		} catch (Exception e) {
			LOGGER.error("####### PhilServiceImpl Error : "+ e.getMessage());
			Map<String, Object> logMap = new HashMap<String, Object>();
			
			logMap.put("INTERFACE_ID", "ifRestApi");
			logMap.put("CONTENTS", "insertPhilBudgetInfo");
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", e.getMessage());

			philDao.insertIfLog(logMap);
			
			throw e;
		}

	}

}
