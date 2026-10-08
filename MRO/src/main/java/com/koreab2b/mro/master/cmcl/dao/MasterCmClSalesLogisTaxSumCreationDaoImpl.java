package com.koreab2b.mro.master.cmcl.dao;

import java.util.ArrayList;
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

@Repository("masterCmClSalesLogisTaxSumCreationDao")
@Transactional
public class MasterCmClSalesLogisTaxSumCreationDaoImpl implements MasterCmClSalesLogisTaxSumCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesLogisTaxSumCreationDaoImpl.class);

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
		ResultRowHandler _resultHander = new ResultRowHandler();		
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesLogisTaxSumCreationList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
	    List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		ResultRowHandler _resultHander = new ResultRowHandler();		
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesLogisTaxSumCreationList_v2", param, _resultHander);
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
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation", formData);
				}
			}
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (합산)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
				Map<String, String[]> _keyAgentInfoMap = new HashMap<String, String[]>();
				Map<String, String> _keyAgentDeptAmtMap = new HashMap<String, String>();
				Map<String, String> _keyOrderNoMap = new HashMap<String, String>();
				Object[] _keyList;
				
				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수
				
				formData.putAll((Map<String, String>)gridData.get(0));
				
				String _buyer_nm_1 = ""; 
				for ( int i=0; i < gridData.size(); i++ ) {
					String _agent = ((Map<String, String>) gridData.get(i)).get("AGENT");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _agentIrsNo = ((Map<String, String>) gridData.get(i)).get("AGENT_IRS_NO");
					String _buyer = ((Map<String, String>) gridData.get(i)).get("BUYER");
					String exportYn = ((Map<String, String>) gridData.get(i)).get("EXPORT_YN");
					
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("LOGISTICS_AMT"));
					
					String _value = "";
					String[] _agentInfo = new String[5];
					_agentInfo[0] = String.valueOf(_thisAmt);
					_agentInfo[1] = _agentIrsNo;
					_agentInfo[2] = _buyer;
					_agentInfo[4] = exportYn;
					String _buyer_nm = ((Map<String, String>) gridData.get(i)).get("BUYER_NAME");
					
					LOGGER.debug("_buyer_nm ==>{}<==", _buyer_nm);
					// 협력사별 (합산금액, 사업자번호) 설정
					// SMART팀 국내/해외 구분 하여 생성					
					if ( !_keyAgentInfoMap.containsKey(_agent+exportYn) ) {
						LOGGER.debug("1 ==>{}<==", _buyer_nm);
						_buyer_nm_1 = "";
						_buyer_nm_1 = "물류비: "+_buyer_nm;
						_agentInfo[3] = "물류비: "+_buyer_nm;
						_keyAgentInfoMap.put(_agent+exportYn, _agentInfo);
					} else {
						LOGGER.debug("2 ==>{}<==", _buyer_nm);
						String[] _temp = (String[])_keyAgentInfoMap.get(_agent+exportYn);
						_agentInfo[0] = String.valueOf(Double.parseDouble(_temp[0]) + _thisAmt);
						_buyer_nm_1 +=  ","+ _buyer_nm;
						_agentInfo[3] =_buyer_nm_1;
						_keyAgentInfoMap.put(_agent+exportYn, _agentInfo);
					}
					LOGGER.debug("3 ==>{}<==", _agentInfo[3]);
					// 협력사+부서별 합산금액 설정
					if ( !_keyAgentDeptAmtMap.containsKey(_agent+_deptCode+exportYn) ) {
						_keyAgentDeptAmtMap.put(_agent+_deptCode+exportYn, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyAgentDeptAmtMap.get(_agent+_deptCode+exportYn);
						_keyAgentDeptAmtMap.put(_agent+_deptCode+exportYn, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				
				_keyList = _keyAgentDeptAmtMap.keySet().toArray();	// 협력사+부서별 합산금액 리스트
				
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				
				LOGGER.debug("===== first for start =====");
				String _beforeOrderNo ="";
				// 협력사+부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
					Map<String, String> _agentIrsInfoMap = new HashMap<String, String>();
					String _agentCode = String.valueOf(_keyList[i]).substring(0,10);
					String _deptCode = String.valueOf(_keyList[i]).substring(10,13);
					String exportYn = String.valueOf(_keyList[i]).substring(String.valueOf(_keyList[i]).length() - 1);
					String [] _agentInfo = (String[])_keyAgentInfoMap.get(_agentCode+exportYn);					
					String _agentIrsNo = _agentInfo[1];
					String _buyerCode = _agentInfo[2];
					double _suppPrice = Double.parseDouble(_keyAgentDeptAmtMap.get(_keyList[i]));
					double _taxPrice = Double.parseDouble(_keyAgentDeptAmtMap.get(_keyList[i])) * 0.1;
					double _totSuppPrice = Double.parseDouble(_agentInfo[0]);
					double _totTaxPrice = Double.parseDouble(_agentInfo[0]) * 0.1;

					formData.put("agent_code", _agentCode);
					formData.put("dept_code", _deptCode);
					formData.put("agent_irs_no", _agentIrsNo);
					formData.put("buyer_code", _buyerCode);
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					formData.put("tot_supp_price", String.valueOf(_totSuppPrice));
					formData.put("tot_tax_price", String.valueOf(_totTaxPrice));
					formData.put("exportYn", exportYn);

					LOGGER.debug("<<< i : {} >>>", i);
					LOGGER.debug("agent_code ==>{}<==", _agentCode);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("buyer_code ==>{}<==", _buyerCode);
					LOGGER.debug("supp_price ==>{}<==", _suppPrice);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					LOGGER.debug("tot_supp_price ==>{}<==", _totSuppPrice);
					LOGGER.debug("tot_tax_price ==>{}<==", _totTaxPrice);

					// 당사 정보 조회 및 파라메터 설정
					formData.put("com_code", formData.get("KEP_COM_CODE"));
					formData.put("irs_no", formData.get("KEP_IRS_NO"));
					LOGGER.debug("com_code ==>{}<==", formData.get("KEP_COM_CODE"));
					LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));

					_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectIrsInfoAP", formData);

					LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);

					formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
					formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));

					// 협력사 정보 조회 및 파라메터 설정
					formData.put("com_code", _agentCode);
					formData.put("irs_no", _agentInfo[1]);
					LOGGER.debug("com_code ==>{}<==", _agentCode);
					LOGGER.debug("irs_no ==>{}<==", _agentInfo[1]);

					_agentIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectIrsInfoAP", formData);

					LOGGER.debug("_agentIrsInfoMap ==>{}<==", _agentIrsInfoMap);

					formData.put("agent_irs_name", _agentIrsInfoMap.get("IRS_NAME"));
					formData.put("agent_ceo_name_loc", _agentIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("agent_industry_type", _agentIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("agent_business_items", _agentIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("agent_address_loc", _agentIrsInfoMap.get("ADDRESS_LOC"));					
					
				
					// 협력사별 세금계산서 번호 생성 여부 체크
					if ( !_keyOrderNoMap.containsKey(_agentCode+exportYn) ) {
						// 세금계산서 번호 생성
						_keyOrderNoMap.put(_agentCode+exportYn, String.valueOf(sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR")));
					} 
					
					formData.put("order_no", _keyOrderNoMap.get(_agentCode+exportYn));
					formData.put("item_desc", _agentInfo[3]); // 타이틀
					formData.put("tot_amt", String.valueOf(_totSuppPrice)); // 총금액
					formData.put("tot_amt_taxation", String.valueOf(_totSuppPrice)); // 과세대상 총금액
					
					String arChk = (String) sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoARcheck", formData);
					if (arChk.equals("0")) {
						// 세금계산서 품목정보 저장
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_KEPTITEM", formData);						
					}
					_beforeOrderNo = formData.get("order_no");
 
					// 매출 계산서 생성
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_BillCloseList", formData);

					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("AGENT").equals(_agentCode) && ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode)
							&& ((Map<String, String>)gridData.get(j)).get("EXPORT_YN").equals(exportYn)) {
							formData.put("key_buyer_code", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_gr_from_date", ((Map<String, String>)gridData.get(j)).get("GR_FROM_DATE"));
							formData.put("key_gr_to_date", ((Map<String, String>)gridData.get(j)).get("GR_TO_DATE"));

							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("order_no ==>{}<==", formData.get("order_no"));
							LOGGER.debug("dept_code ==>{}<==", formData.get("dept_code"));
							LOGGER.debug("agent_code ==>{}<==", formData.get("agent_code"));
							LOGGER.debug("key_kep_dept_code ==>{}<==", formData.get("key_kep_dept_code"));
							LOGGER.debug("key_buyer_code ==>{}<==", formData.get("key_buyer_code"));
							LOGGER.debug("key_gr_from_date ==>{}<==", formData.get("key_gr_from_date"));
							LOGGER.debug("key_gr_to_date ==>{}<==", formData.get("key_gr_to_date"));

							// 협력사별 입고정보 저장
							if(exportYn.equals("Y")) {
								int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation_ICOMGRDT_EXPORT", formData);
								if ( upCount == 0 ) {
									throw new RuntimeException("\n\n[ 물류비 세금계산서 생성(합산) 실패 ]");
								}
							} else {
								int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation_ICOMGRDT", formData);
								if ( upCount == 0 ) {
									throw new RuntimeException("\n\n[ 물류비 세금계산서 생성(합산) 실패 ]");
								}
							}
							
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
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
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation", formData);
				}
			}
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (합산)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
				Map<String, String[]> _keyAgentInfoMap = new HashMap<String, String[]>();
				Map<String, String> _keyAgentDeptAmtMap = new HashMap<String, String>();
				Map<String, String> _keyOrderNoMap = new HashMap<String, String>();
				Object[] _keyList;
				
				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수
				
				formData.putAll((Map<String, String>)gridData.get(0));
				
				String _buyer_nm_1 = ""; 
				for ( int i=0; i < gridData.size(); i++ ) {
					String _agent = ((Map<String, String>) gridData.get(i)).get("AGENT");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _agentIrsNo = ((Map<String, String>) gridData.get(i)).get("AGENT_IRS_NO");
					String _buyer = ((Map<String, String>) gridData.get(i)).get("BUYER");
					String exportYn = ((Map<String, String>) gridData.get(i)).get("EXPORT_YN");
					
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("LOGISTICS_AMT"));
					
					String _value = "";
					String[] _agentInfo = new String[5];
					_agentInfo[0] = String.valueOf(_thisAmt);
					_agentInfo[1] = _agentIrsNo;
					_agentInfo[2] = _buyer;
					_agentInfo[4] = exportYn;
					String _buyer_nm = ((Map<String, String>) gridData.get(i)).get("BUYER_NAME");
					
					LOGGER.debug("_buyer_nm ==>{}<==", _buyer_nm);
					// 협력사별 (합산금액, 사업자번호) 설정
					// SMART팀 국내/해외 구분 하여 생성					
					if ( !_keyAgentInfoMap.containsKey(_agent+exportYn) ) {
						LOGGER.debug("1 ==>{}<==", _buyer_nm);
						_buyer_nm_1 = "";
						_buyer_nm_1 = "물류비: "+_buyer_nm;
						_agentInfo[3] = "물류비: "+_buyer_nm;
						_keyAgentInfoMap.put(_agent+exportYn, _agentInfo);
					} else {
						LOGGER.debug("2 ==>{}<==", _buyer_nm);
						String[] _temp = (String[])_keyAgentInfoMap.get(_agent+exportYn);
						_agentInfo[0] = String.valueOf(Double.parseDouble(_temp[0]) + _thisAmt);
						_buyer_nm_1 +=  ","+ _buyer_nm;
						_agentInfo[3] =_buyer_nm_1;
						_keyAgentInfoMap.put(_agent+exportYn, _agentInfo);
					}
					LOGGER.debug("3 ==>{}<==", _agentInfo[3]);
					// 협력사+부서별 합산금액 설정
					if ( !_keyAgentDeptAmtMap.containsKey(_agent+_deptCode+exportYn) ) {
						_keyAgentDeptAmtMap.put(_agent+_deptCode+exportYn, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyAgentDeptAmtMap.get(_agent+_deptCode+exportYn);
						_keyAgentDeptAmtMap.put(_agent+_deptCode+exportYn, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				
				_keyList = _keyAgentDeptAmtMap.keySet().toArray();	// 협력사+부서별 합산금액 리스트
				
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				
				LOGGER.debug("===== first for start =====");
				String _beforeOrderNo ="";
				// 협력사+부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
					Map<String, String> _agentIrsInfoMap = new HashMap<String, String>();
					String _agentCode = String.valueOf(_keyList[i]).substring(0,10);
					String _deptCode = String.valueOf(_keyList[i]).substring(10,13);
					String exportYn = String.valueOf(_keyList[i]).substring(String.valueOf(_keyList[i]).length() - 1);
					String [] _agentInfo = (String[])_keyAgentInfoMap.get(_agentCode+exportYn);					
					String _agentIrsNo = _agentInfo[1];
					String _buyerCode = _agentInfo[2];
					double _suppPrice = Double.parseDouble(_keyAgentDeptAmtMap.get(_keyList[i]));
					double _taxPrice = Double.parseDouble(_keyAgentDeptAmtMap.get(_keyList[i])) * 0.1;
					double _totSuppPrice = Double.parseDouble(_agentInfo[0]);
					double _totTaxPrice = Double.parseDouble(_agentInfo[0]) * 0.1;

					formData.put("agent_code", _agentCode);
					formData.put("dept_code", _deptCode);
					formData.put("agent_irs_no", _agentIrsNo);
					formData.put("buyer_code", _buyerCode);
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					formData.put("tot_supp_price", String.valueOf(_totSuppPrice));
					formData.put("tot_tax_price", String.valueOf(_totTaxPrice));
					formData.put("exportYn", exportYn);

					LOGGER.debug("<<< i : {} >>>", i);
					LOGGER.debug("agent_code ==>{}<==", _agentCode);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("buyer_code ==>{}<==", _buyerCode);
					LOGGER.debug("supp_price ==>{}<==", _suppPrice);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					LOGGER.debug("tot_supp_price ==>{}<==", _totSuppPrice);
					LOGGER.debug("tot_tax_price ==>{}<==", _totTaxPrice);

					// 당사 정보 조회 및 파라메터 설정
					formData.put("com_code", formData.get("KEP_COM_CODE"));
					formData.put("irs_no", formData.get("KEP_IRS_NO"));
					LOGGER.debug("com_code ==>{}<==", formData.get("KEP_COM_CODE"));
					LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));

					_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectIrsInfoAP", formData);

					LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);

					formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
					formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));

					// 협력사 정보 조회 및 파라메터 설정
					formData.put("com_code", _agentCode);
					formData.put("irs_no", _agentInfo[1]);
					LOGGER.debug("com_code ==>{}<==", _agentCode);
					LOGGER.debug("irs_no ==>{}<==", _agentInfo[1]);

					_agentIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectIrsInfoAP", formData);

					LOGGER.debug("_agentIrsInfoMap ==>{}<==", _agentIrsInfoMap);

					formData.put("agent_irs_name", _agentIrsInfoMap.get("IRS_NAME"));
					formData.put("agent_ceo_name_loc", _agentIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("agent_industry_type", _agentIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("agent_business_items", _agentIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("agent_address_loc", _agentIrsInfoMap.get("ADDRESS_LOC"));					
					
				
					// 협력사별 세금계산서 번호 생성 여부 체크
					if ( !_keyOrderNoMap.containsKey(_agentCode+exportYn) ) {
						// 세금계산서 번호 생성
						_keyOrderNoMap.put(_agentCode+exportYn, String.valueOf(sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR")));
					} 
					
					formData.put("order_no", _keyOrderNoMap.get(_agentCode+exportYn));
					formData.put("item_desc", _agentInfo[3]); // 타이틀
					formData.put("tot_amt", String.valueOf(_totSuppPrice)); // 총금액
					formData.put("tot_amt_taxation", String.valueOf(_totSuppPrice)); // 과세대상 총금액
					
					String arChk = (String) sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoARcheck", formData);
					if (arChk.equals("0")) {
						// 세금계산서 품목정보 저장
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_KEPTITEM", formData);						
					}
					_beforeOrderNo = formData.get("order_no");
 
					// 매출 계산서 생성
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisTaxSumCreation_BillCloseList", formData);

					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("AGENT").equals(_agentCode) && ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode)
							&& ((Map<String, String>)gridData.get(j)).get("EXPORT_YN").equals(exportYn)) {
							formData.put("key_buyer_code", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_inv_from_date", ((Map<String, String>)gridData.get(j)).get("INV_FROM_DATE"));
							formData.put("key_inv_to_date", ((Map<String, String>)gridData.get(j)).get("INV_TO_DATE"));

							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("order_no ==>{}<==", formData.get("order_no"));
							LOGGER.debug("dept_code ==>{}<==", formData.get("dept_code"));
							LOGGER.debug("agent_code ==>{}<==", formData.get("agent_code"));
							LOGGER.debug("key_kep_dept_code ==>{}<==", formData.get("key_kep_dept_code"));
							LOGGER.debug("key_buyer_code ==>{}<==", formData.get("key_buyer_code"));
							LOGGER.debug("key_inv_from_date ==>{}<==", formData.get("key_inv_from_date"));
							LOGGER.debug("key_inv_to_date ==>{}<==", formData.get("key_inv_to_date"));

							// 협력사별 입고정보 저장
							if(exportYn.equals("Y")) {
								int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation_ICOMIVDT_EXPORT_v2", formData);
								if ( upCount == 0 ) {
									throw new RuntimeException("\n\n[ 물류비 세금계산서 생성(합산) 실패 ]");
								}
							} else {
								int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisTaxSumCreation_ICOMIVDT_v2", formData);
								if ( upCount == 0 ) {
									throw new RuntimeException("\n\n[ 물류비 세금계산서 생성(합산) 실패 ]");
								}
							}
							
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return _rtnMsg;
	}
	// 미마감
	@SuppressWarnings("unchecked")
	public String saveMasterCmClSalesLogisNotClose(Map<String,String>  formData, List<Object> gridData) {
		
		try {

				_rtnMsg = "물류비 미마감 처리 되었습니다.";
				
				Map<String, String> _keyAgentDeptAmtMap = new HashMap<String, String>();
				Object[] _keyList;
				
				
				formData.putAll((Map<String, String>)gridData.get(0));
				for ( int i=0; i < gridData.size(); i++ ) {
					String _agent = ((Map<String, String>) gridData.get(i)).get("AGENT");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _agentIrsNo = ((Map<String, String>) gridData.get(i)).get("AGENT_IRS_NO");
					String _buyer = ((Map<String, String>) gridData.get(i)).get("BUYER");
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("LOGISTICS_AMT"));
					String _value = "";
					String[] _agentInfo = new String[4];
					_agentInfo[0] = String.valueOf(_thisAmt);
					_agentInfo[1] = _agentIrsNo;
					_agentInfo[2] = _buyer;
					// 협력사+부서별 합산금액 설정
					if ( !_keyAgentDeptAmtMap.containsKey(_agent+_deptCode) ) {
						_keyAgentDeptAmtMap.put(_agent+_deptCode, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyAgentDeptAmtMap.get(_agent+_deptCode);
						_keyAgentDeptAmtMap.put(_agent+_deptCode, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				_keyList = _keyAgentDeptAmtMap.keySet().toArray();	// 협력사+부서별 합산금액 리스트
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				LOGGER.debug("===== first for start =====");
				// 협력사+부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					String _agentCode = String.valueOf(_keyList[i]).substring(0,10);
					String _deptCode = String.valueOf(_keyList[i]).substring(10,13);
					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("AGENT").equals(_agentCode) && ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode) ) {
							formData.put("key_buyer_code", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_gr_from_date", ((Map<String, String>)gridData.get(j)).get("GR_FROM_DATE"));
							formData.put("key_gr_to_date", ((Map<String, String>)gridData.get(j)).get("GR_TO_DATE"));
							formData.put("agent_code", _agentCode);
							formData.put("dept_code", _deptCode);
							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("dept_code ==>{}<==", formData.get("dept_code"));
							LOGGER.debug("agent_code ==>{}<==", formData.get("agent_code"));
							LOGGER.debug("key_kep_dept_code ==>{}<==", formData.get("key_kep_dept_code"));
							LOGGER.debug("key_buyer_code ==>{}<==", formData.get("key_buyer_code"));
							LOGGER.debug("key_gr_from_date ==>{}<==", formData.get("key_gr_from_date"));
							LOGGER.debug("key_gr_to_date ==>{}<==", formData.get("key_gr_to_date"));

							// 협력사별 입고정보 저장
							int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisNotClose", formData);
							if ( upCount == 0 ) {
								throw new RuntimeException("\n\n[ 물류비 미마감 처리 실패 ]");
							}
						}
					}
				}

			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String saveMasterCmClSalesLogisNotClose_v2(Map<String,String>  formData, List<Object> gridData) {
		
		try {

				_rtnMsg = "물류비 미마감 처리 되었습니다.";
				
				Map<String, String> _keyAgentDeptAmtMap = new HashMap<String, String>();
				Object[] _keyList;
				
				
				formData.putAll((Map<String, String>)gridData.get(0));
				for ( int i=0; i < gridData.size(); i++ ) {
					String _agent = ((Map<String, String>) gridData.get(i)).get("AGENT");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _agentIrsNo = ((Map<String, String>) gridData.get(i)).get("AGENT_IRS_NO");
					String _buyer = ((Map<String, String>) gridData.get(i)).get("BUYER");
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("LOGISTICS_AMT"));
					String _value = "";
					String[] _agentInfo = new String[4];
					_agentInfo[0] = String.valueOf(_thisAmt);
					_agentInfo[1] = _agentIrsNo;
					_agentInfo[2] = _buyer;
					// 협력사+부서별 합산금액 설정
					if ( !_keyAgentDeptAmtMap.containsKey(_agent+_deptCode) ) {
						_keyAgentDeptAmtMap.put(_agent+_deptCode, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyAgentDeptAmtMap.get(_agent+_deptCode);
						_keyAgentDeptAmtMap.put(_agent+_deptCode, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				_keyList = _keyAgentDeptAmtMap.keySet().toArray();	// 협력사+부서별 합산금액 리스트
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				LOGGER.debug("===== first for start =====");
				// 협력사+부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					String _agentCode = String.valueOf(_keyList[i]).substring(0,10);
					String _deptCode = String.valueOf(_keyList[i]).substring(10,13);
					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("AGENT").equals(_agentCode) && ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode) ) {
							formData.put("key_buyer_code", ((Map<String, String>)gridData.get(j)).get("BUYER"));
							formData.put("key_inv_from_date", ((Map<String, String>)gridData.get(j)).get("INV_FROM_DATE"));
							formData.put("key_inv_to_date", ((Map<String, String>)gridData.get(j)).get("INV_TO_DATE"));
							formData.put("agent_code", _agentCode);
							formData.put("dept_code", _deptCode);
							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("dept_code ==>{}<==", formData.get("dept_code"));
							LOGGER.debug("agent_code ==>{}<==", formData.get("agent_code"));
							LOGGER.debug("key_kep_dept_code ==>{}<==", formData.get("key_kep_dept_code"));
							LOGGER.debug("key_buyer_code ==>{}<==", formData.get("key_buyer_code"));
							LOGGER.debug("key_inv_from_date ==>{}<==", formData.get("key_inv_from_date"));
							LOGGER.debug("key_inv_to_date ==>{}<==", formData.get("key_inv_to_date"));

							// 협력사별 입고정보 저장
							int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisNotClose_v2", formData);
							if ( upCount == 0 ) {
								throw new RuntimeException("\n\n[ 물류비 미마감 처리 실패 ]");
							}
						}
					}
				}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return _rtnMsg;
	}

}
