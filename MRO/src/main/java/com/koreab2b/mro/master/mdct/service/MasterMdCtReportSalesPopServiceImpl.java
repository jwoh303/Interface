package com.koreab2b.mro.master.mdct.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtReportSalesPopDao;


@Service("masterMdCtReportSalesPopService")
public class MasterMdCtReportSalesPopServiceImpl implements MasterMdCtReportSalesPopService {
	
	@Autowired
	private MasterMdCtReportSalesPopDao masterMdCtReportSalesPopDao;

	// 고객사 기준 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.selectList(param);
	}
	// 부서 기준 리스트 조회
	public List<Map<String,String>> getDeptList(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.selectDeptList(param);
	}
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.updateSelectedData(formData, gridData);
	}
	// 거래현황 입력 리스트
	public List<Map<String,String>> getMasterMdCtReportSalesTotalList(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesTotalList(param);
	}	
	// 저장
	@Transactional
	public String deleteMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.deleteMasterMdCtReportCustomerList(formData, gridData);
	}
	// 신규계약 품목 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesNewPop(param);
	}
	// 신규계약 품목 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewInputPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesNewInputPop(param);
	}
	// 신규계약 품목 입력 저장
	@Transactional
	public String saveMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.saveMasterMdCtReportSalesNewPop(formData, gridData);
	}
	// 신규계약 품목 입력 삭제
	@Transactional
	public String deleteMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.deleteMasterMdCtReportSalesNewPop(formData, gridData);
	}
	// sg 품목별 조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesSgPop(param);
	}
	// sg 품목별 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgInputPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesSgInputPop(param);
	}
	// sg 품목별 입력 저장
	@Transactional
	public String saveMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.saveMasterMdCtReportSalesSgPop(formData, gridData);
	}
	// sg 품목별 입력 삭제
	@Transactional
	public String deleteMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.deleteMasterMdCtReportSalesSgPop(formData, gridData);
	}
	// 카테고리 품목별 조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesCaPop(param);
	}
	// 카테고리 품목별 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaInputPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesCaInputPop(param);
	}
	// 카테고리 품목별 입력 저장
	@Transactional
	public String saveMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.saveMasterMdCtReportSalesCaPop(formData, gridData);
	}
	// 카테고리 품목별 입력 삭제
	@Transactional
	public String deleteMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.deleteMasterMdCtReportSalesCaPop(formData, gridData);
	}
	// 납기견적 관리 품목별 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeRePop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesDeRePop(param);
	}
	// 납기견적 관리 입력 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeReInputPop(Map<String,Object> param) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesDeReInputPop(param);
	}
	// 납기견적 관리 입력 저장
	@Transactional
	public String saveMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.saveMasterMdCtReportSalesDeRePop(formData, gridData);
	}
	// 납기견적 관리 입력 삭제
	@Transactional
	public String deleteMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportSalesPopDao.deleteMasterMdCtReportSalesDeRePop(formData, gridData);
	}
	// 총평 조회
	public List<Map<String,String>> getMasterMdCtReportSalesEvaluationPop(Map<String,String> formData) {
		return masterMdCtReportSalesPopDao.getMasterMdCtReportSalesEvaluationPop(formData);
	}
	//총평 등록
	public String saveMasterMdCtReportSalesEvaluationPop(Map<String,String>  pMap){
		return masterMdCtReportSalesPopDao.saveMasterMdCtReportSalesEvaluationPop(pMap);
	}	
}
