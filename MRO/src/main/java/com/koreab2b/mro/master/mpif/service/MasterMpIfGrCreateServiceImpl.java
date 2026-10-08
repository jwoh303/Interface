package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfGrCreateDao;

@Service("masterMpIfGrCreateService")
public class MasterMpIfGrCreateServiceImpl implements MasterMpIfGrCreateService {
	
	@Autowired
	private MasterMpIfGrCreateDao masterMpIfGrCreateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfGrCreateDao.selectList(param);
	}
	
	// 저장
	@Transactional
	public String executeDataList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfGrCreateDao.executeDataList(formData, gridData);
	}	
		
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfGrCreateDao.updateSelectedData(formData, gridData);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfGrCreateDao.deleteSelectedData(formData, gridData);
	}
	
	// 엑셀 업로드 검증
	@Transactional
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfGrCreateDao.updateSelectedDataExcelCheck(formData, gridData);
	}
}
