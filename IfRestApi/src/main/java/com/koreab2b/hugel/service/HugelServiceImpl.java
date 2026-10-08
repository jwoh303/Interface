package com.koreab2b.hugel.service;



import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.hugel.dao.HugelDao;

/**
 * @author jiwon
 *
 */
@Service("hugelService")
public class HugelServiceImpl implements HugelService {
	private static final Logger LOGGER = LoggerFactory.getLogger(HugelServiceImpl.class);
	
	@Autowired
	private HugelDao hugelDao;
	

	// 입고
	public String insertHugelGrData(Map<String, Object> grData) throws Exception{
		return hugelDao.insertHugelGrData(grData);
	}
	

}
