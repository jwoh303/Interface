package com.koreab2b.lottecs.service;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.lottecs.dao.LottecsDao;



@Service("lottecsService")
public class LottecsServiceImpl implements LottecsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(LottecsServiceImpl.class);
	
	@Autowired
	private LottecsDao LottecsDao;

	public Map<String, Object> getLotteMpRqAppSend(Map<String, Object> pMap) throws Exception {
		return LottecsDao.processLotteMpRqAppSend(pMap);
	}
}
