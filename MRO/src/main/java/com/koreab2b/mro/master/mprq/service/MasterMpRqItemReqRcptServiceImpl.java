package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqItemReqRcptDao;

@Service("masterMpRqItemReqRcptService")
public class MasterMpRqItemReqRcptServiceImpl implements MasterMpRqItemReqRcptService {
	
	@Autowired
	private MasterMpRqItemReqRcptDao masterMpRqItemReqRcptDao;

	public List<Map<String,String>> getList(Map<String,Object> pMasterMpRqItemReqRcpt) {
		return masterMpRqItemReqRcptDao.selectList(pMasterMpRqItemReqRcpt);
	}	

	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqItemReqRcptDao.updateSelectedData(formData, gridData);
	}	
	
	public List<Map<String,String>> getListBoard(Map<String,Object> pMasterMpRqItemReqRcpt) {
		return masterMpRqItemReqRcptDao.selectListBoard(pMasterMpRqItemReqRcpt);
	}	

	public String updateSelectedDataBoard(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqItemReqRcptDao.updateSelectedDataBoard(formData, gridData);
	}

}
