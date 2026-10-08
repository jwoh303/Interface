package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.BuyerMpRqExcelUploadPopDao;

@Service("buyerMpRqExcelUploadPopService")
public class BuyerMpRqExcelUploadPopServiceImpl implements BuyerMpRqExcelUploadPopService {
	
	@Autowired
	private BuyerMpRqExcelUploadPopDao buyerMpRqExcelUploadPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqExcelUploadPopDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,String> formData) {
		return buyerMpRqExcelUploadPopDao.selectList_v2(formData);
	}		
	// 저장
	public String setExcelUp(Map<String,String>  formData) {
		return buyerMpRqExcelUploadPopDao.saveExcelUp(formData);
	}
	public String setExcelUp_v2(Map<String,String>  formData) {
		return buyerMpRqExcelUploadPopDao.saveExcelUp_v2(formData);
	}
}
