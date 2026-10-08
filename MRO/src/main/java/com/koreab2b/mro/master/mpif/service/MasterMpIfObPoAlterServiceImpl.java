package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfObPoAlterDao;

@Service("masterMpIfObPoAlterService")
public class MasterMpIfObPoAlterServiceImpl implements MasterMpIfObPoAlterService {
	
	@Autowired
	private MasterMpIfObPoAlterDao masterMpIfObPoAlterDao;
	
	@Override
	public List<Map<String, String>> getList(Map<String, Object> pMap) {
		// TODO Auto-generated method stub
		return masterMpIfObPoAlterDao.selectList(pMap);
	}

	@Override
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfObPoAlterDao.updateSelectedDataExcelCheck(formData, gridData);
	}

	@Override
	public String executeDataList(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfObPoAlterDao.executeDataList(formData, gridData);
	}

	@Override
	public String delSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfObPoAlterDao.deleteSelectedData(formData, gridData);
	}

}
