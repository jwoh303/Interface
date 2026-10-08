package com.koreab2b.mro.master.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCmAgentDmSendDao")
@Transactional
public class MasterMdCmAgentDmSendPopDaoImpl implements MasterMdCmAgentDmSendPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	private String _rtnErrMsg = "";
	
	// 협력사 수신정보 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmAgentDmSendPopList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 메일 전송
	@SuppressWarnings("unchecked")
	public String saveMasterMdcmAgentDmSend(Map<String,String>  formData, List<Object> gridData) {
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
			// 운영담당자 메일전송 대상 추가
			Map<String, String> selfMap = new HashMap<String, String>();
			selfMap.put(STR_RECV_MAIL_FLG, RECV_FLG_Y);
			selfMap.put(STR_RECV_MAIL, formData.get(STR_SEND_EMAIL));
			selfMap.put(STR_RECV_NAME, formData.get(STR_SEND_NAME));
			selfMap.put(STR_RECV_OPTION, RECV_OPTION_Y);
			gridData.add(selfMap);

			// DM 발송 정보의 DM_ID 취득 2024.04.23 1회만 취득하도록 변경
			Map<String,String> dmIdMap = sqlSessionTemplate.selectOne("master.mdcm.getDmSendInfoDmId");
			formData.put(STR_DM_ID, dmIdMap.get(STR_DM_ID));
			
			// 메일 전송 대상 만큼 Loop
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

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
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmAgentDmSmsSend", formData); // 슈어엠
					// 운영자메모 제거 및 임시저장
					tempRemark = formData.get("REMARK");
					formData.put("REMARK", "");
					// 전송이력 저장
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmAgentDmMailSendHistory", formData);
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
						sqlSessionTemplate.update("master.mdcm.insertMasterMdCmAgentDmMailSend", formData);
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
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmAgentDmMailSendHistory", formData);
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
				// 이슈 정보 취득
				List<Map<String,String>> issueList = sqlSessionTemplate.selectList("master.mdcm.getAgentDmIssueList", formData);
				// 이슈데이터 만큼 Loop
				for (Map<String,String> tmpMap : issueList) {
					if(tmpMap.get(STR_SENT_PO_SEQ).equals("000000")) {
						tmpMap.put(STR_SENT_BUYER_ITEM_NO, "");
					}
					// 이슈데이터 추가
					formData.put(STR_SENT_BUYER, tmpMap.get(STR_SENT_BUYER));
					formData.put(STR_SENT_PO_NO, tmpMap.get(STR_SENT_PO_NO));
					formData.put(STR_SENT_PO_SEQ, tmpMap.get(STR_SENT_PO_SEQ));
					formData.put(STR_SENT_DS_SEQ, tmpMap.get(STR_SENT_DS_SEQ));
					formData.put(STR_SENT_SEQ, tmpMap.get(STR_SENT_SEQ));
					formData.put(STR_SENT_BYCA_COMORG_CODE, tmpMap.get(STR_SENT_BYCA_COMORG_CODE));
					formData.put(STR_SENT_BUYER_ITEM_NO, tmpMap.get(STR_SENT_BUYER_ITEM_NO));
					formData.put(STR_SENT_AGENT, tmpMap.get(STR_SENT_AGENT));
					// DM 발송 정보 저장
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmAgentDmMailSendInfo", formData);
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			throw new RuntimeException(_rtnErrMsg);
		}
		return _rtnMsg;
	}

	// 메일 수신여부 변경
	@SuppressWarnings("unchecked")
	public String saveMailRecv(Map<String,String> formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("master.mdcm.updateMasterMdCmAgentDmRecv", formData);
		} catch (Exception e) {
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}

	// 협력사 dm 발송 이슈 정보 취득
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getAgentDmIssueList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.getAgentDmIssueList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	
	// 협력사 dm 발송 템플릿 목록 취득
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getDmSendTemplateList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.getDmSendTemplateList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
}
