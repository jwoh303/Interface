package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfRequestNoPopDao;

@Service("masterMpIfRequestNoPopService")
public class MasterMpIfRequestNoPopServiceImpl implements MasterMpIfRequestNoPopService {
	
	@Autowired
	private MasterMpIfRequestNoPopDao masterMpIfRequestNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfRequestNoPopDao.selectList(formData);
	}	
	
	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object> formData) {
		return masterMpIfRequestNoPopDao.selectDetailList(formData);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfRequestNoPopDao.updateSelectedData(formData, gridData);
	}		

	// 단가임시저장
	@Transactional
	public Map<String,String> InsertSelectedPriceData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfRequestNoPopDao.InsertSelectedPriceData(formData, gridData);
	}
	
	// 구매발주
	@Transactional
	public String updateSelectedDataPo(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfRequestNoPopDao.updateSelectedDataPo(formData, gridData);
	}			
}
