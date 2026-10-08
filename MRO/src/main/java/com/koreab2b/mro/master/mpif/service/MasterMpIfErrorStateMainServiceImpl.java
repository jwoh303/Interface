package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfErrorStateMainDao;

@Service("masterMpIfErrorStateMainService")
public class MasterMpIfErrorStateMainServiceImpl implements MasterMpIfErrorStateMainService {
	
	@Autowired
	private MasterMpIfErrorStateMainDao masterMpIfErrorStateMainDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfErrorStateMainDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfErrorStateMainDao.updateSelectedData(formData, gridData);
	}	

	// 납품요구일변경
	@Transactional
	public String updateSelectedDataRdDate(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfErrorStateMainDao.updateSelectedDataRdDate(formData, gridData);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfErrorStateMainDao.deleteSelectedData(formData, gridData);
	}
	
	//삼성전자 품의상신 번호 업데이트
	@Override
	public String updateIfPoListInfoApprDate(Map<String, String> formData, List<Object> gridData, String iFKey) {
		return masterMpIfErrorStateMainDao.updateIfPoListInfoApprDate(formData, gridData, iFKey);
	}
	
	//삼성전자 품의상신 번호 채번
	@Override
	public String SelectBuyerIFkey(Map<String, String> formData) {
		return masterMpIfErrorStateMainDao.SelectBuyerIFkey(formData);
	}
}
