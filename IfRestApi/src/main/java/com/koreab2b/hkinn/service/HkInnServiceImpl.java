/**
 * 
 */
package com.koreab2b.hkinn.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.hkinn.dao.HkInnDao;

/**
 * @author jiwon
 *
 */
@Service("hkInnService")
public class HkInnServiceImpl implements HkInnService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(HkInnServiceImpl.class);

	@Autowired
	private HkInnDao hkInnDao;
	
	public String insertHkInnPoData(Map<String, Object> poData) throws Exception {
		return hkInnDao.insertHkInnPoData(poData);
	}

	public String insertHkInnGrData(Map<String, Object> grData) throws Exception {
		return hkInnDao.insertHkInnGrData(grData);
	}

	public List<Map<String, Object>> selectBrandLst() throws Exception {
		return hkInnDao.selectBrandLst();
	}

}
