package com.koreab2b.mro.master.cmcl.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClPurchaseTaxsheetIndividualCreationDao")
@Transactional
public class MasterCmClPurchaseTaxsheetIndividualCreationDaoImpl implements MasterCmClPurchaseTaxsheetIndividualCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClPurchaseTaxsheetIndividualCreationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClPurchaseTaxsheetIndividualCreationList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClPurchaseTaxsheetIndividualCreationList_v2", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		try {
			String _jobKind = formData.get("job_kind");
			
			// 저장 처리
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "팀구분 수정이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIndividualCreation", formData);
				}
			} 
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (건별)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
//				Map<String, String> grAgentAmtMap		= new HashMap<String, String>();	// 공급사 총합계금액		==> 공급사코드          	 , 세금계산서 총 금액
				Map<String, String> grTotAmtMap			= new HashMap<String, String>();	// 세금계산서총합계금액	==> 공급사코드+부서코드 , 세금계산서 총 금액
				Map<String, String> grAmtMap				= new HashMap<String, String>();	// 부서합계금액				==> 공급사코드+부서코드 , 입고금액
//				Map<String, String> grKeyMap				= new HashMap<String, String>();	// GR Key 값					==> 공급사코드+부서코드 , 입고키값
				Map<String, String> grDeptMAP				= new HashMap<String, String>();	// 부서코드					==> 공급사코드+부서코드 , 부서코드
				Map<String, String> grAgentMAP			= new HashMap<String, String>();	// 공급사코드				==> 공급사코드+부서코드 , 공급사코드
//				Map<String, String> taxNoMAP				= new HashMap<String, String>();	// 계산서번호				==> 공급사코드+부서코드 , 세금계산서번호
				Map<String, String> grAgentIrsNoMAP		= new HashMap<String, String>();	// 공급사 사업자번호		==> 공급사코드+부서코드 , 공급사 사업자번호
				Map<String, String> grAgentNameMAP	= new HashMap<String, String>();	// 공급사 명					==> 공급사코드+부서코드 , 공급사 명
//				Map<String, String> grSafetyKeyMap		= new HashMap<String, String>();	// 건설MRO 구매대행 GR KEY 값
//				Map<String, String> grntsFlagMAP			= new HashMap<String, String>();	// 국세청전송여부
				Map<String, String> grAmtTaxtaionMap = new HashMap<String, String>(); // 세금계산서 총 과세대상 합계금액
				Map<String, String> grTotAmtTaxtaionMap = new HashMap<String, String>(); // 부서 과세대상 합계금액
				
//				String prev_agent   = "";
//				String returnValue	= "";
//				String tax_bill_no	= "";
				String value 			= "";
				double _totAmt		= 0;
				
				
				
				String value1 = ""; // 과세대상금액 산출용
				double _totAmt_taxation = 0;
				String buyerName = "";
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					double _thisAmt = Double.parseDouble(formData.get("GR_AMT"));
					double _thisAmt2 = Double.parseDouble(formData.get("GR_AMT"));

					String agentName	= formData.get("AGENT_NAME");
					String agentIrsNo	= formData.get("AGENT_IRS_NO");
					String agent			= formData.get("AGENT");
					String deptCode		= formData.get("KEP_DEPT");
//					String nts_flag		= formData.get("NTS_SEND_FLAG");
					String apdtKey		= agent + deptCode;

					String _taxType = formData.get("TAX_TYPE");
					
					// 협력사(세금계산서 번호 단위)별 총 합계 금액 계산(오류 있는 로직임..ㅡㅡㅋ)
//					if ( !prev_agent.equals(agent) ) {
//						// 세금계산서 번호 생성
//						tax_bill_no = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAP");
//						prev_agent = agent;
//
//						_totAmt = _thisAmt;
//					} else {
//						_totAmt = _totAmt + _thisAmt;
//					}
					if(buyerName.indexOf(formData.get("BUYER_NM")) == -1){
						if(buyerName == ""){
							buyerName = "MRO용품외: "+formData.get("BUYER_NM");
						}else{
							buyerName += ","+formData.get("BUYER_NM");
						}
					}
					_totAmt = _totAmt + _thisAmt;

					if(_taxType.equals("11") || _taxType.equals("")){
						_totAmt_taxation = _totAmt_taxation + _thisAmt;
					}else{
						_thisAmt2 = 0;
					}
					
					grTotAmtMap.put(agent, String.valueOf(_totAmt)); // 총금액
					grTotAmtTaxtaionMap.put(agent, String.valueOf(_totAmt_taxation)); // 과세대상 총금액
					
//					if ( i == 0 ) {
//						prev_agent = agent;
//					}

//					grntsFlagMAP.put(apdtKey, nts_flag);
					
					// 협력사+부서 단위 합계 금액 계산 및 입력정보 저장
					if ( !grAmtMap.containsKey(apdtKey) ) {
						grAmtMap.put(apdtKey, String.valueOf(_thisAmt));
						grAmtTaxtaionMap.put(apdtKey, String.valueOf(_totAmt_taxation));
//						grKeyMap.put(apdtKey,grKey); //-- Query Key Value
//						grSafetyKeyMap.put(apdtKey,grSafetyKey);  //--

						grDeptMAP.put(apdtKey, deptCode);				
						grAgentMAP.put(apdtKey, agent);				
//						taxNoMAP.put(apdtKey, tax_bill_no);				
						grAgentIrsNoMAP.put(apdtKey, agentIrsNo);				
						grAgentNameMAP.put(apdtKey, agentName);				
					} else {
						value				= (String)grAmtMap.get(apdtKey);
						value1			= (String)grAmtTaxtaionMap.get(apdtKey);
//						grValue			= (StringBuffer)grKeyMap.get(apdtKey);
//						grSafetyValue	= (StringBuffer)grSafetyKeyMap.get(apdtKey);
						grAmtMap.put(apdtKey, String.valueOf(Double.parseDouble(value) + _thisAmt));
						grAmtTaxtaionMap.put(apdtKey, String.valueOf(Double.parseDouble(value1) + _thisAmt2));
//						grKeyMap.put(apdtKey,grValue.append(grKey.toString()));
//						grSafetyKeyMap.put(apdtKey,grSafetyValue.append(grSafetyKey.toString()));
					}
				}
				formData.put("item_desc", buyerName); // 타이틀
				formData.put("tot_amt", String.valueOf(_totAmt)); // 총금액
				formData.put("tot_amt_taxation", String.valueOf(_totAmt_taxation)); // 과세대상 총금액
				Object[] keyList = grAmtMap.keySet().toArray(); // 협력사+부서별 합산금액 리스트
				
				// 세금계산서 번호 생성
				String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAP");
				formData.put("order_no", _orderNo);
				
				// 세금계산서 품목정보 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_KEPTITEM", formData);
				
				LOGGER.debug("===== first for start =====");
				// (KEPTAPDT) 매입 세금계산서 입력 수 만큼 반복 작업
				for ( int i=0; i< keyList.length; i++ ) {
					double _totSuppPrice = Double.parseDouble(grTotAmtMap.get(String.valueOf(grAgentMAP.get(keyList[i]))));
					// 과세 대상금액만 세액 계산
					double _totTaxPrice  = Double.parseDouble(grTotAmtTaxtaionMap.get(String.valueOf(grAgentMAP.get(keyList[i])))) * 0.1;
					
					double _suppPrice = Double.parseDouble(grAmtMap.get(keyList[i]));
					// 과세 대상금액만 세액 계산
					double _taxPrice  = Double.parseDouble(grAmtTaxtaionMap.get(keyList[i])) * 0.1;
					
					formData.put("tot_supp_price", String.valueOf(_totSuppPrice));
					formData.put("tot_tax_price", String.valueOf(_totTaxPrice));
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					
					String _deptCode = String.valueOf(grDeptMAP.get(keyList[i]));
					String _agentName = String.valueOf(grAgentNameMAP.get(keyList[i]));
					String _agentIrsNo = String.valueOf(grAgentIrsNoMAP.get(keyList[i]));
					String _agentCode = String.valueOf(grAgentMAP.get(keyList[i]));
//					String _ntsFlag = String.valueOf(grntsFlagMAP.get(keyList[i]));
					
					formData.put("dept_code", _deptCode);
					formData.put("agent_name", _agentName);
					formData.put("agent_irs_no", _agentIrsNo);
					formData.put("agent_code", _agentCode);
//					formData.put("nts_flag", _ntsFlag);
					
					// 외상매입_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_KEPTAPDT", formData);
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_BillCloseList", formData);
					
					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode) ) {
							formData.put("key_buyer", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_gr_no", ((Map<String, String>)gridData.get(j)).get("GR_NO"));
							formData.put("key_gr_seq", ((Map<String, String>)gridData.get(j)).get("GR_SEQ"));
							
							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("key_buyer ==>{}<==", formData.get("key_buyer"));
							LOGGER.debug("key_gr_no ==>{}<==", formData.get("key_gr_no"));
							LOGGER.debug("key_gr_seq ==>{}<==", formData.get("key_gr_seq"));
							
							// 구매사별 입고정보 저장
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIndividualCreation_ICOMGRDT", formData);
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 작업 오류 발생 [\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		try {
			String _jobKind = formData.get("job_kind");
			
			// 저장 처리
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "팀구분 수정이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIndividualCreation_v2", formData);
				}
			} 
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (건별)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
//				Map<String, String> grAgentAmtMap		= new HashMap<String, String>();	// 공급사 총합계금액		==> 공급사코드          	 , 세금계산서 총 금액
				Map<String, String> grTotAmtMap			= new HashMap<String, String>();	// 세금계산서총합계금액	==> 공급사코드+부서코드 , 세금계산서 총 금액
				Map<String, String> grAmtMap				= new HashMap<String, String>();	// 부서합계금액				==> 공급사코드+부서코드 , 입고금액
//				Map<String, String> grKeyMap				= new HashMap<String, String>();	// GR Key 값					==> 공급사코드+부서코드 , 입고키값
				Map<String, String> grDeptMAP				= new HashMap<String, String>();	// 부서코드					==> 공급사코드+부서코드 , 부서코드
				Map<String, String> grAgentMAP			= new HashMap<String, String>();	// 공급사코드				==> 공급사코드+부서코드 , 공급사코드
//				Map<String, String> taxNoMAP				= new HashMap<String, String>();	// 계산서번호				==> 공급사코드+부서코드 , 세금계산서번호
				Map<String, String> grAgentIrsNoMAP		= new HashMap<String, String>();	// 공급사 사업자번호		==> 공급사코드+부서코드 , 공급사 사업자번호
				Map<String, String> grAgentNameMAP	= new HashMap<String, String>();	// 공급사 명					==> 공급사코드+부서코드 , 공급사 명
//				Map<String, String> grSafetyKeyMap		= new HashMap<String, String>();	// 건설MRO 구매대행 GR KEY 값
//				Map<String, String> grntsFlagMAP			= new HashMap<String, String>();	// 국세청전송여부
				Map<String, String> grAmtTaxtaionMap = new HashMap<String, String>(); // 세금계산서 총 과세대상 합계금액
				Map<String, String> grTotAmtTaxtaionMap = new HashMap<String, String>(); // 부서 과세대상 합계금액
				
//				String prev_agent   = "";
//				String returnValue	= "";
//				String tax_bill_no	= "";
				String value 			= "";
				double _totAmt		= 0;
				
				
				
				String value1 = ""; // 과세대상금액 산출용
				double _totAmt_taxation = 0;
				String buyerName = "";
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					double _thisAmt = Double.parseDouble(formData.get("INV_AMT"));
					double _thisAmt2 = Double.parseDouble(formData.get("INV_AMT"));

					String agentName	= formData.get("AGENT_NAME");
					String agentIrsNo	= formData.get("AGENT_IRS_NO");
					String agent			= formData.get("AGENT");
					String deptCode		= formData.get("KEP_DEPT");
//					String nts_flag		= formData.get("NTS_SEND_FLAG");
					String apdtKey		= agent + deptCode;

					String _taxType = formData.get("TAX_TYPE");
					
					// 협력사(세금계산서 번호 단위)별 총 합계 금액 계산(오류 있는 로직임..ㅡㅡㅋ)
//					if ( !prev_agent.equals(agent) ) {
//						// 세금계산서 번호 생성
//						tax_bill_no = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAP");
//						prev_agent = agent;
//
//						_totAmt = _thisAmt;
//					} else {
//						_totAmt = _totAmt + _thisAmt;
//					}
					if(buyerName.indexOf(formData.get("BUYER_NM")) == -1){
						if(buyerName == ""){
							buyerName = "MRO용품외: "+formData.get("BUYER_NM");
						}else{
							buyerName += ","+formData.get("BUYER_NM");
						}
					}
					_totAmt = _totAmt + _thisAmt;

					if(_taxType.equals("11") || _taxType.equals("")){
						_totAmt_taxation = _totAmt_taxation + _thisAmt;
					}else{
						_thisAmt2 = 0;
					}
					
					grTotAmtMap.put(agent, String.valueOf(_totAmt)); // 총금액
					grTotAmtTaxtaionMap.put(agent, String.valueOf(_totAmt_taxation)); // 과세대상 총금액
					
//					if ( i == 0 ) {
//						prev_agent = agent;
//					}

//					grntsFlagMAP.put(apdtKey, nts_flag);
					
					// 협력사+부서 단위 합계 금액 계산 및 입력정보 저장
					if ( !grAmtMap.containsKey(apdtKey) ) {
						grAmtMap.put(apdtKey, String.valueOf(_thisAmt));
						grAmtTaxtaionMap.put(apdtKey, String.valueOf(_totAmt_taxation));
//						grKeyMap.put(apdtKey,grKey); //-- Query Key Value
//						grSafetyKeyMap.put(apdtKey,grSafetyKey);  //--

						grDeptMAP.put(apdtKey, deptCode);				
						grAgentMAP.put(apdtKey, agent);				
//						taxNoMAP.put(apdtKey, tax_bill_no);				
						grAgentIrsNoMAP.put(apdtKey, agentIrsNo);				
						grAgentNameMAP.put(apdtKey, agentName);				
					} else {
						value				= (String)grAmtMap.get(apdtKey);
						value1			= (String)grAmtTaxtaionMap.get(apdtKey);
//						grValue			= (StringBuffer)grKeyMap.get(apdtKey);
//						grSafetyValue	= (StringBuffer)grSafetyKeyMap.get(apdtKey);
						grAmtMap.put(apdtKey, String.valueOf(Double.parseDouble(value) + _thisAmt));
						grAmtTaxtaionMap.put(apdtKey, String.valueOf(Double.parseDouble(value1) + _thisAmt2));
//						grKeyMap.put(apdtKey,grValue.append(grKey.toString()));
//						grSafetyKeyMap.put(apdtKey,grSafetyValue.append(grSafetyKey.toString()));
					}
				}
				formData.put("item_desc", buyerName); // 타이틀
				formData.put("tot_amt", String.valueOf(_totAmt)); // 총금액
				formData.put("tot_amt_taxation", String.valueOf(_totAmt_taxation)); // 과세대상 총금액
				Object[] keyList = grAmtMap.keySet().toArray(); // 협력사+부서별 합산금액 리스트
				
				// 세금계산서 번호 생성
				String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAP");
				formData.put("order_no", _orderNo);
				
				// 세금계산서 품목정보 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_KEPTITEM", formData);
				
				LOGGER.debug("===== first for start =====");
				// (KEPTAPDT) 매입 세금계산서 입력 수 만큼 반복 작업
				for ( int i=0; i< keyList.length; i++ ) {
					double _totSuppPrice = Double.parseDouble(grTotAmtMap.get(String.valueOf(grAgentMAP.get(keyList[i]))));
					// 과세 대상금액만 세액 계산
					double _totTaxPrice  = Double.parseDouble(grTotAmtTaxtaionMap.get(String.valueOf(grAgentMAP.get(keyList[i])))) * 0.1;
					
					double _suppPrice = Double.parseDouble(grAmtMap.get(keyList[i]));
					// 과세 대상금액만 세액 계산
					double _taxPrice  = Double.parseDouble(grAmtTaxtaionMap.get(keyList[i])) * 0.1;
					
					formData.put("tot_supp_price", String.valueOf(_totSuppPrice));
					formData.put("tot_tax_price", String.valueOf(_totTaxPrice));
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					
					String _deptCode = String.valueOf(grDeptMAP.get(keyList[i]));
					String _agentName = String.valueOf(grAgentNameMAP.get(keyList[i]));
					String _agentIrsNo = String.valueOf(grAgentIrsNoMAP.get(keyList[i]));
					String _agentCode = String.valueOf(grAgentMAP.get(keyList[i]));
//					String _ntsFlag = String.valueOf(grntsFlagMAP.get(keyList[i]));
					
					formData.put("dept_code", _deptCode);
					formData.put("agent_name", _agentName);
					formData.put("agent_irs_no", _agentIrsNo);
					formData.put("agent_code", _agentCode);
//					formData.put("nts_flag", _ntsFlag);
					
					// 외상매입_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_KEPTAPDT", formData);
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClPurchaseTaxsheetIndividualCreation_BillCloseList", formData);
					
					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode) ) {
							formData.put("key_buyer", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_inv_no", ((Map<String, String>)gridData.get(j)).get("INV_NO"));
							formData.put("key_inv_seq", ((Map<String, String>)gridData.get(j)).get("INV_SEQ"));
							
							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("key_buyer ==>{}<==", formData.get("key_buyer"));
							LOGGER.debug("key_inv_no ==>{}<==", formData.get("key_inv_no"));
							LOGGER.debug("key_inv_seq ==>{}<==", formData.get("key_inv_seq"));
							
							// 구매사별 입고정보 저장
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIndividualCreation_ICOMIVDT_v2", formData);
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 작업 오류 발생 [\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
//	@SuppressWarnings("unchecked")
//	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
//	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		
//		_rtnMsg = "삭제완료";
//		
//		try{
//			for(int i=0; i < gridData.size(); i++){
//				formData.putAll((Map<String, String>)gridData.get(i));		
//				
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClPurchaseTaxsheetIndividualCreation", formData);
//				LOGGER.error("deleteMasterCmClPurchaseTaxsheetIndividualCreation 실행 완료");
//
//			}
//		}catch(Exception e){
//			LOGGER.error("SQL ERROR : ", e);
//			throw new RuntimeException("견적 요청에 실패하였습니다.");
//		}
//
//		return _rtnMsg;		
//	}	

}
