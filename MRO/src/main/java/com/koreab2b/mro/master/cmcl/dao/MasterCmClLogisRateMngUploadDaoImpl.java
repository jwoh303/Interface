package com.koreab2b.mro.master.cmcl.dao;


import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClLogisRateMngUploadDao")
@Transactional
public class MasterCmClLogisRateMngUploadDaoImpl implements MasterCmClLogisRateMngUploadDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClLogisRateMngUploadDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.cmcl.selectMasterLogisRateMngUploadList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 엑셀 업로드 저장
	@SuppressWarnings("unchecked")
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "엑셀업로드 완료.";
		Map<String, String> agentInfo = null;
		Map<String, String> buyerInfo = null;
		String AGENT = "";
		String LOGIS_RATE = "";		
		String AGENT_USER_NAME = "";
		String END_DATE = "";		
		String REMARK = "";
		String BUYER = "";
		String EXP_FLAG = "";
	
		try{					
			sqlSessionTemplate.update("master.cmcl.deleteMasterCmClLogisRateMngUploadExcel", formData);
			
			for(int i=0; i < gridData.size(); i++){								
				formData.putAll((Map<String, String>)gridData.get(i));				
				AGENT = CommonUtil.nvl(formData.get("AGENT"),"");
				LOGIS_RATE = CommonUtil.nvl(formData.get("LOGIS_RATE"),"");				
				AGENT_USER_NAME = CommonUtil.nvl(formData.get("AGENT_USER_NAME"),"");
				END_DATE = CommonUtil.nvl(formData.get("END_DATE"),"");				
				REMARK = CommonUtil.nvl(formData.get("REMARK"),"");
				BUYER =  CommonUtil.nvl(formData.get("BUYER"),"ALL");
				EXP_FLAG =  CommonUtil.nvl(formData.get("EXP_FLAG"),"N");
				
				if("".equals(AGENT) || "".equals(LOGIS_RATE) || 
						"".equals(AGENT_USER_NAME) || "".equals(END_DATE) || "".equals(REMARK)) {					
					throw new RuntimeException("빈값이 존재합니다.");
				}
				if(!BUYER.equals("ALL")) {
					formData.put("COM_CODE", BUYER);
					buyerInfo = sqlSessionTemplate.selectOne("master.cmcl.masterCmClLogisRateMngUploadCompanyInfo", formData);
					if(buyerInfo == null) {
						throw new RuntimeException("고객사가 존재하지 않습니다.");
					}
				}
				
				formData.put("COM_CODE", AGENT);			
				agentInfo = sqlSessionTemplate.selectOne("master.cmcl.masterCmClLogisRateMngUploadCompanyInfo", formData);
				if(agentInfo == null) {
					throw new RuntimeException("협력사가 존재하지 않습니다.");
				}				
				
				sqlSessionTemplate.update("master.cmcl.insertMasterCmClLogisRateMngUploadExcel", formData);
				
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String saveUploadList(Map<String, String> formData, List<Object> gridData) {		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("BUYER", CommonUtil.nvl(formData.get("BUYER"),"ALL"));
				
				//String check = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClLogisRateMngCheck", formData);
				
				sqlSessionTemplate.update("master.cmcl.insertMasterCmClLogisRateMngUploadPopList", formData);
				
				
			}
			// 저장 후 업로드 데이터 삭제
			sqlSessionTemplate.update("master.cmcl.deleteMasterCmClLogisRateMngUploadExcel", formData);	
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException(e.getMessage());
		}
		return _rtnMsg;
	}	

	
}
