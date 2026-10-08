package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtCustomerInfoManageDao;

@Service("masterMdCtCustomerInfoManageService")
public class MasterMdCtCustomerInfoManageServiceImpl implements MasterMdCtCustomerInfoManageService {
	
	@Autowired
	private MasterMdCtCustomerInfoManageDao masterMdCtCustomerInfoManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtCustomerInfoManageDao.selectList(param);
	}
	public String uploadMasterMdCtCustomerInfoManage(Map<String, String> param,List<Object> gridData)  {
		return masterMdCtCustomerInfoManageDao.uploadMasterMdCtCustomerInfoManage(param , gridData);
	}
	// 잠재고객등록 팝업
	public List<Map<String,String>> getCustomerInfo(Map<String,String> param) {
		return masterMdCtCustomerInfoManageDao.selectCustomerInfo(param);
	}

}
