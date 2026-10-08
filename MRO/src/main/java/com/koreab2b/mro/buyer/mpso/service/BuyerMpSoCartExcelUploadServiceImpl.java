package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartExcelUploadDao;

@Service("buyerMpSoCartExcelUploadService")
public class BuyerMpSoCartExcelUploadServiceImpl implements BuyerMpSoCartExcelUploadService {
	
	@Autowired
	private BuyerMpSoCartExcelUploadDao buyerMpSoCartExcelUploadDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMpSoCartExcelUploadDao.selectList(param);
	}
	
	// 장바구니 담기
	@Transactional
	public String setCartAddReg(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoCartExcelUploadDao.setCartAddReg(formData, gridData);
	}
	
	//삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoCartExcelUploadDao.deleteSelectedData(formData, gridData);
	}
	
	// 업로드
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoCartExcelUploadDao.updateSelectedData(formData, gridData);
	}
}
