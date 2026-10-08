package com.koreab2b.mro.common.mpcl.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpcl.dao.SellerMpClPositionCodePopDao;

@Service("sellerMpClPositionCodePopServiceImpl")
public class SellerMpClPositionCodePopServiceImpl implements SellerMpClPositionCodePopService {
	
	@Autowired
	private SellerMpClPositionCodePopDao sellerMpClPositionCodePopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return sellerMpClPositionCodePopDao.selectList(formData);
	}	

	// 저장
	public String insertSelectedData(Map<String,String> formData) {
		return sellerMpClPositionCodePopDao.insertSelectedData(formData);
	}	
	
	// 수정
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMpClPositionCodePopDao.updateSelectedData(formData);
	}	
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {
		return sellerMpClPositionCodePopDao.deleteSelectedData(formData);
	}	

}
