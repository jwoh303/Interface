package com.koreab2b.mro.rfc.coway.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.rfc.coway.dao.BuyerCowayRfcDao;

/**
 * 출고확정조회 RFC 인터페이스
 * 
 * @author Swordfish
 * @remark PR번호 Receiver
 */
@Service("buyercowayRfcService")
public class BuyerCowayRfcServiceImpl implements BuyerCowayRfcService {
	@Autowired
	BuyerCowayRfcDao buyerCowayRfcDao;

	@Override
	public List<Map<String, String>> getRfc(Map<String, String> paramMap) {
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		String functionName = String.valueOf(paramMap.get("functionName"));
		if ("ZMM_GSYS_DE_RER_DISPLAY".equals(functionName)) {
			resultList = buyerCowayRfcDao.execZmmGsysDeRerDisplay(paramMap);
		} else if ("ZMM_GSYS_DELIVERY_DISPLAY_SUM".equals(functionName)) {
			resultList = buyerCowayRfcDao.execZmmGsysDeliveryDisplaySum(paramMap);
		} else {
			return null;
		}
		return resultList;
	}

	@Override
	public List<Map<String, String>> getRfc(Map<String, String> paramMap, List<Map<String, String>> pList) {
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		String functionName = String.valueOf(paramMap.get("functionName"));
		if ("ZMM_GSYS_REQ_STATUS_DISPLAY".equals(functionName)) {
			resultList = buyerCowayRfcDao.execZmmGsysReqStatusDisplay(paramMap, pList);
		} else {
			return null;
		}
		return resultList;
	}

	@Override
	public Map<String, String> setRfc(Map<String, String> paramMap) {
		Map<String, String> rtn = new HashMap<String, String>();
		String functionName = String.valueOf(paramMap.get("functionName"));
		if ("ZMM_GSYS_DE_RE_CHECK".equals(functionName)) {
			rtn = buyerCowayRfcDao.execZmmGsysDeReCheck(paramMap);
		} else {
			rtn.put("MESSAGE", "No type function");
			return rtn;
		}
		return rtn;
	}

	@Override
	public Map<String, String> setRfc(Map<String, String> paramMap, List<Map<String, String>> pList) {
		Map<String, String> rtn = new HashMap<String, String>();
		String functionName = String.valueOf(paramMap.get("functionName"));
		if ("ZMM_GSYS_REREQUEST_CHECK".equals(functionName)) {
			rtn = buyerCowayRfcDao.execZmmGsysRerequestCheck(paramMap, pList);
			return rtn;
		} else {
			rtn.put("MESSAGE", "No type function");
			return rtn;
		}
	}

	@Override
	public void getRfcConnection(Map<String, String> paramMap) {
		buyerCowayRfcDao.getRfcConnection(paramMap);
	}

	public void cleanUp() {
	}
}
