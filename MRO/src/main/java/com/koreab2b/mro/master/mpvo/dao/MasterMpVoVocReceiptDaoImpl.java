package com.koreab2b.mro.master.mpvo.dao;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpVoVocReceiptDao")
@Transactional
public class MasterMpVoVocReceiptDaoImpl implements MasterMpVoVocReceiptDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMpVoVocReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 저장
	public String saveMasterMpVoVocReceiptList(Map<String,String>  formData) {
		_rtnMsg = "OK";
		try {
			
			String vc_no = getOrderNo("KRKORE0001", "VC");
			
			String st_req_user_id = formData.get("st_req_user_id");
			if("999999".equals(st_req_user_id)){	
				formData.put("st_req_user_id", getOrderNo(formData.get("st_buyer_code"), "RQ"));
			}
			
			formData.put("st_vc_no", vc_no);
			sqlSessionTemplate.update("master.mpvo.insertMasterMpVoVocReceiptReg", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("VOC 등록이 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	
	private String getOrderNo(String company, String dept_type){
		
		Map<String,String> pMap = new HashMap<String, String>();
		pMap.put("st_company", company);
		pMap.put("st_doc_type", dept_type);
		
		String orderNo = CommonUtil.nvl((String) sqlSessionTemplate.selectOne("master.mpvo.selectMasterMpVoVocReceiptVcNo", pMap), "");
		
		if("".equals(orderNo)){
			sqlSessionTemplate.update("master.mpvo.insertICOMSQMT", pMap);
			int year_num = Calendar.getInstance().get(Calendar.YEAR);
			String year_str = String.valueOf(year_num);
			orderNo = dept_type + year_str.substring(2,4) + "000001";
		}else{
			sqlSessionTemplate.update("master.mpvo.updateICOMSQMT", pMap);
		}
		
		return orderNo;
	}
	// VOC등록팝업 조회
	public List<Map<String,String>> selectMasterMpVoVocRegPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoVocRegPop", formData);
	}	
}
