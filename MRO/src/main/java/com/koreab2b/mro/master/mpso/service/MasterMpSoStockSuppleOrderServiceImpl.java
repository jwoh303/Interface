package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoStockSuppleOrderDao;

@Service("masterMpSoStockSuppleOrderService")
public class MasterMpSoStockSuppleOrderServiceImpl implements MasterMpSoStockSuppleOrderService {
	
	@Autowired
	private MasterMpSoStockSuppleOrderDao masterMpSoStockSuppleOrderDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoStockSuppleOrderDao.selectList(param);
	}	
	
	// 재고보충수량 수정
	@Transactional
	public String modifyMasterMpSoSoStockSuppleOrderCardQty(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoStockSuppleOrderDao.modifyMasterMpSoSoStockSuppleOrderCardQty(formData, gridData);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoStockSuppleOrderDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoStockSuppleOrderDao.deleteSelectedData(formData, gridData);
	}
}
