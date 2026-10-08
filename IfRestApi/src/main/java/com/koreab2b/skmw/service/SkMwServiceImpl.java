/**
 * 
 */
package com.koreab2b.skmw.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.skmw.dao.SkMwDao;

/**
 * @author jiwon
 *
 */
@Service("skMwService")
public class SkMwServiceImpl implements SkMwService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SkMwServiceImpl.class);

	@Autowired
	private SkMwDao skMwDao;
	
	public String updateSkMwItem(Map<String, Object> itemData) throws Exception {
		return skMwDao.updateSkMwItem(itemData);
	}
	
	public String insertSkMwPo(Map<String, Object> poData) throws Exception {
		return skMwDao.insertSkMwPo(poData);
	}

	public String insertSkMwGr(Map<String, Object> grData) throws Exception {
		return skMwDao.insertSkMwGr(grData);
	}

}
