package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementWritePopDao {
	
	// 기본정보 조회
	public List<Map<String,String>> selectInfo(Map<String,String> pMap);
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWritePop_v2(Map<String,Object> pMap);
	
	// 구매사 차량정보 입력여부 조회
	public String getSellerMpivBuyerCarInfo(Map<String,String> pMap);
	
	// 거래명세서 작성 저장
	public Map<String, String> saveSellerMpIvTranStatementWritePop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWritePop_v3(Map<String, String> pMap);
	
	// doc_type별 번호생성
	public String getOrderNo(Map<String, String> pMap);
	
	// 리스트 조회_분할납품
	public List<Map<String,String>> selectDoosanmecaList(Map<String,String> pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDoosanmecaPop_v2(Map<String,Object> pMap);
	
	// 거래명세서 작성 저장_Doosanmeca
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(Map<String, String> pMap);
	// 리스트조회_두산인프라용 팝업
	public List<Map<String,String>> selectDiList(Map<String,String> pMap);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDiPop_v2(Map<String,Object> pMap);
	
	// 리스트조회_두산인프라 팝업 PO LIST 조회
	public List<Map<String,String>> selectLegacyPoList(Map<String,String> pMap);
	
	
	public Map<String,String> getInvHdList(Map<String,String> pMap);
	
	public List<Map<String,String>> getInvDtList(Map<String,String> pMap);
	
	public String updateIvdt(Map<String,String> pMap);
	
	// 물질정보제출 협력사 요청
	public Map<String, String> saveSellerMpIvTranStatementWriteChemicalInfo(Map<String, String> pMap);
	
	// 물류센터 고객사 체크
	public String getW001Flag(Map<String, String> pMap);
	
	// 거래명세서 작성 저장-품목별(다중)
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop_v3(Map<String, String> pMap);
	
	//거래명세서 작성 조회 - 일괄
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItemAll_v2(Map<String,String> pMap);
	
	// 거래명세서 작성 저장-일괄
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop(Map<String, String> pMap);
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop_v3(Map<String, String> pMap);
}
