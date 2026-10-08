package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrWarehousingLisDao;

@Service("buyerWmGrWarehousingLisService")
public class BuyerWmGrWarehousingLisServiceImpl implements BuyerWmGrWarehousingLisService {
	
	@Autowired
	private BuyerWmGrWarehousingLisDao buyerWmGrWarehousingLisDao;

	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData){
		return buyerWmGrWarehousingLisDao.getBuyerWmGrWarehousingLisInit(formData);
	}

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerWmGrWarehousingLisDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v2(Map<String,Object> formData) {
		return buyerWmGrWarehousingLisDao.getBuyerWmGrWarehousingLisList_v2(formData);
	}	
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v3(Map<String,Object> formData) {
		return buyerWmGrWarehousingLisDao.getBuyerWmGrWarehousingLisList_v3(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String, String> formData) {
		return buyerWmGrWarehousingLisDao.updateSelectedData(formData);
	}
	public String updateSelectedData_v3(Map<String, String> formData) {
		return buyerWmGrWarehousingLisDao.updateSelectedData_v3(formData);
	}
	
	// 마감 EXCEL 다운로드
	public List<Map<String,String>> getCloseExcelList(Map<String,String> formData) {
		return buyerWmGrWarehousingLisDao.selectCloseExcelList(formData);
	}
	
	// 관리번호별 집계 팝업
	public List<Map<String,String>> getRefTotalList(Map<String,String> formData) {
		return buyerWmGrWarehousingLisDao.selectRefTotalList(formData);
	}

	// 한컴라이프 ERP 양식 다운로드
	public List<Map<String, String>> getHLCList(Map<String, String> formData) {
		return buyerWmGrWarehousingLisDao.selectHLCERPList(formData);
	}	
}
