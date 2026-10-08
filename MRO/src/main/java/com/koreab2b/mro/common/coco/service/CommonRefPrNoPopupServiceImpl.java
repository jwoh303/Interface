package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.coco.dao.CommonRefPrNoPopupDao;

@Service("commonRefPrNoPopupService")
public class CommonRefPrNoPopupServiceImpl implements CommonRefPrNoPopupService {

	@Autowired
	private CommonRefPrNoPopupDao commonRefPrNoPopupDao; 
	
	@Autowired
	private CommonInfoDao commonInfoDao; 
	
	public List<Map<String,String>> buyerRefPrNoPopList_v2(Map<String, Object> formData){
		return commonRefPrNoPopupDao.buyerRefPrNoPopList_v2(formData);
	}
	
	public String getCostCode(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getCostCode(formData);
	}
	
	public String getAccountCode(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getAccountCode(formData);
	}

	
	public String getPlantCode(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getPlantCode(formData);
	}
	
	public String getDeptName(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getDeptName(formData);
	}

	
	public String getAccountName(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getAccountName(formData);
	}
	public String getCod2Text1(Map<String, String> formData) {
		return commonRefPrNoPopupDao.getCod2Text1(formData);
	}
	public List<Map<String,String>> getCod2CodeText1(Map<String, String> formData){
		return commonRefPrNoPopupDao.getCod2CodeText1(formData);
	}
	
}
