package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvOrderDetailInfoPopDao;

@Service("commonMpIvOrderDetailInfoPopService")
public class CommonMpIvOrderDetailInfoPopServiceImpl implements CommonMpIvOrderDetailInfoPopService {
	
	@Autowired
	private CommonMpIvOrderDetailInfoPopDao commonMpIvOrderDetailInfoPopDao;

	// 조회
	public Map<String, String> getInfo(Map<String,String> formData) {
		return commonMpIvOrderDetailInfoPopDao.selectList(formData);
	}	
	public Map<String,String> getInfo_v2(Map<String,String> formData) {
		return commonMpIvOrderDetailInfoPopDao.selectList_v2(formData);
	}
	

}
