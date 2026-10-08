package com.koreab2b.mro.rfc.coway.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

import com.koreab2b.mro.rfc.coway.service.BuyerCowayRfcService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerCowayRfcController")
public class BuyerCowayRfcController {

	/**
	 * Alias for this pool
	 */
	@Value("#{rfcServiceProps['resource.rfcService.dbpool']}")
	private String dbpool;
	/**
	 * Max. number of connections
	 */
	@Value("#{rfcServiceProps['resource.rfcService.poolsize']}")
	private int poolsize;
	/**
	 * SAP client
	 */
	@Value("#{rfcServiceProps['resource.rfcService.pro_client']}")
	private String proClient;
	/**
	 * user id
	 */
	@Value("#{rfcServiceProps['resource.rfcService.userid']}")
	private String userId;
	/**
	 * language
	 */
	@Value("#{rfcServiceProps['resource.rfcService.language']}")
	private String language;
	/**
	 * host name
	 */
	@Value("#{rfcServiceProps['resource.rfcService.hostname']}")
	private String hostname;
	/**
	 * system number
	 */
	@Value("#{rfcServiceProps['resource.rfcService.systemnumber']}")
	private String systemnumber;
	/**
	 * Alias for this pool Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.dbpoolDev']}")
	private String dbpoolDev;
	/**
	 * Max. number of connections Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.poolsizeDev']}")
	private int poolsizeDev;
	/**
	 * SAP client Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.pro_clientDev']}")
	private String proClientDev;
	/**
	 * user id Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.useridDev']}")
	private String userIdDev;
	/**
	 * password Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.passwdDev']}")
	private String passwdDev;
	/**
	 * language Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.languageDev']}")
	private String languageDev;
	/**
	 * host name Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.hostnameDev']}")
	private String hostnameDev;
	/**
	 * system number Dev
	 */
	@Value("#{rfcServiceProps['resource.rfcService.systemnumberDev']}")
	private String systemnumberDev;

	@Value("#{rfcServiceProps['resource.rfcService.client']}")
	private String client;
	@Value("#{rfcServiceProps['resource.rfcService.user']}")
	private String user;
	@Value("#{rfcServiceProps['resource.rfcService.passwd']}")
	private String passwd;
	@Value("#{rfcServiceProps['resource.rfcService.lang']}")
	private String lang;
	@Value("#{rfcServiceProps['resource.rfcService.ashost']}")
	private String ashost;
	@Value("#{rfcServiceProps['resource.rfcService.sysnr']}")
	private String sysnr;
	@Value("#{rfcServiceProps['resource.rfcService.group']}")
	private String group;
	@Value("#{rfcServiceProps['resource.rfcService.r3name']}")
	private String r3name;

	@Value("#{rfcServiceProps['resource.rfcService.mshost']}")
	private String mshost;
	@Value("#{rfcServiceProps['resource.rfcService.msserv']}")
	private String msserv;

	
	@Autowired
	BuyerCowayRfcService buyerCowayRfcService;

	/**
	 * 코웨이 RFC
	 * 
	 * @param functionName
	 * @param inTableName
	 * @param tableName
	 * @param paramMap
	 * @return List
	 */
	public List<Map<String, String>> getRfc(String functionName, String inTableName, String tableName,
			Map<String, String> paramMap, HttpServletRequest req) {
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		paramMap = CommonUtil.getMapNvl(paramMap);
		paramMap.putAll(setRfcPorperties(paramMap, req));
		buyerCowayRfcService.getRfcConnection(paramMap);
		paramMap.put("functionName", functionName);
		paramMap.put("inTableName", inTableName);
		paramMap.put("tableName", tableName);
		resultList = buyerCowayRfcService.getRfc(paramMap);
		buyerCowayRfcService.cleanUp();
		return resultList;
	}

	/**
	 * 코웨이 RFC
	 * 
	 * @param functionName
	 * @param inTableName
	 * @param tableName
	 * @param paramMap
	 * @return Map<String, String>
	 */
	public Map<String, String> setRfc(String functionName, String inTableName, String tableName,
			Map<String, String> paramMap, HttpServletRequest req) {
		Map<String, String> rtn = new HashMap<String, String>();
		paramMap.putAll(setRfcPorperties(paramMap, req));
		buyerCowayRfcService.getRfcConnection(paramMap);
		paramMap.put("functionName", functionName);
		paramMap.put("inTableName", inTableName);
		paramMap.put("tableName", tableName);
		rtn.putAll(buyerCowayRfcService.setRfc(paramMap));
		buyerCowayRfcService.cleanUp();
		return rtn;
	}

	/**
	 * 코웨이 RFC
	 * 
	 * @param functionName
	 * @param inTableName
	 * @param tableName
	 * @param paramMap
	 * @return Map<String, String>
	 */
	public Map<String, String> setRfc(String functionName, String inTableName, String tableName,
			Map<String, String> paramMap, List<Map<String, String>> paramList, HttpServletRequest req) {
		Map<String, String> rtn = new HashMap<String, String>();
		paramMap.putAll(setRfcPorperties(paramMap, req));
		buyerCowayRfcService.getRfcConnection(paramMap);
		paramMap.put("functionName", functionName);
		paramMap.put("inTableName", inTableName);
		paramMap.put("tableName", tableName);
		rtn.putAll(buyerCowayRfcService.setRfc(paramMap, paramList));
		buyerCowayRfcService.cleanUp();
		return rtn;
	}

	/**
	 * 코웨이 RFC
	 * 
	 * @param functionName
	 * @param inTableName
	 * @param tableName
	 * @param paramMap
	 * @param pList
	 * @return String
	 */
	public List<Map<String, String>> getRfc(String functionName, String tableName, Map<String, String> paramMap,
			List<Map<String, String>> pList, HttpServletRequest req) {
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		paramMap.putAll(setRfcPorperties(paramMap, req));
		buyerCowayRfcService.getRfcConnection(paramMap);
		paramMap.put("functionName", functionName);
		paramMap.put("tableName", tableName);
		resultList = buyerCowayRfcService.getRfc(paramMap, pList);
		buyerCowayRfcService.cleanUp();
		return resultList;
	}

	public Map<String, String> getRfcPropAndConn(Map<String, String> paramMap, HttpServletRequest req) {
		paramMap.putAll(setRfcPorperties(paramMap, req));
		buyerCowayRfcService.getRfcConnection(paramMap);
		return paramMap;
	}

	public Map<String, String> setRfcPorperties(Map<String, String> paramMap, HttpServletRequest req) {
		String devRealLocalFlag = "0";
		paramMap = CommonUtil.getMapNvl(paramMap);
		// TODO 오픈시 아래주석 헤재
		devRealLocalFlag = CommonUtil.getDevRealLocalFlag(req);
		paramMap.put("devRealLocalFlag", devRealLocalFlag);
		
		if("2".equals(devRealLocalFlag)){
//			paramMap.put("client", this.client);
//			paramMap.put("user", this.user);
//			paramMap.put("passwd", this.passwd);
//			paramMap.put("lang", this.lang);
//			paramMap.put("ashost", this.ashost);
//			paramMap.put("group", this.group);
//			paramMap.put("r3name", this.r3name);
//			paramMap.put("sysnr", this.sysnr);
			
			paramMap.put("client", this.client);
			paramMap.put("user", this.user);
			paramMap.put("passwd", this.passwd);
			paramMap.put("lang", this.lang);
			paramMap.put("mshost", this.mshost);
			paramMap.put("msserv", this.msserv);
			paramMap.put("group", this.group);
			paramMap.put("r3name", this.r3name);
			paramMap.put("sysnr", this.sysnr);
			
		} else {
			paramMap.put("client", this.client);
			paramMap.put("user", this.user);
			paramMap.put("passwd", this.passwd);
			paramMap.put("lang", this.lang);
			//paramMap.put("ashost", this.hostnameDev);
			paramMap.put("mshost", this.mshost);
			paramMap.put("msserv", this.msserv);
			
			paramMap.put("group", this.group);
			paramMap.put("r3name", this.r3name);
			paramMap.put("sysnr", this.sysnr);
			
		}
		return paramMap;
	}
}
