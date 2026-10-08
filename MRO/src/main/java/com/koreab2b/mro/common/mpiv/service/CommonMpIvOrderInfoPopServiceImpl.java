package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvOrderInfoPopDao;

@Service("commonMpIvOrderInfoPopService")
public class CommonMpIvOrderInfoPopServiceImpl implements CommonMpIvOrderInfoPopService {
	
	@Autowired
	private CommonMpIvOrderInfoPopDao commonMpIvOrderInfoPopDao;

	// 조회
	public List<Map<String,String>> getDetailList(Map<String,String> pMap) {
		return commonMpIvOrderInfoPopDao.selectList(pMap);
	}	
	

}
