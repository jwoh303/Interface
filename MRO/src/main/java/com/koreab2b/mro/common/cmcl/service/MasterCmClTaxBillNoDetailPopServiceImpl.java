package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.cmcl.dao.MasterCmClCmmntPopDao;
import com.koreab2b.mro.common.cmcl.dao.MasterCmClTaxBillNoDetailPopDao;

@Service("masterCmClTaxBillNoDetailPopService")
public class MasterCmClTaxBillNoDetailPopServiceImpl implements MasterCmClTaxBillNoDetailPopService {
	
	@Autowired
	private MasterCmClTaxBillNoDetailPopDao masterCmClTaxBillNoDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterCmClTaxBillNoDetailPopDao.selectList(formData);
	}	
	
	
}
