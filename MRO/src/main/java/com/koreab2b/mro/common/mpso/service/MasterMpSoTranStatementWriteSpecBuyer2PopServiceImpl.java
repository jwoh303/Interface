package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoTranStatementWriteSpecBuyer2PopDao;

@Service("masterMpSoTranStatementWriteSpecBuyer2PopService")
public class MasterMpSoTranStatementWriteSpecBuyer2PopServiceImpl implements MasterMpSoTranStatementWriteSpecBuyer2PopService {
	
	@Autowired
	private MasterMpSoTranStatementWriteSpecBuyer2PopDao masterMpSoTranStatementWriteSpecBuyer2PopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoTranStatementWriteSpecBuyer2PopDao.selectList(formData);
	}	
	

}
