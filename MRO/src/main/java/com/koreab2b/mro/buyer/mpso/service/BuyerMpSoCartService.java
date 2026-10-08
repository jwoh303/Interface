package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartService {
	/**
	 * 조회
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getShoppintCartSelectSql(Map<String, String> formData);
	public List<Map<String, String>> getShoppintCartSelectSql_v2(Map<String, String> formData);

	public List<Map<String, String>> getBuyerShoppingCartOrderListConfirm(Map<String, String> formData);

	/**
	 * 홍익대학교-- 대학원 소속 체크.
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getHongIkType(Map<String, String> formData);

	/**
	 * 홍익대학교-- 품의서 양식 확인.
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getHongIkSheetType(Map<String, String> formData);

	/**
	 * 바로주문
	 * 
	 * @param formData
	 * @return
	 */
	public String saveBuyerYuhanCartUpdate(Map<String, String> formData);

	/**
	 * 저장
	 * 
	 * @param formData
	 * @return
	 */
	public String saveBuyerShoppingcartQtyUpdate(Map<String, String> formData);
	/**
	 * 저장
	 * 
	 * @param formData
	 * @return
	 */
	public String saveBuyerShoppingcartQtyCowayUpdate(Map<String, String> formData);
	/**
	 * 삭제
	 * 
	 * @param formData
	 * @return
	 */
	public String removeBuyerShoppingcartMycartDelReg(Map<String, String> formData);
	
	/**
	 * 삭제
	 * 
	 * @param formData
	 * @return
	 */
	public String removeBuyerShoppingcartMycartClcsDelReg(Map<String, String> formData);
	/**
	 * 장바구니 저장
	 * 
	 * @param formData
	 * @return
	 */
	public String saveBuyerShoppingcartSizeQtyUpdate(Map<String, String> formData);
	public String saveBuyerShoppingcartSizeQtyUpdate_v2(Map<String, String> formData);
	/**
	 * 인터페이스 전송
	 * 
	 * @param formData
	 * @return
	 */
	public String transferBuyerShoppingcartUpdate(Map<String, String> formData);
	/**
	 * 펀치아웃 xml
	 * 
	 * @param formData
	 * @return Map<String,String>
	 */
	public Map<String,String> getPunchoutOrderMessage(Map<String, String> formData);
	/**
	 * 펀치아웃 xml test
	 * 
	 * @param formData
	 * @return Map<String,String>
	 */
	public Map<String,String> getPunchoutOrderMessageTEST(Map<String, String> formData);
	/**
	 * 카트삭제
	 * 
	 * @param formData
	 * @return
	 */
	public String deletePunchoutOrderMessageShoppingcart(Map<String, String> formData);
	/**
	 * 펀치아웃url가져오기
	 * 
	 * @param formData
	 * @return
	 */
	public String getPunchoutURL(Map<String, String> formData);
	
	/**
	 * 펀치아웃 유큐브
	 * @param formData
	 * @return
	 */
	public String setPunchoutUcube(Map<String, String> formData);
	
	/** 셰플러코리아 펀치아웃 xml
	 * 
	 * @param formData
	 * @return Map<String,String>
	 */	
	public Map<String, String> getPunchoutOrderMessageFagb(Map<String, String> pMap);
	
	/** 필립모리스 펀치아웃 xml
	 * 
	 * @param formData
	 * @return Map<String,String>
	 */
	public Map<String, String> getPunchoutOrderMessagePMK(Map<String, String> pMap);
	
	/** 유한킴벌리 펀치아웃 xml
	 * 
	 * @param formData
	 * @return Map<String,String>
	 */
	public Map<String, String> getPunchoutOrderMessageYHKB(Map<String, String> pMap);
	
	// 넥센타이어 고정자산번호(관리번호)
	public List<Map<String, String>> getNexeAccountList(Map<String, String> pMap);

}
