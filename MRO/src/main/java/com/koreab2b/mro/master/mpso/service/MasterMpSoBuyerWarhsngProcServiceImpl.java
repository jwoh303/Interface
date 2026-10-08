package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoBuyerWarhsngProcDao;

@Service("masterMpSoBuyerWarhsngProcService")
public class MasterMpSoBuyerWarhsngProcServiceImpl implements MasterMpSoBuyerWarhsngProcService {
	
	@Autowired
	private MasterMpSoBuyerWarhsngProcDao masterMpSoBuyerWarhsngProcDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoBuyerWarhsngProcDao.selectList(param);
	}	
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return masterMpSoBuyerWarhsngProcDao.selectList_v2(param);
	}
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoBuyerWarhsngProcDao.updateSelectedData(formData, gridData);
	}
	@Transactional
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoBuyerWarhsngProcDao.updateSelectedData_v2(formData, gridData);
	}
	
	// 메일발송
	@Transactional
	public String updateMpSoBuyerWarhsngMailList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoBuyerWarhsngProcDao.updateMpSoBuyerWarhsngMailList(formData, gridData);
	}
}
