package com.koreab2b.mro.master.mpso.dao;

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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoProgressDmSendPopDao")
@Transactional
public class MasterMpSoProgressDmSendPopDaoImpl implements MasterMpSoProgressDmSendPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoProgressDmSendPopDaoImpl.class);
	
	private String _rtnMsg = "";
	private String _rtnErrMsg = "";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 발주 정보 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getPoList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.mp.so.getMasterMpSoProgessDmSendPopPoList", param, _resultHander);
		List<Map<String, String>> list = (List<Map<String, String>>) _resultHander.getList();
		return list;
	}
	
	// 수신 정보 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getUserList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		param.put("st_polist2", param.get("st_polist"));
		sqlSessionTemplate.select("master.mp.so.getMasterMpSoProgessDmSendPopUserList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 메일 전송
	@SuppressWarnings("unchecked")
	public String DmSend(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "메일/SMS 전송이 완료되었습니다.";
		String _rtnErrMsg = "";
		
		try {
			Map<String,String> dmIdMap = sqlSessionTemplate.selectOne("master.mdcm.getDmSendInfoDmId");
			formData.put("DM_ID", dmIdMap.get("DM_ID"));
			formData.put("MAILFORM_ID", "DM_PO_MB");
			ResultRowHandler _resultHander = new ResultRowHandler();	
			sqlSessionTemplate.select("master.mp.so.getMasterMpSoProgessDmSendPopPoList", formData, _resultHander);
			List<Map<String, String>> list = (List<Map<String, String>>) _resultHander.getList();
			formData.put("st_buyer", list.get(0).get("BUYER"));
			// 발주 건수 만큼 Loop
			for ( int i=0; i<list.size(); i++ ) {
				list.get(i).put("DM_ID", formData.get("DM_ID"));
				sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmSendInfo", list.get(i));
			}
			// 수신자 수만큼 Loop
			for ( int i=0; i<gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				// 동시에 전송하는 다른 사람과 DM_ID 겹치는걸 방지하고자 DM_ID, 수신회원사코드, 발송자ID(KEP), MAILFORM_ID 중복 체크
				String dm_id_used_flag = sqlSessionTemplate.selectOne("master.mdcm.getDmIdUsed", formData);
				if("Y".equals(dm_id_used_flag)) {
					_rtnErrMsg = "DM발송 ID 채번에 실패하였습니다.\n창을 닫고 재시도 해주시기 바랍니다.";
					throw new RuntimeException(_rtnErrMsg);
				}
				
				_rtnErrMsg = "메일/SMS 전송에 실패하였습니다.";				
				
				if("Y".equals(formData.get("st_mail_check_flag"))) {
					// 메일 전송이력 저장
					formData.put("SEND_TYPE", "M");
					formData.put("RECV_ADDRESS", formData.get("EMAIL"));
					formData.put("REMARK", formData.get("st_mail_remark"));
					formData.put("SMS_CONTENTS", "");
					
					// 메일 발송
					sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmMailSend", formData);
					
					// 발송 이력
					sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmSendHistory", formData);
				}
				
				if("Y".equals(formData.get("st_sms_check_flag"))) {
					// SMS 발송
					sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmSmsSend", formData);
					
					// SMS 발송 이력
					formData.put("SEND_TYPE", "S");
					formData.put("RECV_ADDRESS", formData.get("MOBILE"));
					formData.put("REMARK", "");
					formData.put("SMS_CONTENTS", formData.get("st_sms_contents"));
					
					//LOGGER.debug("formData st_sms_check_flag============ {} " ,formData);
					
					sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmSendHistory", formData);
				}
			}
			
			// 운영담당자에게도 추가 메일 발송
			if("Y".equals(formData.get("st_mail_check_flag"))) {
				// 메일 전송이력 저장
				formData.put("SEND_TYPE", "M");
				formData.put("RECV_ADDRESS", formData.get("st_send_mail"));
				formData.put("REMARK", formData.get("st_mail_remark"));
				formData.put("SMS_CONTENTS", "");
				formData.put("EMAIL", formData.get("st_send_mail"));
				
				//LOGGER.debug("formData st_mail_check_flag KEP ============ {} " ,formData);
				
				// 메일 발송
				sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmMailSend", formData);
				
				// 메일 발송 이력
				sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgressDmSendHistory", formData);
			}
		} catch (Exception e){
			e.printStackTrace();
			throw new RuntimeException(_rtnErrMsg);
		}
		return _rtnMsg;
	}
		
	
}
