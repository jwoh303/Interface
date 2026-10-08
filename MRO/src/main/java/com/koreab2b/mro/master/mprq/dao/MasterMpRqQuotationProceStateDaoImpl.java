package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
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

@Repository("masterMpRqQuotationProceStateDao")
@Transactional
public class MasterMpRqQuotationProceStateDaoImpl implements MasterMpRqQuotationProceStateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationProceStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		//진행상태코드
		param.put("st_status_all", CommonUtil.getStringArrary((String) param.get("st_status"), ","));
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqQuotationProceStateList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQuotationProceStateList", param);
		}
		return resultList;
	}
	
	// MSDS반려리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectReturnMsdsList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		//진행상태코드
		param.put("st_status_all", CommonUtil.getStringArrary((String) param.get("st_status"), ","));
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqQuotationReturnMsds", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQuotationReturnMsds", param);
		}
		return resultList;
	}
	
	// MSDS견적제출
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqQuotationReturnMsds(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 견적제출 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mprq.updateQuotationReturnMsds", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("견적복원 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 견적복원 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mprq.updateQuotationProceState", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("견적복원 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
	
	// MSDS요청(협력사)
	@SuppressWarnings("unchecked")
	public String updateSelectedData2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 MSDS 요청 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP0 - CM번호 채번
				String req_no = sqlSessionTemplate.selectOne("master.mprq.selectQuotationCmcReqNo", formData);
				formData.put("st_req_no", req_no);
				
				// STEP1 - 견적정보 MSDS 대상으로 변경, MSDS번호 초기화
				sqlSessionTemplate.update("master.mprq.updateQuotationProceState2", formData);
				
				// 물질정보제출 취소 처리
				formData.put("st_cancel_note", "MSDS요청(협력사)");
				formData.put("USR_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
				
				// 협력사 첨부파일 있는지 확인
				String agent_imagekey = sqlSessionTemplate.selectOne("master.mprq.selectAgentImagekey", formData);
				
				if(!"X".equals(agent_imagekey)) { // 협력사 첨부파일 있으면 메일 전송X
					formData.put("MSDS_NO_FILEKEY", agent_imagekey);
					formData.put("P_REQ_STATUS", "S"); // 협력사제출
					
					// STEP2 - MSDS담당자에게 MSDS 요청
					sqlSessionTemplate.update("master.mprq.updateQuotationProceState3", formData);
				}else{
					formData.put("MSDS_NO_FILEKEY", "");
					formData.put("P_REQ_STATUS", "Q"); // 입력요청
					
					// STEP2 - 협력사에 MSDS 요청
					sqlSessionTemplate.update("master.mprq.updateQuotationProceState3", formData);
					
					// STEP3 - 협력사에 MSDS 요청 메일 발송
					sqlSessionTemplate.update("master.mprq.updateQuotationProceState4", formData);
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("MSDS 요청중 오류가 발생하였습니다. 시스템담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
		// 운영사 비고 저장
		@SuppressWarnings("unchecked")
		public String saveMasterMprqQuotationAtoA(Map<String,String>  formData) {
			_rtnMsg = "OK";
			try {
				sqlSessionTemplate.insert("master.mprq.saveMasterMprqQuotationAtoA", formData);
			} catch (Exception e) {
				_rtnMsg = "Err";
				throw new RuntimeException("에러가 발생하였습니다.");
			}
			return _rtnMsg;
		}
		// 협력사견적 마감시간 저장.
		@SuppressWarnings("unchecked")
		public String saveMasterMpRqQuotationAtoSDate(Map<String,String>  formData, List<Object> gridData) {
			
			_rtnMsg = "견적 마감시간이 변경 되었습니다.";
			
			try{
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// STEP1
					sqlSessionTemplate.update("master.mprq.saveMasterMpRqQuotationAtoSDate", formData); 
				}
				
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("견적시간 마감시간 변경 중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			}
			return _rtnMsg;
		}
		
		//일괄 추가라운드 요청
		@SuppressWarnings("unchecked")
		public String saveMasterMpRqQuotationSelectedRound(Map<String,String>  formData, List<Object> gridData) {
			
			_rtnMsg = "정상적으로 추가라운드 요청되었습니다.";
			String agent_revision = "";
			
			try{
				
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					
					//해당 견적번호,항번에 해당하는 협력사정보를 가져옴
					List<Map<String,String>> agentList = null;
					agentList = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQtdtAgentList", formData);
					
					//다음 REVISION값 가져온 후 셋팅
					agent_revision = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqQuotationRevision", formData);
					if (agent_revision.equals("0")){
						_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					formData.put("AGENT_REVISION", agent_revision);
					
					//기존 QTDT UPDATE처리
					sqlSessionTemplate.update("master.mprq.updateMasterMpRqPreQtdt", formData);
					
					//agent별로 셋팅
					for(int j=0;j < agentList.size(); j++) {
						formData.put("AGENT", agentList.get(j).get("AGENT"));
						formData.put("DSS_CHOICE", agentList.get(j).get("DSS_CHOICE"));
						formData.put("DSS_FLAG", agentList.get(j).get("DSS_FLAG"));

						//기본 공백으로 셋팅
						formData.put("STOA_LIST_PRICE","");
						formData.put("LEAD_TIME","");
						formData.put("SEL_USER_ID","");
						formData.put("SEL_USER_NAME","");
						formData.put("SEL_USER_TEL","");
						
						//GPL단가 등록시 자동제출되도록 기존 값으로 셋팅
						if(formData.get("DSS_CHOICE").equals("G")){
							formData.put("STOA_LIST_PRICE", CommonUtil.nvl(agentList.get(j).get("STOA_LIST_PRICE"),""));
							formData.put("LEAD_TIME",CommonUtil.nvl(agentList.get(j).get("LEAD_TIME"),""));
							formData.put("SEL_USER_ID",CommonUtil.nvl(agentList.get(j).get("SEL_USER_ID"),""));
							formData.put("SEL_USER_NAME",CommonUtil.nvl(agentList.get(j).get("SEL_USER_NAME"),""));
							formData.put("SEL_USER_TEL",CommonUtil.nvl(agentList.get(j).get("SEL_USER_TEL"),""));
						}
						//insert QTDT
						sqlSessionTemplate.update("master.mprq.insertMasterMpRqAgentRound", formData);
					}
					
					//update RQDT
					sqlSessionTemplate.update("master.mprq.updateMasterMpRqRqdt", formData);
					
					// 물질정보제출 취소 처리
					formData.put("st_cancel_note", "추가라운드");
					formData.put("USR_ID", formData.get("st_user_id"));
					sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
				}

			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("추가라운드 요청중 오류가 발생되었습니다.");
			}
			return _rtnMsg;
		}
		//협력사견적요청 메일 전송
		@SuppressWarnings("unchecked")
		public String saveMasterMpRqQuotationMailList(Map<String,String>  formData, List<Object> gridData) {
			_rtnMsg = "정상적으로 메일전송 되었습니다.";
			try{
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					// 메일전송 insert
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqQuotationMailList", formData);
					//메일이력 insert
					sqlSessionTemplate.update("master.mprq.call_PROC_USE_PGM_MNG", formData);
				}
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("메일전송 중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			}
			return _rtnMsg;
		}
		// 고객사 제출비고 저장
		@SuppressWarnings("unchecked")
		public String saveMasterMprqQuotationAtoB(Map<String,String>  formData) {
			_rtnMsg = "OK";
			try {
				sqlSessionTemplate.insert("master.mprq.saveMasterMprqQuotationAtoB", formData);
			} catch (Exception e) {
				_rtnMsg = "Err";
				throw new RuntimeException("에러가 발생하였습니다.");
			}
			return _rtnMsg;
		}
		
		// ANY 정비 제출
		@SuppressWarnings("unchecked")
		public String updateMasterMpRqAnyItmCheSend(Map<String,String>  formData, List<Object> gridData) {
			_rtnMsg = "처리 되었습니다.";
			
			try{
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					
					if(formData.get("ANY_ITEM_MD_COMPLETE").equals("N1")){
						//KEPRQDT 품목정비 제출자 업데이트, 견적취소일 초기화
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyItmCheSend", formData);
						
						//KEP_ITEM_MD_REQ 품목정비 제출자 이력 업데이트
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyItmMdSend", formData);
					}else if(formData.get("ANY_ITEM_MD_COMPLETE").equals("N2")){
						//KEPRQDT 추가정비 제출자 업데이트, 견적취소일 초기화
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyAfterItmCheSend", formData);
						
						//KEP_AFTER_ITEM_MD_REQ 추가정비 제출자 이력 업데이트
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyAfterItmMdSend", formData);
					}else if(formData.get("ANY_ITEM_MD_COMPLETE").equals("N3")){
						//KEPRQDT 견적취소일 초기화
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyNegoItmCheSend", formData);
						
						//KEP_NEGO_ITEM_MD_REQ 네고정비 제출자 이력 업데이트
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqAnyNegoItmMdSend", formData);
					}
					
					// ANY 제출 운영특이사항 입력.
					formData.put("st_image_key", "");
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
				}
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("처리 실패하였습니다.");
			}
			return _rtnMsg;
		}
		
		// DM발송 이력
		public List<Map<String,String>> selectQuotationDmRemindHistList(Map<String,Object> formData) {
			return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQuotationDmRemindHistList", formData);
		}

		// 견적 비고
		public Map<String, String> selectRemarkPop(Map<String, String> formData) {
			return sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqRemarkPostPop", formData);
		}

		@Override
		public String saveRemarkPop(Map<String, String> formData) {
			_rtnMsg = "저장 되었습니다.";
			try{
				sqlSessionTemplate.update("master.mprq.saveRemarkPop", formData);
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장 실패하였습니다. 관리자에게 문의바랍니다.");
			}
			
			return _rtnMsg;
		}
}
