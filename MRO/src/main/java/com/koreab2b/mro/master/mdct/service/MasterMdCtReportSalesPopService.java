package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtReportSalesPopService {
	// 고객사 기준 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 부서 기준 리스트조회
	public List<Map<String,String>> getDeptList(Map<String,Object>  param);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 거래현황 입력 리스트
	public List<Map<String,String>> getMasterMdCtReportSalesTotalList(Map<String,Object>  param);
	// 삭제
	public String deleteMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData);
	// 신규계약 품목 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewPop(Map<String,Object>  param);
	// 신규계약 품목 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewInputPop(Map<String,Object>  param);
	// 신규계약 품목 입력 등록
	public String saveMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData);
	// 신규계약 품목 입력 삭제
	public String deleteMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData);
	// sg 품목별  조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgPop(Map<String,Object>  param);
	// sg 품목별  입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgInputPop(Map<String,Object>  param);
	// sg 품목별  입력 등록
	public String saveMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData);
	// sg 품목별  입력 삭제
	public String deleteMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData);
	// 카테고리 품목별  조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaPop(Map<String,Object>  param);
	// 카테고리 품목별  입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaInputPop(Map<String,Object>  param);
	// 카테고리 품목별  입력 등록
	public String saveMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData);
	// 카테고리 품목별  입력 삭제
	public String deleteMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData);
	// 납기견적 관리 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeRePop(Map<String,Object>  param);
	// 납기견적 관리 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeReInputPop(Map<String,Object>  param);
	// 납기견적 관리 입력 등록
	public String saveMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData);
	// 납기견적 관리 입력 삭제
	public String deleteMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData);
	// 총평 조회
	public List<Map<String,String>> getMasterMdCtReportSalesEvaluationPop(Map<String,String>  formData);
	// 총평 등록
	public String saveMasterMdCtReportSalesEvaluationPop(Map<String,String>  pMap);
}
