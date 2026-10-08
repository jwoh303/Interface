package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvRequestInfoPopDao;

@Service("commonMpIvRequestInfoPopService")
public class CommonMpIvRequestInfoPopServiceImpl implements CommonMpIvRequestInfoPopService {
	
	@Autowired
	private CommonMpIvRequestInfoPopDao commonMpIvRequestInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvRequestInfoPopDao.selectList(formData);
	}	
	

}
