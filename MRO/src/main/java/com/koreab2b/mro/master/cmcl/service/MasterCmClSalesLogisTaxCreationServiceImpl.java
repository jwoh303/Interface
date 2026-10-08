package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesLogisTaxCreationDao;

@Service("masterCmClSalesLogisTaxCreationService")
public class MasterCmClSalesLogisTaxCreationServiceImpl implements MasterCmClSalesLogisTaxCreationService {
	
	@Autowired
	private MasterCmClSalesLogisTaxCreationDao masterCmClSalesLogisTaxCreationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesLogisTaxCreationDao.selectList(param);
	}	
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return masterCmClSalesLogisTaxCreationDao.selectList_v2(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxCreationDao.updateSelectedData(formData, gridData);
	}	
	@Transactional
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxCreationDao.updateSelectedData_v2(formData, gridData);
	}	

}
