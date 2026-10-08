package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoPayRegMngUploadPopDao;

@Service("masterMpSoPayRegMngUploadPopService")
public class MasterMpSoPayRegMngUploadPopServiceImpl implements MasterMpSoPayRegMngUploadPopService {
	
	@Autowired
	private MasterMpSoPayRegMngUploadPopDao masterMpSoPayRegMngUploadPopDao;
  
	
	// 업로드 조회
	public List<Map<String, String>> getList(Map<String, Object> param) {
		return masterMpSoPayRegMngUploadPopDao.getList(param);
	}
	
	// PO 조회
	public List<Map<String, String>> PoSearch(Map<String, String> param) {
		return masterMpSoPayRegMngUploadPopDao.PoSearch(param);
	}


	// 엑셀 업로드 저장
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoPayRegMngUploadPopDao.saveExcelUploadData(formData, gridData);
	}

	// 지급이슈 저장
	public String saveUploadList(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoPayRegMngUploadPopDao.saveUploadList(formData, gridData);
	}

	// 삭제
	public String deleteUploadList(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoPayRegMngUploadPopDao.deleteUploadList(formData, gridData);
	}


	

}
