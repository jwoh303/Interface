package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoCurrencyPopDao;

@Service("commonCoCoCurrencyPopService")
public class CommonCoCoCurrencyPopServiceImpl implements CommonCoCoCurrencyPopService {
	@Autowired
	private CommonCoCoCurrencyPopDao commonCoCoCurrencyPopDao; 

	public List<Map<String, String>> getCommonCoCoCurrencyPop(Map<String, Object> pMap) {
		return commonCoCoCurrencyPopDao.getCommonCoCoCurrencyPop(pMap);
	}
}
