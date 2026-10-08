package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoStockMovemntStdcatlgPopDao;

@Service("masterMpSoStockMovemntStdcatlgPopService")
public class MasterMpSoStockMovemntStdcatlgPopServiceImpl implements MasterMpSoStockMovemntStdcatlgPopService {
	@Autowired
	private MasterMpSoStockMovemntStdcatlgPopDao masterMpSoStockMovemntStdcatlgPopDao;
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpSoStockMovemntStdcatlgPopDao.selectList(formData);
	}
}
