package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClRecinpayTotalDao;

@Service("masterCmClRecinpayTotalService")
public class MasterCmClRecinpayTotalServiceImpl implements MasterCmClRecinpayTotalService {
	
	@Autowired
	private MasterCmClRecinpayTotalDao masterCmClRecinpayTotalDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClRecinpayTotalDao.selectList(param);
	}	

	// 저장
//	@Transactional
//	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClRecinpayTotalDao.updateSelectedData(formData, gridData);
//	}	

	// 삭제
//	@Transactional
//	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterCmClRecinpayTotalDao.deleteSelectedData(formData, gridData);
//	}
}
