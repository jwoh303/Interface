package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqSellerSelPopDao;

@Service("masterMpRqSellerSelPopService")
public class MasterMpRqSellerSelPopServiceImpl implements MasterMpRqSellerSelPopService {
	
	@Autowired
	private MasterMpRqSellerSelPopDao masterMpRqSellerSelPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqSellerSelPopDao.selectList(formData);
	}	
	

}
