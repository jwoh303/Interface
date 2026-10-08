package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliveryRecordRegDao;

@Service("sellerMpIvDeliveryRecordRegService")
public class SellerMpIvDeliveryRecordRegServiceImpl implements SellerMpIvDeliveryRecordRegService {
	
	@Autowired
	private SellerMpIvDeliveryRecordRegDao sellerMpIvDeliveryRecordRegDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.selectList(pMap);
	}	
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegList_v2(Map<String,Object> pMap) {
		return sellerMpIvDeliveryRecordRegDao.getSellerMpIvDeliveryRecordRegList_v2(pMap);
	}	
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegList_v3(Map<String,Object> pMap) {
		return sellerMpIvDeliveryRecordRegDao.getSellerMpIvDeliveryRecordRegList_v3(pMap);
	}	
	
	
	// 저장
	public String updateSellerMpIvDeliveryRecordReg(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.updateSellerMpIvDeliveryRecordReg(pMap);
	}	
	public String updateSellerMpIvDeliveryRecordReg_v2(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.updateSellerMpIvDeliveryRecordReg_v2(pMap);
	}
	public String updateSellerMpIvDeliveryRecordReg_v3(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.updateSellerMpIvDeliveryRecordReg_v3(pMap);
	}
	
	//거래명세서 취소
	public String delSellerMpIvDeliveryRecordInvoiceList_v2(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.delSellerMpIvDeliveryRecordInvoiceList_v2(pMap);
	}
	
	
	// 택배사정보저장
	public String updateSellerMpIvDeliveryRecordParcelReg(Map<String,String>  pMap){
		return sellerMpIvDeliveryRecordRegDao.updateSellerMpIvDeliveryRecordParcelReg(pMap);
	}
	//납품완료 조회
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegEndList_v2(Map<String,Object> pMap) {
		return sellerMpIvDeliveryRecordRegDao.getSellerMpIvDeliveryRecordRegEndList_v2(pMap);
	}	
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegEndList_v3(Map<String,Object> pMap) {
		return sellerMpIvDeliveryRecordRegDao.getSellerMpIvDeliveryRecordRegEndList_v3(pMap);
	}	
	
	//납품실적 삭제
	public String updateSellerMpIvDeliveryRecordDeleteList_v2(Map<String,String> pMap) {
		return sellerMpIvDeliveryRecordRegDao.updateSellerMpIvDeliveryRecordDeleteList_v2(pMap);
	}
	

}
