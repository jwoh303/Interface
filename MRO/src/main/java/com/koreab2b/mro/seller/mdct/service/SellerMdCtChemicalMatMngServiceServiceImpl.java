package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtChemicalMatMngDao;

@Service("sellerMdCtChemicalMatMngService")
public class SellerMdCtChemicalMatMngServiceServiceImpl implements SellerMdCtChemicalMatMngService {
	
	@Autowired
	private SellerMdCtChemicalMatMngDao sellerMdCtChemicalMatMngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMdCtChemicalMatMngDao.selectList(param);
	}

	// 리뉴얼 탭1 - MSDS 전체 조회
	public List<Map<String,String>> getMSDSList(Map<String,Object> param) {
		// 파라미터 전처리 - null이나 빈 값을 기본값으로 설정
		if (param.get("dateType") == null || "".equals(param.get("dateType"))) {
			param.put("dateType", "R");
		}
		if (param.get("fromDate") == null || "".equals(param.get("fromDate"))) {
			param.put("fromDate", "");
		}
		if (param.get("toDate") == null || "".equals(param.get("toDate"))) {
			param.put("toDate", "");
		}
		if (param.get("searchType") == null || "".equals(param.get("searchType"))) {
			param.put("searchType", "N");
		}
		if (param.get("searchKeyword") == null) {
			param.put("searchKeyword", "");
		}
		if (param.get("status") == null) {
			param.put("status", "");
		}
		if (param.get("requestNo") == null) {
			param.put("requestNo", "");
		}
		if (param.get("sessionComCode") == null) {
			param.put("sessionComCode", "");
		}
		if (param.get("sessionUserId") == null) {
			param.put("sessionUserId", "");
		}

		return sellerMdCtChemicalMatMngDao.selectMSDSList(param);
	}

	// 리뉴얼 탭2 - MSDS 제출요청 조회
	public List<Map<String,String>> getMSDSSubmitRequestList(Map<String,Object> param) {
		// 파라미터 전처리 - Tab2는 요청/재요청 상태로 고정
		if (param.get("dateType") == null || "".equals(param.get("dateType"))) {
			param.put("dateType", "R");
		}
		if (param.get("fromDate") == null || "".equals(param.get("fromDate"))) {
			param.put("fromDate", "");
		}
		if (param.get("toDate") == null || "".equals(param.get("toDate"))) {
			param.put("toDate", "");
		}
		if (param.get("searchType") == null || "".equals(param.get("searchType"))) {
			param.put("searchType", "N");
		}
		if (param.get("searchKeyword") == null) {
			param.put("searchKeyword", "");
		}
		// Tab2 상태값 처리 (기본값: Q,R)
		if (param.get("status") == null || "".equals(param.get("status"))) {
			param.put("status", "Q,R");
		}
		if (param.get("requestNo") == null) {
			param.put("requestNo", "");
		}
		if (param.get("sessionComCode") == null) {
			param.put("sessionComCode", "");
		}
		if (param.get("sessionUserId") == null) {
			param.put("sessionUserId", "");
		}

		return sellerMdCtChemicalMatMngDao.selectMSDSSubmitRequestList(param);
	}

}
