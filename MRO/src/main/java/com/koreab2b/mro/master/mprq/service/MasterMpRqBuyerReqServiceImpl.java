package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Service("masterMpRqBuyerReqService")
public class MasterMpRqBuyerReqServiceImpl implements MasterMpRqBuyerReqService {
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;

	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqBuyerReqDao.updateSelectedData(formData, gridData);
	}	

	
}
