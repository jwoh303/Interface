package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDssSellerSelDao;

@Service("masterMpRqDssSellerSelService")
public class MasterMpRqDssSellerSelServiceImpl implements MasterMpRqDssSellerSelService {
	
	@Autowired
	private MasterMpRqDssSellerSelDao masterMpRqDssSellerSelDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqDssSellerSelDao.selectList(param);
	}	

	public List<Map<String, String>> getDssAgent(Map<String,String>  pMap){
		return masterMpRqDssSellerSelDao.getDssAgent(pMap);
	}
}
