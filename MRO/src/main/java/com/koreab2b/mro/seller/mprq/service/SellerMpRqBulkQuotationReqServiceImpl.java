package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqBulkQuotationReqDao;

@Service("sellerMpRqBulkQuotationReqService")
public class SellerMpRqBulkQuotationReqServiceImpl implements SellerMpRqBulkQuotationReqService {

	@Autowired
	private SellerMpRqBulkQuotationReqDao sellerMpRqBulklQuotationReqDao;

	//프로젝트 조회
	@Override
	public List<Map<String, String>> getProejctList(Map<String, String> formData) {
		return sellerMpRqBulklQuotationReqDao.selectProjectList(formData);
	}
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData){
		return sellerMpRqBulklQuotationReqDao.selectList(formData);
	}
 
	// 프로젝트 유의사항 조회
	@Override
	public List<Map<String, String>> getProjectRemark(Map<String, String> formData) {
		return sellerMpRqBulklQuotationReqDao.selectPrjRemarkList(formData);
	}
	
	// 견적 포기
	@Override
	public String giveupSellerMpRqBulklQuotationReq(Map<String, String> formData) {
		return sellerMpRqBulklQuotationReqDao.updateGiveupData(formData);
	}

	// 견적제출
	@Override
	public String updateSellerMpRqBulkQuotationReq(Map<String, String> formData, List<Object> gridData) {
		return sellerMpRqBulklQuotationReqDao.saveData(formData, gridData);
	}

	// 임시저장
	@Override
	public String updateSellerMpRqBulkQuotationReqTemp(Map<String, String> formData,List<Object> gridData) {
		return sellerMpRqBulklQuotationReqDao.updateTempData(formData, gridData);
	}

	// 견적제출취소
	@Override
	public String updateSellerMpRqBulkQuotationReqCancelSubmit(Map<String, String> formData) {
		return sellerMpRqBulklQuotationReqDao.updateCancelSubmit(formData);
	}
	
	//(재계약) 동일단가 적용
	@Override
	public String updateSellerMpRqBulkQuotationReqSamePrice(Map<String, String> formData, List<Object> gridData) {
		return sellerMpRqBulklQuotationReqDao.updateSamePrice(formData, gridData);
	}

	// 물류 수수료율
	@Override
	public String getLogisFee(Map<String, String> formData) {
		return sellerMpRqBulklQuotationReqDao.selectLogisFee(formData);
	}

}
