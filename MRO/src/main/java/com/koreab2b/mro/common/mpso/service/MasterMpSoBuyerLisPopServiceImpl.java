package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoBuyerLisPopDao;

@Service("masterMpSoBuyerLisPopService")
public class MasterMpSoBuyerLisPopServiceImpl implements MasterMpSoBuyerLisPopService {
	
	@Autowired
	private MasterMpSoBuyerLisPopDao masterMpSoBuyerLisPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoBuyerLisPopDao.selectList(formData);
	}	
	

}
