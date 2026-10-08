package com.koreab2b.mro.common.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdam.dao.BuyerMdAmPrivateInfoAlterPopDao;

@Service("buyerMdAmPrivateInfoAlterPopService")
public class BuyerMdAmPrivateInfoAlterPopServiceImpl implements BuyerMdAmPrivateInfoAlterPopService {
	
	@Autowired
	private BuyerMdAmPrivateInfoAlterPopDao buyerMdAmPrivateInfoAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.selectList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getApprovedList(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.selectApprovedList(formData);
	}
		
	// 조회
	public List<Map<String,String>> getReferList(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.selectReferList(formData);
	}

	// 조회 - 기본 결재경로의 결재/참조/합의 멤버 통합 (GUBUN IN ('C','R','H'))
	public List<Map<String,String>> getDefaultApprovalLineMembers(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.selectDefaultApprovalLineMembers(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.selectPwdValidCheck(formData);
	}
		
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return buyerMdAmPrivateInfoAlterPopDao.updateSelectedData(formData);
	}
}
