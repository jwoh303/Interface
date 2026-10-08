package com.koreab2b.mro.master.mprq.dao;

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

import com.koreab2b.mro.master.mprq.controller.MasterMpRqBuyerReqController;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpRqBuyerReqDao")
@Transactional
public class MasterMpRqBuyerReqDaoImpl implements MasterMpRqBuyerReqDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerReqController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 저장(견적의뢰)
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		String resultNo = "";
		try {
		// 채번
		resultNo = this.nextVal(formData.get("st_buyer"), "RE");
		formData.put("QUOTATION_NO", resultNo);
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));		
			
			if (!formData.get("GW_NO").equals("N")){
				
			} else {
				formData.put("GW_NO", "");
			}
			
			sqlSessionTemplate.insert("master.mp.rq.insertMasterMpRqBuyerReq", formData);
			
        	// 견적의뢰자 마지막 로그인정보 UPDATE
			formData.put("LAST_LOGIN_ID", CommonUtil.nvl(formData.get("st_btoa_user_id"), ""));
	        sqlSessionTemplate.insert("login.saveLogintime", formData);
	        
			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
			formData.put("DOC_NO", formData.get("IMAGE_KEY"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
		}
		// 두산인프라코어 전용
//		if (pMap.get("Stype").equals("RAV")){
//			sqlSessionTemplate.insert("master.mp.rq.updateMasterMpRqBuyerReq", pMap);
//		}
		// 추후 처리
		} catch (Exception e){
			LOGGER.debug("Exception : ", e);
			throw new RuntimeException( "저장에 실패하였습니다.");
		}
		return resultNo;
	}
	
	//채번
	public String nextVal(String cmpyId, String docType)
	{
		String returnValue = null;
		Map<String, String>  pMap = new HashMap<String, String>();
		
		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("master.mp.rq.getDocuNo", pMap);
			LOGGER.debug("채번 - returnValue : ", returnValue);
			
			if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){ 
				sqlSessionTemplate.insert("master.mp.rq.insertDocuNo", pMap);
				
				String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
				returnValue = docType +year.substring(3) + "000001";
			} else {
				sqlSessionTemplate.update("master.mp.rq.updateDocuNo", pMap);
//				returnValue = sqlSessionTemplate.selectOne("master.mp.rq.getDocuNo", pMap);
			}
			LOGGER.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			LOGGER.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
}
