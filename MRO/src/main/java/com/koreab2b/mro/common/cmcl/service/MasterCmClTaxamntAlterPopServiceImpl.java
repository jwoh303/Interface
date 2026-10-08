package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.cmcl.dao.MasterCmClTaxamntAlterPopDao;

@Service("masterCmClTaxamntAlterPopService")
public class MasterCmClTaxamntAlterPopServiceImpl implements MasterCmClTaxamntAlterPopService {
	
	@Autowired
	private MasterCmClTaxamntAlterPopDao masterCmClTaxamntAlterPopDao;

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterCmClTaxamntAlterPopDao.selectList(formData);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClTaxamntAlterPopDao.updateSelectedData(formData, gridData);
	}	

}
