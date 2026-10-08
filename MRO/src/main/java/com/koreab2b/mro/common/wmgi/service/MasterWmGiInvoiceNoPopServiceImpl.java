package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiInvoiceNoPopDao;

@Service("masterWmGiInvoiceNoPopService")
public class MasterWmGiInvoiceNoPopServiceImpl implements MasterWmGiInvoiceNoPopService {
	
	@Autowired
	private MasterWmGiInvoiceNoPopDao masterWmGiInvoiceNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGiInvoiceNoPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getPop(Map<String,String> formData) {
		return masterWmGiInvoiceNoPopDao.selectPop(formData);
	}	
	
	//doosan 조회
	public String getDoosan(Map<String,String> formData) {
		return masterWmGiInvoiceNoPopDao.selectDoosan(formData);
	}
	
	public List<Map<String,String>> getListDelevery(Map<String,Object> formData) {
		return masterWmGiInvoiceNoPopDao.selectList(formData);
	}	
	
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData){
		return masterWmGiInvoiceNoPopDao.updateSelectedData(formData,gridData);
	}
	
	public String updateSelectedDataDelevery(Map<String, String> formData  , List<Object> gridData){
		return masterWmGiInvoiceNoPopDao.updateSelectedDataDelevery(formData,gridData);
	}
}
