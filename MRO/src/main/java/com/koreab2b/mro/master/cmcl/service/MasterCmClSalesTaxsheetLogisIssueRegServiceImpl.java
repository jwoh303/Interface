package com.koreab2b.mro.master.cmcl.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetLogisIssueRegDao;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetLogisIssueRegDaoImpl;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSmartBillUploadingCreationDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.AesCryptoAlgorithmUtil;

@Service("masterCmClSalesTaxsheetLogisIssueRegService")
public class MasterCmClSalesTaxsheetLogisIssueRegServiceImpl implements MasterCmClSalesTaxsheetLogisIssueRegService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetLogisIssueRegDaoImpl.class);
	
	@Autowired
	private MasterCmClSalesTaxsheetLogisIssueRegDao masterCmClSalesTaxsheetLogisIssueRegDao;
	@Autowired
	private MasterCmClSmartBillUploadingCreationDao masterCmClSmartBillUploadingCreationDao;
	

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesTaxsheetLogisIssueRegDao.selectList(param);
	}	

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetLogisIssueRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetLogisIssueRegDao.deleteSelectedData(formData, gridData);
	}
	@Transactional
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetLogisIssueRegDao.deleteSelectedData_v2(formData, gridData);
	}
	
}
