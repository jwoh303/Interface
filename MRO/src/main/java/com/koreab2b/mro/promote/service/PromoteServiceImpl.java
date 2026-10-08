package com.koreab2b.mro.promote.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.promote.dao.PromoteDao;

@Service("promoteService")
public class PromoteServiceImpl implements PromoteService {
	
	@Autowired
	private PromoteDao promoteDao;
	
	public Map<String,String> getKeyWord(){
		return promoteDao.getKeyWord();
	};
	
	public List<Map<String,String>> getCatalogItemPlan(){
		return promoteDao.getCatalogItemPlan();
	};
	
	public List<Map<String,String>> getCatalogMainItem(){
		return promoteDao.getCatalogMainItem();
	};
	
	public List<Map<String,String>> getPromoteCatalogList(Map<String,String>  formData){
		return promoteDao.getPromoteCatalogList(formData);
	};
	
	public List<Map<String,String>> getCatalogItemRecommand(Map<String,String>  formData){
		return promoteDao.getCatalogItemRecommand(formData);
	};
	
	public List<Map<String,String>> getCategoryListThis(Map<String,String>  formData){
		return promoteDao.getCategoryListThis(formData);
	};
	
	public List<Map<String,String>> getPromoteDetailList(Map<String,String>  formData){
		return promoteDao.getPromoteDetailList(formData);
	};
	
	public String saveItemApproval(Map<String,String>  formData) {
		return promoteDao.saveItemApproval(formData);
	}	
	
}
