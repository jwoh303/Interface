package com.koreab2b.mro.seller.mpds.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.util.CommonUtil;

public interface SellerMpDsOrderProgressManageService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	//납품실적등록
	public String updateSelectedDataDiReg(Map<String,String>  formData, List<Object> gridData);
	
	// 납품실적취소	
	public String updateSelectedDataDiCancel(Map<String,String>  formData, List<Object> gridData);
	
	// 거래명세서삭제
	public String updateSelectedDataIvCancel(Map<String,String>  formData, List<Object> gridData);
}

