package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditDeptPopDao;

@Service("masterClMgCreditDeptPopService")
public class MasterClMgCreditDeptPopServiceImpl implements MasterClMgCreditDeptPopService {
	@Autowired
	private MasterClMgCreditDeptPopDao masterClMgCreditDeptPopDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditDeptPopDao.selectList(param);
	}
	// 생성
	@Transactional
	public String saveMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.saveMasterClMgCreditDeptPop(formData, gridData);
	}
	// 삭제
	@Transactional
	public String deleteMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.deleteMasterClMgCreditDeptPop(formData, gridData);
	}

	// 여신한도 매핑 리스트조회
	public List<Map<String,String>> getMasterClMgCreditBondPop(Map<String,Object> param) {
		return masterClMgCreditDeptPopDao.getMasterClMgCreditBondPop(param);
	}
	// 여신한도 매핑 생성
	@Transactional
	public String saveMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.saveMasterClMgCreditBondPop(formData, gridData);
	}
	// 여신한도 매핑 삭제
	@Transactional
	public String deleteMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.deleteMasterClMgCreditBondPop(formData, gridData);
	}

	// 여신한도 예외 리스트조회
	public List<Map<String,String>> getMasterClMgBondExcpPop(Map<String,Object> param) {
		return masterClMgCreditDeptPopDao.getMasterClMgBondExcpPop(param);
	}
	// 여신한도 예외 생성
	@Transactional
	public String saveMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.saveMasterClMgBondExcpPop(formData, gridData);
	}
	// 여신한도 예외 삭제
	@Transactional
	public String deleteMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgCreditDeptPopDao.deleteMasterClMgBondExcpPop(formData, gridData);
	}
}
