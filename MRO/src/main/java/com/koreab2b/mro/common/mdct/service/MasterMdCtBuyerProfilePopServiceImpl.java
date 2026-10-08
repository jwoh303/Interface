package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.mdct.dao.MasterMdCtBuyerProfilePopDao;

@Service("masterMdCtBuyerProfilePopService")
public class MasterMdCtBuyerProfilePopServiceImpl implements MasterMdCtBuyerProfilePopService {
	
	@Autowired
	private MasterMdCtBuyerProfilePopDao masterMdCtBuyerProfilePopDao;

	// 팝업 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCtBuyerProfilePopDao.selectList(formData);
	}
	
	// 팝업 매핑 조회
	public List<Map<String,String>> getMappingList(Map<String,Object> param) {
		return masterMdCtBuyerProfilePopDao.selectMappingList(param);
	}
	
	// 팝업 방문일지 조회
	public List<Map<String,String>> getCardList(Map<String,Object> param) {
		return masterMdCtBuyerProfilePopDao.selectCardList(param);
	}
	
	// 팝업 등록
	public String regSelectedData (Map<String,String> formData) {
		return masterMdCtBuyerProfilePopDao.regSelectedData(formData);
	}
	
	// 팝업 + 매핑 등록
	@Transactional
	public String regAllSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerProfilePopDao.regAllSelectedData(formData, gridData);
	}
	
	// 영업Map 이미지등록
	public String addSalesImagePop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCtBuyerProfilePopDao.addSalesImagePop(uploadForm, _pList);
	}
	
	// 조직도 이미지등록
	public String addOrgImagePop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCtBuyerProfilePopDao.addOrgImagePop(uploadForm, _pList);
	}
	
	// 시스템프로세스 이미지등록
	public String addSysImagePop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCtBuyerProfilePopDao.addSysImagePop(uploadForm, _pList);
	}
	
	// 팝업 저장
	public String saveSelectedData (Map<String,String> formData) {
		return masterMdCtBuyerProfilePopDao.saveSelectedData(formData);
	}
	
	// 팝업 + 매핑 저장
	@Transactional
	public String saveAllSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerProfilePopDao.saveAllSelectedData(formData, gridData);
	}
	
	// 팝업 매핑 삭제
	@Transactional
	public String delMappingData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerProfilePopDao.delMappingData(formData, gridData);
	}
	
	// 팝업 재계약 등록
	public String regReContractData (Map<String,String> formData) {
		return masterMdCtBuyerProfilePopDao.regReContractData(formData);
	}
}
