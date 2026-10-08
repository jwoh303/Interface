package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvObtnodrReceiptDetailPopDao;

@Service("sellerMpIvObtnodrReceiptDetailPopService")
public class SellerMpIvObtnodrReceiptDetailPopServiceImpl implements SellerMpIvObtnodrReceiptDetailPopService {
	
	@Autowired
	private SellerMpIvObtnodrReceiptDetailPopDao sellerMpIvObtnodrReceiptDetailPopDao;

	// 수주접수 상세정보 조회
	public List<Map<String, String>> getDetailInfo(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDetailPopDao.getDetailInfo(formData);
	}	
	
	// 수주접수 상세 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDetailPopDao.getDetailList(formData);
	}
	
	// 수주접수 상세 리스트 조회
	public List<Map<String,String>> getDetailList_v2(Map<String,Object> formData) {
		return sellerMpIvObtnodrReceiptDetailPopDao.getDetailList_v2(formData);
	}

	// 발주서인쇄정보 조회
	public List<Map<String, String>> getOrderRecvHeader(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDetailPopDao.getOrderRecvHeader(formData);
	}	
	
	// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회 
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDetailPopDao.getSpecialLogicInfo(formData);
	}
	
	//수주접수 저장
	public String saveSellerMpIvObtnodrReceiptDetailPop(Map<String, String> pMap, List<Object> pList){
		return sellerMpIvObtnodrReceiptDetailPopDao.saveSellerMpIvObtnodrReceiptDetailPop(pMap, pList);
	}
	
	//물질정보등록
	public String saveSellerMpIvChemicalInfo(Map<String, String> pMap, List<Object> pList){
		return sellerMpIvObtnodrReceiptDetailPopDao.saveSellerMpIvChemicalInfo(pMap,pList);
	}

	//수주거부
	public String saveSellerMpIvObtnodrReceiptDetailRejectPop(Map<String, String> pMap, List<Object> pList){
		return sellerMpIvObtnodrReceiptDetailPopDao.saveSellerMpIvObtnodrReceiptDetailRejectPop(pMap, pList);
	}
}
