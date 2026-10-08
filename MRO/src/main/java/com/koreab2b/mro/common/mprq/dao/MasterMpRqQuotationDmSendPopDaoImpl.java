package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMpRqQuotationDmSendPopDao")
@Transactional
public class MasterMpRqQuotationDmSendPopDaoImpl implements MasterMpRqQuotationDmSendPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationDmSendPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationDmSendPopList", formData);
	}
	
	public List<Map<String,String>> selectTemplateList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationDmSendTemplateList", formData);
	}
	
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqQuotationDmSend(Map<String,String>  formData, List<Object> gridData) {
		//LOGGER.debug("formData111111111111111 ============ {} " ,formData);
		
		String _rtnMsg = "메일/SMS 전송이 완료되었습니다.";
		String _rtnErrMsg = "";
		
		try {
			Map<String,String> dmIdMap = sqlSessionTemplate.selectOne("master.mdcm.getDmSendInfoDmId");
			formData.put("DM_ID", dmIdMap.get("DM_ID"));
			formData.put("MAILFORM_ID", "DM_RFQ_001_MB");
			
			String quotation_seq_arr[] = formData.get("st_quotation_seq").split("@");
			
			// 수신자 수만큼 Loop
			for ( int i=0; i<gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//LOGGER.debug("formData222222222222222 ============ {} " ,formData);
				
				// 동시에 전송하는 다른 사람과 DM_ID 겹치는걸 방지하고자 DM_ID, 수신회원사코드, 발송자ID(KEP), MAILFORM_ID 중복 체크
				String dm_id_used_flag = sqlSessionTemplate.selectOne("master.mdcm.getDmIdUsed", formData);
				if("Y".equals(dm_id_used_flag)) {
					_rtnErrMsg = "DM발송 ID 채번에 실패하였습니다.\n창을 닫고 재시도 해주시기 바랍니다.";
					throw new RuntimeException(_rtnErrMsg);
				}
				
				_rtnErrMsg = "메일/SMS 전송에 실패하였습니다.";
				
				if(i==0) { // 처음 1회만 실행
					// 견적 항번 갯수만큼 Loop
					for( int j=0; j<quotation_seq_arr.length; j++ ){
						formData.put("QUOTATION_SEQ", quotation_seq_arr[j]);
						//LOGGER.debug("formData quotation_seq_arr============ {} " ,formData);
						// 전송 견적 정보
						sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmSendInfo", formData);
						
						// 정비구분 최신화 (정비 단계 상관없이 모두 수정, 유효한 단계에서만 수정될 것임)
						sqlSessionTemplate.update("common.mprq.updateMasterMpRqQuotationDmSendReqType1", formData); // 품목정비
						sqlSessionTemplate.update("common.mprq.updateMasterMpRqQuotationDmSendReqType2", formData); // 추가정비 
						sqlSessionTemplate.update("common.mprq.updateMasterMpRqQuotationDmSendReqType3", formData); // 네고정비
						
						// 재발송 이력(DM발송일시 팝업용)
						sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmRemindHist", formData);
						
						sqlSessionTemplate.update("common.mprq.updateMasterMpRqQuotationDmSendDelSchdDate", formData);
					}
				}
				
				if("Y".equals(formData.get("st_mail_check_flag"))) {
					// 메일 전송이력 저장
					formData.put("SEND_TYPE", "M");
					formData.put("RECV_ADDRESS", formData.get("EMAIL"));
					formData.put("REMARK", formData.get("st_mail_remark"));
					formData.put("SMS_CONTENTS", "");
					
					//LOGGER.debug("formData st_mail_check_flag============ {} " ,formData);
					
					// 메일 발송
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmMailSend", formData);
					
					// 발송 이력
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmSendHistory", formData);
				}
				
				if("Y".equals(formData.get("st_sms_check_flag"))) {
					// SMS 발송
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmSmsSend", formData);
					
					// SMS 발송 이력
					formData.put("SEND_TYPE", "S");
					formData.put("RECV_ADDRESS", formData.get("MOBILE"));
					formData.put("REMARK", "");
					formData.put("SMS_CONTENTS", formData.get("st_sms_contents"));
					
					//LOGGER.debug("formData st_sms_check_flag============ {} " ,formData);
					
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmSendHistory", formData);
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
				sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmMailSend", formData);
				
				// 메일 발송 이력
				sqlSessionTemplate.update("common.mprq.insertMasterMpRqQuotationDmSendHistory", formData);
			}
		} catch (Exception e){
			e.printStackTrace();
			throw new RuntimeException(_rtnErrMsg);
		}
		return _rtnMsg;
	}
}