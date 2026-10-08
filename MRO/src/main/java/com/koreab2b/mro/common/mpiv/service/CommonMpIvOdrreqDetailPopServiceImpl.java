package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvOdrreqDetailPopDao;

@Service("commonMpIvOdrreqDetailPopService")
public class CommonMpIvOdrreqDetailPopServiceImpl implements CommonMpIvOdrreqDetailPopService {
	
	@Autowired
	private CommonMpIvOdrreqDetailPopDao commonMpIvOdrreqDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvOdrreqDetailPopDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return commonMpIvOdrreqDetailPopDao.selectList_v2(formData);
	}
	public List<Map<String,String>> getBuyerPrDisplayDtListPop(Map<String,String>  formData) {
		return commonMpIvOdrreqDetailPopDao.selectBuyerPrDisplayDtListPop(formData);
	}
	public List<Map<String,String>> getBuyerPrDisplayDtListPop_v2(Map<String,String>  formData) {
		return commonMpIvOdrreqDetailPopDao.getBuyerPrDisplayDtListPop_v2(formData);
	}

}
