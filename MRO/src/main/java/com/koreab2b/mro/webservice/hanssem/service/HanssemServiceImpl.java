/**
 * 
 */
package com.koreab2b.mro.webservice.hanssem.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.webservice.hanssem.dao.HanssemDao;

/**
 * @author jiwon
 *
 */
@Service("HanssemService")
public class HanssemServiceImpl implements HanssemService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HanssemServiceImpl.class);

	@Autowired
	private HanssemDao hanssemDao;
	
	public String mergeHanssemBdgtTrxl(Map<String, Object> param) throws Exception {
		return hanssemDao.mergeHanssemBdgtTrxl(param);
	}

	@Override
	public List<Map<String, String>> selectUserId(String userId) {		
		return hanssemDao.selectUserId(userId);
	}

}
