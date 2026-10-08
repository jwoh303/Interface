package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBuyerItemNoChangePopDao;

@Service("masterMpRqBuyerItemNoChangePopService")
public class MasterMpRqBuyerItemNoChangePopServiceImpl implements MasterMpRqBuyerItemNoChangePopService {
	
	@Autowired
	private MasterMpRqBuyerItemNoChangePopDao masterMpRqBuyerItemNoChangePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpRqBuyerItemNoChangePopDao.selectList(formData);
	}	
	

}
