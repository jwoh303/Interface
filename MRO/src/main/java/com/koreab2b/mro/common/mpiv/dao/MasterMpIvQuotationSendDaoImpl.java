package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpIvQuotationSendDao")
@Transactional
public class MasterMpIvQuotationSendDaoImpl implements MasterMpIvQuotationSendDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectMasterMpIvQuotationSendDelayPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectLngtermDelayPopList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectMasterMpIvQuotationSendLngtermDelayPopList", formData);
	}
	
	public String insertMasterMpIvQuotationSendDelayReasonPop(Map<String,String> pMap) {
		String returnStr = "INSERT_OK";
		//견적지연사유 입력.
		sqlSessionTemplate.update("common.mpiv.updateMasterMpIvQuotationSendDelayReasonPop", pMap);
		//메일전송여부
		if(pMap.get("st_mail_yn").equals("Y")){
			sqlSessionTemplate.update("common.mpiv.updateRcApprovalConfirmMail", pMap);	
		}
		return returnStr;
	}
	// 견적지연사유
	public List<Map<String,String>> getRqdtDelayReasonPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.mpiv.selectRqdtDelayReasonPopList", pMap); 
	}
	// 견적 세부진행상태
	public List<Map<String,String>> getRqdtDelayDetailPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.mpiv.selectRqdtDelayDetailPop", pMap); 
	}
}
