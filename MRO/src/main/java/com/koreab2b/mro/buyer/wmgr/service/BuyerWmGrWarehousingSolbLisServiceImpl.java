package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrWarehousingSolbLisDao;

@Service("buyerWmGrWarehousingSolbLisService")
public class BuyerWmGrWarehousingSolbLisServiceImpl implements BuyerWmGrWarehousingSolbLisService {
	
	@Autowired
	private BuyerWmGrWarehousingSolbLisDao buyerWmGrWarehousingSolbLisDao;

	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData){
		return buyerWmGrWarehousingSolbLisDao.getBuyerWmGrWarehousingLisInit(formData);
	}

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerWmGrWarehousingSolbLisDao.selectList(formData);
	}	
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v2(Map<String,Object> formData) {
		return buyerWmGrWarehousingSolbLisDao.getBuyerWmGrWarehousingSolbLisList_v2(formData);
	}	
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v3(Map<String,Object> formData) {
		return buyerWmGrWarehousingSolbLisDao.getBuyerWmGrWarehousingSolbLisList_v3(formData);
	}
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.updateSelectedData(formData);
	}
	public String updateSelectedData_v3(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.updateSelectedData_v3(formData);
	}

	// 관리번호 변경 저장
	public String updateSolbRefNo(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.updateSolbRefNo(formData);
	}

	// 입고 확정 및 취소
	public String updateSolbGrConfirm(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.updateSolbGrConfirm(formData);
	}

	// 회계 확정 및 취소
	public String updateSolbDlConfirm(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.updateSolbDlConfirm(formData);
	}

	// erp다운로드
	public List<Map<String, String>> getErpList(Map<String, String> formData) {
		return buyerWmGrWarehousingSolbLisDao.selectErpList(formData);
	}

	
	
}
