package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.cmcl.dao.MasterCmClTaxamntAlterApPopDao;

@Service("masterCmClTaxamntAlterApPopService")
public class MasterCmClTaxamntAlterApPopServiceImpl implements MasterCmClTaxamntAlterApPopService {
	
	@Autowired
	private MasterCmClTaxamntAlterApPopDao masterCmClTaxamntAlterApPopDao;

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterCmClTaxamntAlterApPopDao.selectList(formData);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClTaxamntAlterApPopDao.updateSelectedData(formData, gridData);
	}	

}
