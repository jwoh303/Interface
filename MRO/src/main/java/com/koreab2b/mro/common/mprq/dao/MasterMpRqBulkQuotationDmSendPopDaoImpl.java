package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.controller.MasterMpRqBulkQuotationDmSendPopController;

@Repository("masterDmSendDao")
@Transactional
public class MasterMpRqBulkQuotationDmSendPopDaoImpl implements MasterMpRqBulkQuotationDmSendPopDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationDmSendPopController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	private String _rtnErrMsg = "";
	// 메일 전송
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqAgentDmSend(Map<String,String>  formData, List<Object> gridData) {
		int mailSendCnt = 0;
		int smsSendCnt = 0;
		String STR_RECV_SMS_FLG = "RECV_SMS_FLG";
		String STR_RECV_MAIL_FLG = "RECV_MAIL_FLG";
		
		String STR_RECV_MAIL = "RECV_MAIL";
		String STR_RECV_NAME = "RECV_NAME";
		String STR_RECV_MOBILE_NUMBER = "RECV_MOBILE_NUMBER";
		String STR_RECV_ADDRESS = "RECV_ADDRESS";
		String STR_RECV_OPTION = "RECV_OPTION";
		String STR_SEND_NAME = "SEND_NAME";
		String STR_SEND_EMAIL = "SEND_EMAIL";
		// DM 발송 정보
		String STR_DM_ID = "DM_ID";
		String STR_SENT_BUYER = "SENT_BUYER";
		String STR_SENT_PO_NO = "SENT_PO_NO";
		String STR_SENT_PO_SEQ = "SENT_PO_SEQ";
		String STR_SENT_DS_SEQ = "SENT_DS_SEQ";
		String STR_SENT_SEQ = "SENT_SEQ";
		String STR_SENT_BYCA_COMORG_CODE = "SENT_BYCA_COMORG_CODE";
		String STR_SENT_BUYER_ITEM_NO = "SENT_BUYER_ITEM_NO";
		String STR_SENT_AGENT = "SENT_AGENT";
		
		// 제거 컬럼 명
		String STR_MAILFORM_ID = "MAILFORM_ID";
		String STR_SMS_CONTENTS = "SMS_CONTENTS";

		String RECV_FLG_Y = "1";
		String RECV_OPTION_Y = "Y";
		String STR_SEND_TYPE = "SEND_TYPE";
		String SEND_TYPE_MAIL = "M";
		String SEND_TYPE_SMS = "S";

		_rtnMsg = "메일 전송이 완료되었습니다.";
		
		try {

			// DM 발송 정보의 DM_ID 취득 2024.04.23 1회만 취득하도록 변경
			Map<String,String> dmIdMap = sqlSessionTemplate.selectOne("master.mdcm.getDmSendInfoDmId");
			formData.put(STR_DM_ID, dmIdMap.get(STR_DM_ID));
			
			// 메일 전송 대상 만큼 Loop
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				LOGGER.debug("saveMasterMpRqAgentDmSend formData {}", formData);
				// 동시에 전송하는 다른 사람과 DM_ID 겹치는걸 방지하고자 DM_ID, 수신회원사코드, 발송자ID(KEP), MAILFORM_ID 중복 체크
				String dm_id_used_flag = sqlSessionTemplate.selectOne("master.mdcm.getDmIdUsed", formData);
				if("Y".equals(dm_id_used_flag)) {
					_rtnErrMsg = "DM발송 ID 채번에 실패하였습니다.\n창을 닫고 재시도 해주시기 바랍니다.";
					throw new RuntimeException(_rtnErrMsg);
				}
				
				_rtnErrMsg = "DM발송에 실패하였습니다.";
				
				// sms 전송 및 이력 저장
				if(formData.get(STR_RECV_SMS_FLG) != null && formData.get(STR_RECV_SMS_FLG).equals(RECV_FLG_Y) && i < gridData.size()-1) { // sms는 본인 전송하지 않아도 되므로 마지막 본인 전송 처리 제외
					String tempMailFormId = "";
					String tempRemark = "";
					// SEND_TYPE 세팅
					formData.put(STR_SEND_TYPE, SEND_TYPE_SMS);
					// sms 지정
					formData.put(STR_RECV_ADDRESS, formData.get(STR_RECV_MOBILE_NUMBER).toString());
					// SMS 발송
					sqlSessionTemplate.update("common.mprq.insertMasterMprqBulkQuotationDmSmsSend", formData); // 슈어엠
					// 운영자메모 제거 및 임시저장
					tempRemark = formData.get("REMARK");
					formData.put("REMARK", "");
					
					// 전송이력 저장
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqDmMailSendHistory", formData);
					// SEND_TYPE 제거
					formData.remove(STR_SEND_TYPE);
					// 메일 or sms 제거
					formData.remove(STR_RECV_ADDRESS);
					// 운영자메모 복원
					formData.put("REMARK", tempRemark);
					smsSendCnt++;
				}
				
				// email 전송 및 이력 저장
				if(formData.get(STR_RECV_MAIL_FLG) != null && formData.get(STR_RECV_MAIL_FLG).equals(RECV_FLG_Y)) {
					// 본인 전송 건까지 메일전송이 1건도 없었다면 본인에게도 메일을 보내지 않음
					if(gridData.size()-1 == i && mailSendCnt == 0) {
						continue;
					} else if(gridData.size()-1 == i) {
						// 마지막에 DM 발송에 데이터 저장
						LOGGER.debug("saveMasterMpRqAgentDmSend insert email {}", formData);
						sqlSessionTemplate.update("common.mprq.insertMasterMpRqDmMailSend", formData);
					}
					String tempSmsContents = "";
					// SEND_TYPE 세팅
					formData.put(STR_SEND_TYPE, SEND_TYPE_MAIL);
					// 메일 지정
					formData.put(STR_RECV_ADDRESS, formData.get(STR_RECV_MAIL).toString());
					// sms_contents 제거 및 백업
					tempSmsContents = formData.get(STR_SMS_CONTENTS);
					formData.put(STR_SMS_CONTENTS, "");
					// 전송이력 저장
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqDmMailSendHistory", formData);
					// SEND_TYPE 제거
					formData.remove(STR_SEND_TYPE);
					// 메일 or sms 제거
					formData.remove(STR_RECV_ADDRESS);
					// sms contents 복원
					formData.put(STR_SMS_CONTENTS, tempSmsContents);
					mailSendCnt++;
				}
			}

			// DM이 1건이라도 전송 되었다면
			if(smsSendCnt > 0 || mailSendCnt > 0) {
				// 벌크소싱 진행현황에서 체크했던 품목만큼 INSERT
				String item_list = formData.get("st_item_list");
				String[] item_arr = item_list.split("@@"); // BURQ_NO-BURQ_RFQ_NO
				
				for (int j = 0; j < item_arr.length; j++) {
					String[] data_arr = item_arr[j].split("-");
					formData.put("SENT_AGENT", formData.get("st_com_code"));
					formData.put("SENT_BURQ_NO", data_arr[0]);
					formData.put("SENT_BURQ_RFQ_NO", data_arr[1]);
					// DM 발송 정보 저장
					sqlSessionTemplate.update("common.mprq.insertMasterMpRqDmMailSendInfo", formData);
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			throw new RuntimeException(_rtnErrMsg);
		}
		return _rtnMsg;
	}

}
