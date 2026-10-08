package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartUploadDao;

@Service("buyerMpSoCartUploadService")
public class BuyerMpSoCartUploadServiceImpl implements BuyerMpSoCartUploadService {
	
	@Autowired
	private BuyerMpSoCartUploadDao buyerMpSoCartUploadDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoCartUploadDao.selectList(formData);
	}	
	
	// 저장
	public String setExcelUp(Map<String,String>  formData) {
		return buyerMpSoCartUploadDao.saveExcelUp(formData);
	}
	
	// 저장
	public String setCartAddReg(Map<String,String>  formData){
		return buyerMpSoCartUploadDao.saveSetCartAddReg(formData);
	}	
	//삭제
	public String setCartAddDel(Map<String,String>  formData){
		return buyerMpSoCartUploadDao.removeSetCartAddDel(formData);
	}	
}
