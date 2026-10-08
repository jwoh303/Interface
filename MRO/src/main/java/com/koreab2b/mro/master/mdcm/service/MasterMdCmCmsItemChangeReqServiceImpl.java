package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemChangeReqDao;

@Service("masterMdCmCmsItemChangeReqService")
public class MasterMdCmCmsItemChangeReqServiceImpl implements MasterMdCmCmsItemChangeReqService {

	@Autowired
	private MasterMdCmCmsItemChangeReqDao masterMdCmCmsItemChangeReqDao;

	public List<Map<String,String>> getStatusList(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.selectStatusList(param);
	}

	public List<Map<String,String>> getReqList(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.selectReqList(param);
	}

	public int getOpenReqCount(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.selectOpenReqCount(param);
	}

	public String saveChangeReq(Map<String,Object> param, List<Map<String,String>> items) {
		return masterMdCmCmsItemChangeReqDao.insertChangeReq(param, items);
	}

	public String saveChangeReqFromExcel(Map<String,Object> param, List<Map<String,String>> items) {
		return masterMdCmCmsItemChangeReqDao.insertChangeReqFromExcel(param, items);
	}

	public int cancelChangeReq(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.updateChangeReqCancel(param);
	}

	public Map<String,String> getHeader(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.selectHeader(param);
	}

	public List<Map<String,String>> getDtList(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.selectDtList(param);
	}

	public int approveChangeReq(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.approveChangeReq(param);
	}

	public int rejectChangeReq(Map<String,Object> param) {
		return masterMdCmCmsItemChangeReqDao.rejectChangeReq(param);
	}
}
