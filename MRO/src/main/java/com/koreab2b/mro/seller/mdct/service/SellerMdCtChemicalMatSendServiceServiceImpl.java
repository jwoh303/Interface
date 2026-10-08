package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtChemicalMatSendDao;

@Service("sellerMdCtChemicalMatSendService")
public class SellerMdCtChemicalMatSendServiceServiceImpl implements SellerMdCtChemicalMatSendService {
	
	@Autowired
	private SellerMdCtChemicalMatSendDao sellerMdCtChemicalMatSendDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMdCtChemicalMatSendDao.selectList(param);
	}
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.updateSelectedData(formData, gridData);
	}
	// 저장 V2
	@Transactional
	public String updateSelectedDataV2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.updateSelectedDataV2(formData, gridData);
	}
	// 물질정보 상세 팝업 조성정보 조회
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPop(Map<String,Object> param) {
		return sellerMdCtChemicalMatSendDao.getSellerMdCtChemicalMatRegPop(param);
	}
	//물질정보 상세 팝업 조성정보 헤드 조회	
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPopHd(Map<String,String> formData) {
		return sellerMdCtChemicalMatSendDao.getSellerMdCtChemicalMatRegPopHd(formData);
	}
	// 물질정보 오분류
	@Transactional
	public String returnSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.returnSellerMdCtChemicalMatSendList(formData, gridData);
	}
	// 물질정보 오분류 V2
	@Transactional
	public String returnSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.returnSellerMdCtChemicalMatSendListV2(formData, gridData);
	}
	// 발주 후 제출(협력사)
	@Transactional
	public String afterSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.afterSellerMdCtChemicalMatSendList(formData, gridData);
	}
	// 발주 후 제출(협력사) V2
	@Transactional
	public String afterSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData) {
		return sellerMdCtChemicalMatSendDao.afterSellerMdCtChemicalMatSendListV2(formData, gridData);
	}
}
