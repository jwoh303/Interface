package com.kep.exchangerate.dao;

import java.util.List;
import java.util.Map;

public interface ExchangeRateDao {
	
	public List<Map<String, String>> getCurrencyCodeList() throws Exception;
	
	public List<Map<String, Object>> getCurrencyInfoList(Map<String, String> pMap) throws Exception;

	public void saveExchangeRateInfo(Map<String, String> pMap) throws Exception;

	public void saveExchangeRateInfo2(Map<String, String> pMap) throws Exception;
	
	public void saveExchangeRateHD(Map<String, Object> pMap) throws Exception;
	
	public void sendExchangeAlertMail(Map<String, Object> pMap) throws Exception;
	
	public List<Map<String, String>> getSendMailUser(Map<String, Object> pMap) throws Exception;
}