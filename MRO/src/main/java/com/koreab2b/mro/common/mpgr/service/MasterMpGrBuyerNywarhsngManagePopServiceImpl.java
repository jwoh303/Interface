package com.koreab2b.mro.common.mpgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpgr.dao.MasterMpGrBuyerNywarhsngManagePopDao;

@Service("masterMpGrBuyerNywarhsngManagePopService")
public class MasterMpGrBuyerNywarhsngManagePopServiceImpl implements MasterMpGrBuyerNywarhsngManagePopService {
	
	@Autowired
	private MasterMpGrBuyerNywarhsngManagePopDao masterMpGrBuyerNywarhsngManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpGrBuyerNywarhsngManagePopDao.selectList(formData);
	}	
	

}
