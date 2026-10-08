package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoTranStatementManualWritePopDao;

@Service("masterMpSoTranStatementManualWritePopService")
public class MasterMpSoTranStatementManualWritePopServiceImpl implements MasterMpSoTranStatementManualWritePopService {
	
	@Autowired
	private MasterMpSoTranStatementManualWritePopDao masterMpSoTranStatementManualWritePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoTranStatementManualWritePopDao.selectList(formData);
	}	
	

}
