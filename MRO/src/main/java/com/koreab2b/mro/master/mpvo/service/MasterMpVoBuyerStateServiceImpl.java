package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoBuyerStateDao;

@Service("masterMpVoBuyerStateService")
public class MasterMpVoBuyerStateServiceImpl implements MasterMpVoBuyerStateService {
	
	@Autowired
	private MasterMpVoBuyerStateDao masterMpVoBuyerStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpVoBuyerStateDao.selectList(param);
	}	

}
