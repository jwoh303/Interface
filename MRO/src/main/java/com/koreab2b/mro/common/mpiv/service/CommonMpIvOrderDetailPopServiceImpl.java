package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvOrderDetailPopDao;

@Service("commonMpIvOrderDetailPopService")
public class CommonMpIvOrderDetailPopServiceImpl implements CommonMpIvOrderDetailPopService {
	
	@Autowired
	private CommonMpIvOrderDetailPopDao commonMpIvOrderDetailPopDao;

	
	public Map<String,String> getInfo(Map<String,String> formData) {
		return commonMpIvOrderDetailPopDao.selectInfo(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvOrderDetailPopDao.selectList(formData);
	}
	public List<Map<String,String>> getCommonMpIvBuyerOrderDetailListPop_v2(Map<String,Object> formData) {
		return commonMpIvOrderDetailPopDao.getCommonMpIvBuyerOrderDetailListPop_v2(formData);
	}
}
