package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartDao;
import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoExternalDao;

@Service("buyerMpSoCartService")
public class BuyerMpSoCartServiceImpl implements BuyerMpSoCartService {
	
	@Autowired
	private BuyerMpSoCartDao buyerMpSoCartDao;
	@Autowired
	private BuyerMpSoExternalDao buyerMpSoExternalDao;
	
	// 조회
	public List<Map<String,String>> getShoppintCartSelectSql(Map<String,String>  formData){
		return buyerMpSoCartDao.getShoppintCartSelectSql(formData);
	}	
	public List<Map<String,String>> getShoppintCartSelectSql_v2(Map<String,String>  formData){
		return buyerMpSoCartDao.getShoppintCartSelectSql_v2(formData);
	}
	public List<Map<String,String>> getBuyerShoppingCartOrderListConfirm(Map<String,String>  formData){
		return buyerMpSoCartDao.getBuyerShoppingCartOrderListConfirm(formData);
	}	
	public List<Map<String,String>> getHongIkType(Map<String,String>  formData){
		return buyerMpSoCartDao.getHongIkType(formData);
	}	 
	public List<Map<String,String>> getHongIkSheetType(Map<String,String>  formData) {
		return buyerMpSoCartDao.getHongIkSheetType(formData);
	}	 
	
	// 바로주문
	public String saveBuyerYuhanCartUpdate(Map<String,String>  formData){
		return buyerMpSoCartDao.saveBuyerYuhanCartUpdate(formData);
	}	 
	// 저장
	public String saveBuyerShoppingcartQtyUpdate(Map<String,String>  formData){
		return buyerMpSoCartDao.saveBuyerShoppingcartQtyUpdate(formData);
	}	 
	// 저장
	public String saveBuyerShoppingcartQtyCowayUpdate(Map<String,String>  formData){
		return buyerMpSoCartDao.saveBuyerShoppingcartQtyCowayUpdate(formData);
	}	 
	// 삭제
	public String removeBuyerShoppingcartMycartDelReg(Map<String,String>  formData){
		return buyerMpSoCartDao.removeBuyerShoppingcartMycartDelReg(formData);
	}	 
	// 삭제
	public String removeBuyerShoppingcartMycartClcsDelReg(Map<String,String>  formData){
		return buyerMpSoCartDao.removeBuyerShoppingcartMycartClcsDelReg(formData);
	}	 
	// 장바구니 길이 저장
	public String saveBuyerShoppingcartSizeQtyUpdate(Map<String,String>  formData){
		return buyerMpSoCartDao.saveBuyerShoppingcartSizeQtyUpdate(formData);
	}
	public String saveBuyerShoppingcartSizeQtyUpdate_v2(Map<String,String>  formData){
		return buyerMpSoCartDao.saveBuyerShoppingcartSizeQtyUpdate_v2(formData);
	}
	
	// 인터페이스 전송
	public String transferBuyerShoppingcartUpdate(Map<String,String>  formData){
		return buyerMpSoCartDao.transferBuyerShoppingcartUpdate(formData);
	}	 	
	public Map<String,String> getPunchoutOrderMessage(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutOrderMessage(formData);
	}
	public Map<String,String> getPunchoutOrderMessageFagb(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutOrderMessageFagb(formData);
	}
	public Map<String,String> getPunchoutOrderMessageTEST(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutOrderMessageTEST(formData);
	}
	public String deletePunchoutOrderMessageShoppingcart(Map<String, String> formData) {
		return buyerMpSoCartDao.removePunchoutOrderMessageShoppingcart(formData);
	}
	public String getPunchoutURL(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutURL(formData);
	}
	@Override
	public String setPunchoutUcube(Map<String, String> formData) {
		return buyerMpSoExternalDao.setPunchoutUcube(formData);
	}
	@Override
	public Map<String, String> getPunchoutOrderMessagePMK(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutOrderMessagePMK(formData);
	}
	@Override
	public Map<String, String> getPunchoutOrderMessageYHKB(Map<String, String> formData) {
		return buyerMpSoCartDao.getPunchoutOrderMessageYHKB(formData);
	}
	@Override
	public List<Map<String, String>> getNexeAccountList(Map<String, String> formData) {
		return buyerMpSoCartDao.getNexeAccountList(formData);		 
	}
	
}
