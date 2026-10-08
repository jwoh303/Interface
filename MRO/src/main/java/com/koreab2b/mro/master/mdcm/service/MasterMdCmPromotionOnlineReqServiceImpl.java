package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmPromotionOnlineReqDao;

@Service("masterMdCmPromotionOnlineReqService")
public class MasterMdCmPromotionOnlineReqServiceImpl implements MasterMdCmPromotionOnlineReqService {
	
	@Autowired
	private MasterMdCmPromotionOnlineReqDao masterMdCmPromotionOnlineReqDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmPromotionOnlineReqDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmPromotionOnlineReqDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmPromotionOnlineReqDao.deleteSelectedData(formData, gridData);
	}
}
