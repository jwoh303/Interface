package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvHistoryViewPopDao;

@Service("commonMpIvHistoryViewPopService")
public class CommonMpIvHistoryViewPopServiceImpl implements CommonMpIvHistoryViewPopService {
	
	@Autowired
	private CommonMpIvHistoryViewPopDao commonMpIvHistoryViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvHistoryViewPopDao.selectList(formData);
	}	
	

}
