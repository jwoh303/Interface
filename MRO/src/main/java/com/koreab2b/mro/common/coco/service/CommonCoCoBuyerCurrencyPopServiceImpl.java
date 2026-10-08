package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBuyerCurrencyPopDao;

@Service("commonCoCoBuyerCurrencyPopService")
public class CommonCoCoBuyerCurrencyPopServiceImpl implements CommonCoCoBuyerCurrencyPopService {
	@Autowired
	private CommonCoCoBuyerCurrencyPopDao commonCoCoBuyerCurrencyPopDao; 
	//조회
	public List<Map<String, String>> getCommonCoCoBuyerCurrencyPop(Map<String, Object> pMap) {
		return commonCoCoBuyerCurrencyPopDao.getCommonCoCoBuyerCurrencyPop(pMap);
	}
	// 생성
	@Transactional
	public String saveCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData) {
		return commonCoCoBuyerCurrencyPopDao.saveCommonCoCoBuyerCurrencyPop(formData, gridData);
	}
	// 삭제
	@Transactional
	public String deleteCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData) {
		return commonCoCoBuyerCurrencyPopDao.deleteCommonCoCoBuyerCurrencyPop(formData, gridData);
	}
}
