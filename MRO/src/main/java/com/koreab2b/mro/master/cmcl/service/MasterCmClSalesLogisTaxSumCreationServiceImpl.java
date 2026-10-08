package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesLogisTaxSumCreationDao;

@Service("masterCmClSalesLogisTaxSumCreationService")
public class MasterCmClSalesLogisTaxSumCreationServiceImpl implements MasterCmClSalesLogisTaxSumCreationService {
	
	@Autowired
	private MasterCmClSalesLogisTaxSumCreationDao masterCmClSalesLogisTaxSumCreationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesLogisTaxSumCreationDao.selectList(param);
	}	
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return masterCmClSalesLogisTaxSumCreationDao.selectList_v2(param);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxSumCreationDao.updateSelectedData(formData, gridData);
	}	
	@Transactional
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxSumCreationDao.updateSelectedData_v2(formData, gridData);
	}	
	// 미마감
	@Transactional
	public String saveMasterCmClSalesLogisNotClose(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxSumCreationDao.saveMasterCmClSalesLogisNotClose(formData, gridData);
	}
	@Transactional
	public String saveMasterCmClSalesLogisNotClose_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesLogisTaxSumCreationDao.saveMasterCmClSalesLogisNotClose_v2(formData, gridData);
	}
}
