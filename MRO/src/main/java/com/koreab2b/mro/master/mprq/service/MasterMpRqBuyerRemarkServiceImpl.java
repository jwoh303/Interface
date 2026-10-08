package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerRemarkDao;

@Service("masterMpRqBuyerRemarkService")
public class MasterMpRqBuyerRemarkServiceImpl implements MasterMpRqBuyerRemarkService {
	
	@Autowired
	private MasterMpRqBuyerRemarkDao masterMpRqBuyerRemarkDao;

	public List<Map<String,String>> getList(Map<String,String>  pMap){
		return masterMpRqBuyerRemarkDao.getList(pMap);
	}
	
	// 저장
	public String updateSelectedData (Map<String,String> formData) {
		return masterMpRqBuyerRemarkDao.updateSelectedData(formData);
	}
}
