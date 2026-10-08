package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoUniformReqDao;

@Service("buyerMpSoUniformReqService")
public class BuyerMpSoUniformReqServiceImpl implements BuyerMpSoUniformReqService {
	
	@Autowired
	private BuyerMpSoUniformReqDao buyerMpSoUniformReqDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return buyerMpSoUniformReqDao.selectList(param);
	}	
	
	// 파일업로드
	@Transactional
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoUniformReqDao.uploadSelectedData(formData, gridData);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoUniformReqDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoUniformReqDao.deleteSelectedData(formData, gridData);
	}
	
	// 등록
	@Transactional
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMpSoUniformReqDao.regSelectedData(formData, gridData);
	}
}
