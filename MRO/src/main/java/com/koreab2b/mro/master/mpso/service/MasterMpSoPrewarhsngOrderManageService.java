package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPrewarhsngOrderManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 선입고 요청 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 요청 취소
	public String updatePrewarhsngReqCancel(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 관리 맵핑 등록(발주완료)
	public String updatePrewarhsngMappingReg(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 관리 맵핑 등록(부분발주완료)
	public String updatePrewarhsngMappingPartialReg(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 관리 맵핑 등록(부분발주완료)
	public String updatePrewarhsngMappingCancelReg(Map<String,String>  pMap);
	
	// 선입고 관리 맵핑 등록(부분발주완료)
	public String updatePrewarhsngMappingGrpCancelReg(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 관리 : 거래명세서
	public String updatesaveMasterMpSoPrewarhsngTranStatementReg(Map<String,String>  formData, List<Object> gridData);
	
	// 선입고 관리 : 납품실적
	public String updatesaveMasterMpSoPrewarhsngDeliveryEndReg(Map<String,String>  formData, List<Object> gridData);
	
}
