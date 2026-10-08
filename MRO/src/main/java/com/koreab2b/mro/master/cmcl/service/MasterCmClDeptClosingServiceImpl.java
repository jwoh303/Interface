package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClDeptClosingDao;

@Service("masterCmClDeptClosingService")
public class MasterCmClDeptClosingServiceImpl implements MasterCmClDeptClosingService {
	
	@Autowired
	private MasterCmClDeptClosingDao masterCmClDeptClosingDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClDeptClosingDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClDeptClosingDao.updateSelectedData(formData, gridData);
	}	

}
