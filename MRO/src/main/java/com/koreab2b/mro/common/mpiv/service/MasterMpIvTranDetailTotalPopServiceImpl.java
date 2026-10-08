package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvTranDetailTotalPopDao;

@Service("masterMpIvTranDetailTotalPopService")
public class MasterMpIvTranDetailTotalPopServiceImpl implements MasterMpIvTranDetailTotalPopService {
	
	@Autowired
	private MasterMpIvTranDetailTotalPopDao masterMpIvTranDetailTotalPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvTranDetailTotalPopDao.selectList(formData);
	}	
	

}
