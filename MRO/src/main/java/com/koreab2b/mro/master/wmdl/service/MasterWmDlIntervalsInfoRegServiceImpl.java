package com.koreab2b.mro.master.wmdl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmdl.dao.MasterWmDlIntervalsInfoRegDao;

@Service("masterWmDlIntervalsInfoRegService")
public class MasterWmDlIntervalsInfoRegServiceImpl implements MasterWmDlIntervalsInfoRegService {
	
	@Autowired
	private MasterWmDlIntervalsInfoRegDao masterWmDlIntervalsInfoRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmDlIntervalsInfoRegDao.selectList(param);
	}	

	// 리스트 조회
	public List<Map<String,String>> getAllList(Map<String,Object> param) {
		return masterWmDlIntervalsInfoRegDao.selectAllList(param);
	}		
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlIntervalsInfoRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlIntervalsInfoRegDao.deleteSelectedData(formData, gridData);
	}
}
