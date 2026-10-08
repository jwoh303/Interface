package com.koreab2b.mro.master.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmre.dao.MasterWmReReturnMultiRegDao;

@Service("masterWmReReturnMultiRegService")
public class MasterWmReReturnMultiRegServiceImpl implements MasterWmReReturnMultiRegService {
	
	@Autowired
	private MasterWmReReturnMultiRegDao masterWmReReturnMultiRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmReReturnMultiRegDao.selectList(param);
	}	

	// BNTRXL 저장
	@Transactional
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnMultiRegDao.updateUploadData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnMultiRegDao.deleteSelectedData(formData, gridData);
	}

	// 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnMultiRegDao.updateSelectedData(formData, gridData);
	}
}
