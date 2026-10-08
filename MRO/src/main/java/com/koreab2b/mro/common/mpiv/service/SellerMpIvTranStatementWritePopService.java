package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementWritePopService {
	
	// 기본정보조회
	public Map<String,String> getInfo(Map<String,String>  pMap);
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWritePop_v2(Map<String,Object>  pMap);

	// 구매사 차량정보 입력여부 조회 
	public String getSellerMpivBuyerCarInfo(Map<String,String>  pMap);
	
	// 거래명세서 작성 저장
	public Map<String, String> saveSellerMpIvTranStatementWritePop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWritePop_v3(Map<String, String> pMap);
	
	// 리스트조회_분할납품
	public List<Map<String,String>> getDoosanmecaList(Map<String,String>  pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDoosanmecaPop_v2(Map<String,Object>  pMap);
	

	// 거래명세서 작성 저장_Doosanmeca
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(Map<String, String> pMap);
	// 리스트조회_두산인프라용 팝업
	public List<Map<String,String>> getDiList(Map<String,String>  pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDiPop_v2(Map<String,Object>  pMap);
	
	// 리스트조회_두산인프라 팝업 PO LIST 조회
	public List<Map<String,String>> getLegacyPoList(Map<String,String>  pMap);
	
	// 거래명세서 저장시 두산 인터페이스
	public String saveKrdhimInvoice(Map<String,String>  pMap);
	
	// 물질정보제출 협력사 요청
	public Map<String, String> saveSellerMpIvTranStatementWriteChemicalInfo(Map<String, String> pMap);
	
	// 물류센터 고객사 체크
	public String getW001Flag(Map<String, String> pMap);
	
	
	// 거래명세서 작성 저장 - 품목별(다중)
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop_v3(Map<String, String> pMap);
	
	// 거래명세서 작성 - 일괄 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItemAll_v2(Map<String,String>  pMap);
	
	// 거래명세서 작성 저장 - 일괄
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop_v3(Map<String, String> pMap);
	
}
