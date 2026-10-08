package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartDao {

	// 조회
	public List<Map<String,String>> getShoppintCartSelectSql(Map<String,String>  formData);
	public List<Map<String,String>> getShoppintCartSelectSql_v2(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerShoppingCartOrderListConfirm(Map<String,String>  formData);
	public List<Map<String,String>> getHongIkType(Map<String,String>  formData); 
	public List<Map<String,String>> getHongIkSheetType(Map<String,String>  formData); 
	
	// 바로주문
	public String saveBuyerYuhanCartUpdate(Map<String,String>  formData);
	// 저장
	public String saveBuyerShoppingcartQtyUpdate(Map<String,String>  formData);
	// 저장
	public String saveBuyerShoppingcartQtyCowayUpdate(Map<String,String>  formData);
	// 삭제
	public String removeBuyerShoppingcartMycartDelReg(Map<String,String>  formData); 
	// 삭제
	public String removeBuyerShoppingcartMycartClcsDelReg(Map<String,String>  formData);
	// 저장
	public String saveBuyerShoppingcartSizeQtyUpdate(Map<String,String>  formData);
	public String saveBuyerShoppingcartSizeQtyUpdate_v2(Map<String,String>  formData);
	// 인터페이스 전송
	public String transferBuyerShoppingcartUpdate(Map<String,String>  formData);
	// 펀치아웃 데이터 조회
	public Map<String,String> getPunchoutOrderMessage(Map<String,String>  formData);
	// 펀치아웃 데이터 조회 TEST
	public Map<String,String> getPunchoutOrderMessageTEST(Map<String,String>  formData);
	// 펀치아웃 데이터 조회
	public String removePunchoutOrderMessageShoppingcart(Map<String,String>  formData);
	// 펀치아웃 URL 조회
	public String getPunchoutURL(Map<String,String> formData);
	// 셰플러 펀치아웃 조회
	public Map<String, String> getPunchoutOrderMessageFagb(Map<String, String> formData);
	// 필립모리스 펀치아웃 조회
	public Map<String, String> getPunchoutOrderMessagePMK(Map<String, String> formData);
	// 유한킴벌리 펀치아웃 조회
	public Map<String, String> getPunchoutOrderMessageYHKB(Map<String, String> formData);
	// 넥센타이어 고정자산 번호 조회
	public List<Map<String, String>> getNexeAccountList(Map<String, String> formData);
		
	
}
