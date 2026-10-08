package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerDesignAgentDao;

@Service("masterMpRqBuyerDesignAgentService")
public class MasterMpRqBuyerDesignAgentServiceImpl implements MasterMpRqBuyerDesignAgentService {
	
	@Autowired
	private MasterMpRqBuyerDesignAgentDao masterMpRqBuyerDesignAgentDao;
	
	// 조회
	public Map<String, String> getInfo(Map<String,String> formData) {
		return masterMpRqBuyerDesignAgentDao.selectInfo(formData);
	}
		
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqBuyerDesignAgentDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqBuyerDesignAgentDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqBuyerDesignAgentDao.deleteSelectedData(formData, gridData);
	}
}
