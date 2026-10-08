package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsProductPlanViewPopDao;

@Service("masterMpDsProductPlanViewPopService")
public class MasterMpDsProductPlanViewPopServiceImpl implements MasterMpDsProductPlanViewPopService {
	
	@Autowired
	private MasterMpDsProductPlanViewPopDao masterMpDsProductPlanViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsProductPlanViewPopDao.selectList(formData);
	}	
	

}
