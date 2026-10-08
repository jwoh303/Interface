/**
 * 
 */
package com.koreab2b.skpc.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.skpc.dao.SkPcDao;

/**
 * @author jiwon
 *
 */
@Service("skPcService")
public class SkPcServiceImpl implements SkPcService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SkPcServiceImpl.class);

	@Autowired
	private SkPcDao skPcDao;
	
	public String updateSkPcRe(Map<String, Object> itemData) throws Exception {
		return skPcDao.updateSkPcRe(itemData);
	}
	
	public String insertSkPcPo(Map<String, Object> poData) throws Exception {
		return skPcDao.insertSkPcPo(poData);
	}

	public String insertSkPcGr(Map<String, Object> grData) throws Exception {
		return skPcDao.insertSkPcGr(grData);
	}

}
