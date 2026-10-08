package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.SellerMpClDlvryCarPopDao;

@Service("sellerMpClDlvryCarPopServiceImpl")
public class SellerMpClDlvryCarPopServiceImpl implements SellerMpClDlvryCarPopService {
	
	@Autowired
	private SellerMpClDlvryCarPopDao sellerMpClDlvryCarPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return sellerMpClDlvryCarPopDao.selectList(formData);
	}	

	// 저장
	public String insertSelectedData(Map<String,String> formData) {
		return sellerMpClDlvryCarPopDao.insertSelectedData(formData);
	}	
	
	// 수정
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMpClDlvryCarPopDao.updateSelectedData(formData);
	}	
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {
		return sellerMpClDlvryCarPopDao.deleteSelectedData(formData);
	}	

}
