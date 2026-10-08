package com.koreab2b.mro.master.wmdl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmdl.dao.MasterWmDlIntervalsProgressStateDao;

@Service("masterWmDlIntervalsProgressStateService")
public class MasterWmDlIntervalsProgressStateServiceImpl implements MasterWmDlIntervalsProgressStateService {
	
	@Autowired
	private MasterWmDlIntervalsProgressStateDao masterWmDlIntervalsProgressStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmDlIntervalsProgressStateDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlIntervalsProgressStateDao.updateSelectedData(formData, gridData);
	}	

	// 저장
	@Transactional
	public String updateSelectedPopData(Map<String,String>  formData) {
		return masterWmDlIntervalsProgressStateDao.updateSelectedPopData(formData);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlIntervalsProgressStateDao.deleteSelectedData(formData, gridData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getPopCnt(Map<String,String> param) {
		return masterWmDlIntervalsProgressStateDao.getPopCnt(param);
	}	
}
