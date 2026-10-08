package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoWarehousingDetailPopDao;

@Service("masterWmCoWarehousingDetailPopService")
public class MasterWmCoWarehousingDetailPopServiceImpl implements MasterWmCoWarehousingDetailPopService {
	
	@Autowired
	private MasterWmCoWarehousingDetailPopDao masterWmCoWarehousingDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoWarehousingDetailPopDao.selectList(formData);
	}	
	public List<Map<String,String>> getDetail(Map<String,Object> formData) {
		return masterWmCoWarehousingDetailPopDao.selectDetail(formData);
	}		
	
	//TR입고
	public String updateSelectedData(Map<String, String> formData,List<Object> gridData) {
		return masterWmCoWarehousingDetailPopDao.updateSelectedData(formData,gridData);
	}	
	public String updateSelectedData_v2(Map<String, String> formData,List<Object> gridData) {
		return masterWmCoWarehousingDetailPopDao.updateSelectedData_v2(formData,gridData);
	}
	
	//TR출고
	public String updateSelectedDataIvt(Map<String, String> formData,List<Object> gridData) {
		return masterWmCoWarehousingDetailPopDao.updateSelectedDataIvt(formData,gridData);
	}	

}
