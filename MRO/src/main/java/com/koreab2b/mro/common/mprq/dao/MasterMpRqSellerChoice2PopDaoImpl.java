package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;
import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMpRqSellerChoice2PopDao")
@Transactional
public class MasterMpRqSellerChoice2PopDaoImpl implements MasterMpRqSellerChoice2PopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice2PopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> getListHd(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice2PopHdList", formData);
	}
	
	// 조회
	public List<Map<String,String>> getListDetail(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoice2Detail", formData);
	}
	
	@SuppressWarnings("unchecked")
	public String saveReAgentSelect(Map<String,String>  formData, List<Object> gridData){
		_rtnMsg = "정상적으로 추가라운드 요청되었습니다.";
		try{
			Map<String,String> _result = null;
			int _seq = 1;
			String _quo_seq = "defaultSeq";
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_quotation_seq", formData.get("QUOTATION_SEQ"));
				
				if (_quo_seq.equals(formData.get("QUOTATION_SEQ"))){
					_seq++;
				} else {
					_seq = 1;
				}
				
				if (_seq == 1){
					
					_quo_seq = formData.get("QUOTATION_SEQ");
					// Get next AGENT_REVISION */
					_result = sqlSessionTemplate.selectOne("common.mprq.selectRevision", formData);
					if (String.valueOf(_result.get("AGENT_REVISION")).equals("0")){
						_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					formData.put("PRE_AGENT_REVISION", String.valueOf(_result.get("PRE_AGENT_REVISION")));
					formData.put("AGENT_REVISION2", String.valueOf(_result.get("AGENT_REVISION")));

					// Check KEPQTDT Insert Condition
					Map<String,String> _chkFlag = sqlSessionTemplate.selectOne("common.mprq.selectChkFlag", formData);
					if (String.valueOf(_chkFlag.get("CHK_FLAG")).equals("Y")){
						sqlSessionTemplate.update("common.mprq.updateChkFlag", formData);
					} else {
						_rtnMsg = "추가라운드 대상이 아닙니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				// 협력사별 데이터 생성
				if (formData.get("DSS_CHOICE").indexOf("A,B,C,S,Y") > -1 ){
					formData.put("DSS_FLAG", "Y");
				} else {
					formData.put("DSS_FLAG", "N");
				}
				formData.put("STOA_LIST_PRICE","");
				formData.put("LEAD_TIME","");
				formData.put("SEL_USER_ID","");
				formData.put("SEL_USER_NAME","");
				formData.put("SEL_USER_TEL","");
				//GPL단가 등록시 견적자동제출
				if(formData.get("DSS_CHOICE").equals("G")){
					List<Map<String,String>> agentUserInfo = null;
					agentUserInfo = sqlSessionTemplate.selectList("common.mprq.selectQtdtAgentInfo", formData);
					LOGGER.debug("agentUserInfo.size() : {}", agentUserInfo.size());
					Map<String,String> mp = (Map<String,String>)agentUserInfo.get(0);
					formData.put("STOA_LIST_PRICE", CommonUtil.nvl(mp.get("STOA_LIST_PRICE"),""));
					formData.put("LEAD_TIME",CommonUtil.nvl(mp.get("LEAD_TIME"),""));
					formData.put("SEL_USER_ID",CommonUtil.nvl(mp.get("SEL_USER_ID"),""));
					formData.put("SEL_USER_NAME",CommonUtil.nvl(mp.get("SEL_USER_NAME"),""));
					formData.put("SEL_USER_TEL",CommonUtil.nvl(mp.get("SEL_USER_TEL"),""));
				}
				sqlSessionTemplate.update("common.mprq.insertAgentRound2", formData);
				// Update KEPRQDT
				if (_seq == 1){
					sqlSessionTemplate.update("common.mprq.updateRqdt2", formData);
					
					// 물질정보제출 취소 처리
					formData.put("st_cancel_note", "추가라운드");
					formData.put("USR_ID", formData.get("USER_ID"));
					formData.put("BUYER", formData.get("st_buyer_code"));
					formData.put("QUOTATION_NO", formData.get("st_quotation_no"));
					formData.put("QUOTATION_SEQ", formData.get("st_quotation_seq"));
					formData.put("REVISION", formData.get("st_revision"));
					
					sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
				}
				
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("추가라운드 요청중 오류가 발생되었습니다.");
		}
		return _rtnMsg;
	}
	// 협력사선정
		@SuppressWarnings("unchecked")
		public String saveAllAgentSel(Map<String,String>  formData, List<Object> gridData) {
			
			_rtnMsg = "정상적으로 처리되었습니다.";
			
			try{
				
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					//전략소싱팀 진행건.
					if(formData.get("SG_GBN").equals("SO")){
						if(formData.get("SG_KEP_YN").equals("Y")){
							// 각 협력사 낙찰 및 판매단가 지정
							sqlSessionTemplate.update("common.mprq.saveAllSoQTDT", formData);
						}else{
							if(formData.get("AGENT_CHECK").equals("1")){
								sqlSessionTemplate.update("common.mprq.saveAllRQDT", formData);
							}
							// 각 협력사 낙찰 및 판매단가 지정
							sqlSessionTemplate.update("common.mprq.saveAllPmQTDT", formData);
						}
					}else{
						if(formData.get("AGENT_CHECK").equals("1")){
							sqlSessionTemplate.update("common.mprq.saveAllRQDT", formData);
						}
						// 각 협력사 낙찰 및 판매단가 지정
						sqlSessionTemplate.update("common.mprq.saveAllQTDT", formData);						
					}

				}
				
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("저장에 실패하였습니다.");
			}
			return _rtnMsg;
		}
}
