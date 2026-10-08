package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvBuyerOrderDetailInfoPopDao;

@Service("commonMpIvBuyerOrderDetailInfoPopService")
public class CommonMpIvBuyerOrderDetailInfoPopServiceImpl implements CommonMpIvBuyerOrderDetailInfoPopService {
	
	@Autowired
	private CommonMpIvBuyerOrderDetailInfoPopDao commonMpIvBuyerOrderDetailInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvBuyerOrderDetailInfoPopDao.selectList(formData);
	}	
	

}
