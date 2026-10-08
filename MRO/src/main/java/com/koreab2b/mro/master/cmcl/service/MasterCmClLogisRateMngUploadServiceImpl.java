package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClLogisRateMngUploadDao;

@Service("masterCmClLogisRateMngUploadService")
public class MasterCmClLogisRateMngUploadServiceImpl implements MasterCmClLogisRateMngUploadService {
	
	@Autowired
	private MasterCmClLogisRateMngUploadDao masterCmClLogisRateMngUploadDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClLogisRateMngUploadDao.selectList(param);
	}

	// 업로드 저장
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData) {
		return masterCmClLogisRateMngUploadDao.saveExcelUploadData(formData, gridData);
	}

	// 저장
	public String saveUploadList(Map<String, String> formData, List<Object> gridData) {
		return masterCmClLogisRateMngUploadDao.saveUploadList(formData, gridData);
	}	
}
