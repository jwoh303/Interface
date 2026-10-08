package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoExportProgressPoDao;

@Service("masterMpSoExportProgressPoService")
public class MasterMpSoExportProgressPoServiceImpl implements MasterMpSoExportProgressPoService {
	@Autowired
	private MasterMpSoExportProgressPoDao masterMpSoExportProgressPoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoExportProgressPoDao.selectList(param);
	}	

	// HS CODE 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoExportProgressPoDao.updateSelectedData(formData, gridData);
	}
}
