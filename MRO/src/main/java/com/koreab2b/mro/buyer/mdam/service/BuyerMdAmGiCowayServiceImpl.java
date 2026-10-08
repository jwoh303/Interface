package com.koreab2b.mro.buyer.mdam.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmGiCowayDao;

@Service("buyerMdAmGiCowayService")
public class BuyerMdAmGiCowayServiceImpl implements BuyerMdAmGiCowayService {
	
	@Autowired
	private BuyerMdAmGiCowayDao buyerMdAmGiCowayDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmGiCowayDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmGiCowayDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmGiCowayDao.deleteSelectedData(formData, gridData);
	}

	@Override
	public List<Map<String, String>> getPrDetail(Map<String, String> param) {
		return buyerMdAmGiCowayDao.getPrDetail(param);
	}

	@Override
	public List<Map<String, String>> getReqUserInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getReqUserInfo(map);
	}

	@Override
	public List<Map<String, String>> getRecvUserInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getRecvUserInfo(map);
	}

	@Override
	public List<Map<String, String>> getPassUserInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getPassUserInfo(map);
	}

	@Override
	public List<Map<String, String>> getReqDeptInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getReqDeptInfo(map);
	}

	@Override
	public List<Map<String, String>> getHqUserInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getHqUserInfo(map);
	}

	@Override
	public HashMap<String, String> getOriPrInfo(Map<String, String> map) {
		return buyerMdAmGiCowayDao.getOriPrInfo(map);
	}

	@Override
	public List<Map<String, String>> getGiReqExcelList(Map<String, Object> map) {
		return buyerMdAmGiCowayDao.getGiReqExcelList(map);
	}

	@Override
	public void delGsysDeliveryDispaly(Map<String, String> pMap) {
		buyerMdAmGiCowayDao.deleteGsysDeliveryDisplaySum(pMap);
	}

	@Override
	public void setGsysDeliveryDispaly(Map<String, String> pMap) {
		buyerMdAmGiCowayDao.insertGsysDeliveryDisplay(pMap);
	}

	@Override
	public void setGsysDeliveryDispalySum(Map<String, String> pMap) {
		buyerMdAmGiCowayDao.insertGsysDeliveryDisplaySum(pMap);
	}

	@Override
	public void setGsysDeliveryDispalyPrInfo(Map<String, String> pMap) {
		buyerMdAmGiCowayDao.updateGsysDeliveryDisplayPrInfo(pMap);
	}

	@Override
	public List<Map<String, String>> getGsysDeliveryDispaly(Map<String, String> pMap) {
		return buyerMdAmGiCowayDao.selectGsysDeliveryDispaly(pMap);
	}

	@Override
	public void setGsysDeliveryDispalyBatch(List<Map<String, String>> pList) {
		buyerMdAmGiCowayDao.insertGsysDeliveryDisplayBatch(pList);
	}

	@Override
	public void setGsysDeliveryDispalySumBatch(List<Map<String, String>> pList) {
		buyerMdAmGiCowayDao.insertGsysDeliveryDisplaySumBatch(pList);
		
	}

	@Override
	public void setGsysDeliveryDispalySumPrInfo(Map<String, String> pMap) {
		buyerMdAmGiCowayDao.updateGsysDeliveryDisplaySumPrInfo(pMap);
	}

	@Override
	public List<Map<String, String>> getGsysDeliveryDispalySum(Map<String, String> pMap) {
		return buyerMdAmGiCowayDao.selectGsysDeliveryDispalySum(pMap);
	}

	@Override
	public void updateExcelInfo(List<Map<String, String>> pList) {
		buyerMdAmGiCowayDao.updateExcelInfo(pList);
	}

	@Override
	public Map<String, String> getGiDetailInfo(Map<String, String> pMap) {
		return buyerMdAmGiCowayDao.selectGiDetailInfo(pMap);
	}
}
