package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtBuyerJoinAlterRequestApprovalPopDao;

@Service("masterMdCtBuyerJoinAlterRequestApprovalPopService")
public class MasterMdCtBuyerJoinAlterRequestApprovalPopServiceImpl implements MasterMdCtBuyerJoinAlterRequestApprovalPopService {
	
	@Autowired
	private MasterMdCtBuyerJoinAlterRequestApprovalPopDao masterMdCtBuyerJoinAlterRequestApprovalPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.selectList(formData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getChargeEntryList(Map<String,Object> param) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.selectChargeEntryList(param);
	}
		
	// 정보 수정
	public String updateSelectedData (Map<String,String> formData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.updateSelectedData(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.selectPwdValidCheck(formData);
	}
	
	// KeP담당자 저장
	@Transactional
	public String updateChargeEntryData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.updateChargeEntryData(formData, gridData);
	}
	
	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.deleteSelectedData(formData, gridData);
	}
	
	// sg별 매익율 리스트조회
	public List<Map<String,String>> getSgMarginList(Map<String,Object> param) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.selectSgMarginList(param);
	}
	
	// sg별 매익율 저장
	public String updateSgMargin(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerJoinAlterRequestApprovalPopDao.updateSgMargin(formData, gridData);
	}

}
