package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmChemicalMatMngDao;

@Service("masterMdCmChemicalMatMngService")
public class MasterMdCmChemicalMatMngServiceImpl implements MasterMdCmChemicalMatMngService {
	
	@Autowired
	private MasterMdCmChemicalMatMngDao masterMdCmChemicalMatMngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmChemicalMatMngDao.selectList(param);
	}	
	// 협력사반려
	@Transactional
	public String returnMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatMngDao.returnMasterrMdCtChemicalMat(formData, gridData);
	}
	// 검토요청
	@Transactional
	public String reqMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatMngDao.reqMasterrMdCtChemicalMat(formData, gridData);
	}
	// 상태변경
	@Transactional
	public String updateStatusMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatMngDao.updateStatusMasterrMdCtChemicalMat(formData, gridData);
	}
	// 최종승인
	@Transactional
	public String confirmMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatMngDao.confirmMasterrMdCtChemicalMat(formData, gridData);
	}
	// 발주 후 제출
	@Transactional
	public String afterMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatMngDao.afterMasterrMdCtChemicalMat(formData, gridData);
	}
}
