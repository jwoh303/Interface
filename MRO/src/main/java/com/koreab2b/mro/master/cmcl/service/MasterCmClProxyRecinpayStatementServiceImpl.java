package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClProxyRecinpayStatementDao;

@Service("masterCmClProxyRecinpayStatementService")
public class MasterCmClProxyRecinpayStatementServiceImpl implements MasterCmClProxyRecinpayStatementService {
	
	@Autowired
	private MasterCmClProxyRecinpayStatementDao masterCmClProxyRecinpayStatementDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClProxyRecinpayStatementDao.selectList(param);
	}	

	// 저장
//	@Transactional
//	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClProxyRecinpayStatementDao.updateSelectedData(formData, gridData);
//	}	

	// 삭제
//	@Transactional
//	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClProxyRecinpayStatementDao.deleteSelectedData(formData, gridData);
//	}
}
