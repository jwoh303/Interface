package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mppo.dao.BuyerMpPoOrderReqReceiptDao;
import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Service("buyerMpPoOrderReqReceiptService")
public class BuyerMpPoOrderReqReceiptServiceImpl implements BuyerMpPoOrderReqReceiptService {
	
	@Autowired
	private BuyerMpPoOrderReqReceiptDao buyerMpPoOrderReqReceiptDao;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoOrderReqReceiptDao.selectList(formData);
	}	
	
	// 저장
	public String savePrRecvReturnReasonReg(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.savePrRecvReturnReasonReg(formData);
	}	
	// 부서이관
	public String saveDeptTramsfer(Map<String,String>  formData){
		return buyerMpPoOrderReqReceiptDao.saveDeptTramsfer(formData);
	}	
	
	public String saveSerPrReturn(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.saveSerPrReturn(formData);
	}

	public String saveSerPrDetailReturn(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.saveSerPrDetailReturn(formData);
	}	
	public String saveSetSavePR(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.saveSetSavePR(formData);
	}	
	
	// 구매발주
	public String saveInsertMergePxPo(Map<String,String>  formData) {
		return buyerMpSoOrderInfoDao.insertMergePxPo( formData);
	}
	// 고객사별구매발주
	public String saveInsertMergePxPoDetail(Map<String,String>  formData) {
		return buyerMpSoOrderInfoDao.insertMergePxPoDetail( formData);
	}	
	// 구매발주 발주보류(임시저장)
	public String saveChangeMergePxPo(Map<String,String>  formData){ 
		return buyerMpSoOrderInfoDao.changeMergePxPo( formData);
	}	
	
	
	public List<Map<String,String>> getBuyerAdminBdgtTempQtyCheck(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.getBuyerAdminBdgtTempQtyCheck(formData);
	}		
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderCheck(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.getBuyerAdminBdgtTempOrderCheck(formData);
	}	
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderDetailCheck(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.getBuyerAdminBdgtTempOrderDetailCheck(formData);
	}	
	// 홍대용 조회
	public List<Map<String,String>> getBuyerMpPoHongikOrderReqReceiptList(Map<String,String>  formData)  {
		return buyerMpPoOrderReqReceiptDao.selectHongikList(formData);
	}
	//PR기준 구매요청접수 조회
	public List<Map<String,String>> getBuyerMpPoOrdePrReqReceiptList(Map<String,String>  formData)  {
		return buyerMpPoOrderReqReceiptDao.selectMpPoOrdePrReqReceiptList(formData);
	}	
	//관리번호 저장
	public String saveRefPrNo(Map<String,String>  formData) {
		return buyerMpPoOrderReqReceiptDao.saveRefPrNo(formData);
	}
}
