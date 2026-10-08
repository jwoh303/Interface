package com.koreab2b.mro.common.mprq.dao;

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

@Repository("masterMpRqSellerChoicePopDao")
@Transactional
public class MasterMpRqSellerChoicePopDaoImpl implements MasterMpRqSellerChoicePopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqSellerChoicePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		List< String > _list = new ArrayList< String >( );
		formData.put("st_agent_listArr", "");
		_list = CommonUtil.getStringArrary((String) formData.get("st_agent_list"),"__N@@");
		if(_list.size() > 0){
			formData.put("st_agent_listArr", _list);
		} 
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoicePopList", formData);
	}
	
	// 비고 조회
	public List<Map<String,String>> selectListRemark(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqSellerChoiceRemarkPopList", formData);
	}
	
	// 추가라운드 요청
	@SuppressWarnings("unchecked")
	public String saveAgentRoundReq(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 추가라운드 요청되었습니다.";
		try{
			// Get next AGENT_REVISION */
			Map<String,String> _result = sqlSessionTemplate.selectOne("common.mprq.selectRevision", formData);
			if (String.valueOf(_result.get("AGENT_REVISION")).equals("0")){
				_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
				throw new RuntimeException(_rtnMsg);
			}
			formData.put("PRE_AGENT_REVISION", String.valueOf(_result.get("PRE_AGENT_REVISION")));
			formData.put("AGENT_REVISION", String.valueOf(_result.get("AGENT_REVISION")));

			// Check KEPQTDT Insert Condition
			Map<String,String> _chkFlag = sqlSessionTemplate.selectOne("common.mprq.selectChkFlag", formData);
			if (String.valueOf(_chkFlag.get("CHK_FLAG")).equals("Y")){
				sqlSessionTemplate.update("common.mprq.updateChkFlag", formData);
			} else {
				_rtnMsg = "추가라운드 대상이 아닙니다.";
				throw new RuntimeException(_rtnMsg);
			}
			// 협력사별 데이터 생성
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
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
				
				sqlSessionTemplate.update("common.mprq.insertAgentRound", formData);
			}
			// Update KEPRQDT
			sqlSessionTemplate.update("common.mprq.updateRqdt", formData);

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("추가라운드 요청중 오류가 발생되었습니다.");
		}
		return _rtnMsg;
	}
	
}
