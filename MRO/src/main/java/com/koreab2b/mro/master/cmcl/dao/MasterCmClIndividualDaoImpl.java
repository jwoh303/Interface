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

@Repository("masterCmClIndividualDao")
@Transactional
public class MasterCmClIndividualDaoImpl implements MasterCmClIndividualDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClIndividualDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 마감차수 조회
	public List<Map<String,String>> selectCloseMonthList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.cmcl.selectCloseMonthList", param);
	}
	
	// 리스트 조회
	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_dept_code"),"@");
		if(_list.size() > 0){
			param.put("st_deptArr", _list);
		}
		
		sqlSessionTemplate.select("master.cmcl.selectMasterCmClIndividualList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		return resultList;
	}
	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_dept_code"),"@");
		if(_list.size() > 0){
			param.put("st_deptArr", _list);
		}
		
		sqlSessionTemplate.select("master.cmcl.selectMasterCmClIndividualList_v2", param, _resultHander);
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
				_rtnMsg = "저장이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					formData.put("KEP_DEPT", ((Map<String, String>)gridData.get(i)).get("KEP_DEPT"));
					formData.put("KEP_DEPT_OLD", ((Map<String, String>)gridData.get(i)).get("KEP_DEPT_OLD"));
					formData.put("GR_DATE", ((Map<String, String>)gridData.get(i)).get("GR_DATE"));
					formData.put("GR_DATE_OLD", ((Map<String, String>)gridData.get(i)).get("GR_DATE_OLD"));
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClIndividual", formData);
				}
			}
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (건별)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";

				Map<String, String> _keyDeptAmtMap = new HashMap<String, String>();
				Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
				Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
//				String _closeRevision = "";
				Object[] _keyList;
				double _totAmt = 0;
				
//				String _issueDate = formData.get("issue_date");
//				LOGGER.debug("_issueDate ==>{}<==", _issueDate);
				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수
				
				formData.putAll((Map<String, String>)gridData.get(0));
								
				for ( int i=0; i < gridData.size(); i++ ) {
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("GR_AMT"));
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _value = "";
					String DelYn = "N";
					
					DelYn = sqlSessionTemplate.selectOne("master.cmcl.selectIcomgrdtDelYn", (Map<String, String>) gridData.get(i));
					if(DelYn.equals("Y")) {
						throw new RuntimeException("삭제된 입고 건 입니다.");
					}
					
					_totAmt = _totAmt + _thisAmt;
					
					// 부서별 합산금액 설정
					if ( !_keyDeptAmtMap.containsKey(_deptCode) ) {
						_keyDeptAmtMap.put(_deptCode, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyDeptAmtMap.get(_deptCode);
						_keyDeptAmtMap.put(_deptCode, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				
				formData.put("tot_amt", String.valueOf(_totAmt)); // 총금액
				_keyList = _keyDeptAmtMap.keySet().toArray();	// 부서별 합산금액 리스트
				
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				
				// 세금계산서 번호 생성
				String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
				formData.put("order_no", _orderNo);
				
				// 세금계산서 품목정보 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_KEPTITEM", formData);
				
				// 마감횟수 조회 -- 마감차수 로직 변경 : 2014.07.31
//				String _closeCnt = sqlSessionTemplate.selectOne("master.cmcl.selectCloseCnt", formData);
//				LOGGER.debug("_closeCnt ==>{}<==", _closeCnt);
//				
//				if ( _closeCnt.equals("3") ) {
//					if ( "10".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "1";
//					} else if ( "20".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "2";
//					} else {
//						_closeRevision = "3";
//					}
//				} else {
//					if ( "15".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "1";
//					} else {
//						_closeRevision = "2";
//					}
//				}
				
//				formData.put("close_revision", _closeRevision);
				
				// 당사 정보 조회 및 파라메터 설정
				formData.put("com_code", "KRKORE0001");
				formData.put("irs_no", formData.get("KEP_IRS_NO"));
				LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));
				
				_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectKepIrsInfo", formData);
				
				LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);
				
				formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
				formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
				formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
				formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
				formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));
				
				// 고객사 정보 조회 및 파라메터 설정
				formData.put("com_code", formData.get("BUYER"));
				formData.put("irs_no", formData.get("BUYER_IRS_NO"));
				LOGGER.debug("com_code ==>{}<==", formData.get("BUYER"));
				LOGGER.debug("irs_no ==>{}<==", formData.get("BUYER_IRS_NO"));
				
				_buyerIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectBuyerIrsInfo", formData);

				LOGGER.debug("_buyerIrsInfoMap ==>{}<==", _buyerIrsInfoMap);
				
				formData.put("buyer_irs_name", _buyerIrsInfoMap.get("IRS_NAME"));
				formData.put("buyer_ceo_name_loc", _buyerIrsInfoMap.get("CEO_NAME_LOC"));
				formData.put("buyer_industry_type", _buyerIrsInfoMap.get("INDUSTRY_TYPE"));
				formData.put("buyer_business_items", _buyerIrsInfoMap.get("BUSINESS_ITEMS"));
				formData.put("buyer_address_loc", _buyerIrsInfoMap.get("ADDRESS_LOC"));
				
				LOGGER.debug("===== first for start =====");
				// 부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					String _deptCode = String.valueOf(_keyList[i]);
					double _suppPrice = Double.parseDouble(_keyDeptAmtMap.get(_keyList[i]));
					double _taxPrice  = Double.parseDouble(_keyDeptAmtMap.get(_keyList[i])) * 0.1;
					
					formData.put("dept_code", _deptCode);
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					
					LOGGER.debug("<< i >> ==>{}<==", i);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("supp_price ==>{}<==", _suppPrice);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					
					LOGGER.debug("BUYER ==>{}<==", formData.get("BUYER"));
					LOGGER.debug("st_user_id ==>{}<==", formData.get("st_user_id"));
					
					// 외상매출_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_BillCloseList", formData);
					
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
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClIndividual_ICOMGRDT", formData);
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			} else {
				throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		try {
			String _jobKind = formData.get("job_kind");
			
			// 저장 처리
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "저장이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					formData.put("KEP_DEPT", ((Map<String, String>)gridData.get(i)).get("KEP_DEPT"));
					formData.put("KEP_DEPT_OLD", ((Map<String, String>)gridData.get(i)).get("KEP_DEPT_OLD"));
					formData.put("GR_DATE", ((Map<String, String>)gridData.get(i)).get("GR_DATE"));
					formData.put("GR_DATE_OLD", ((Map<String, String>)gridData.get(i)).get("GR_DATE_OLD"));
					formData.put("PROCESS_TYPE", ((Map<String, String>)gridData.get(i)).get("PROCESS_TYPE"));
					formData.put("INV_NO", ((Map<String, String>)gridData.get(i)).get("INV_NO"));
					formData.put("INV_SEQ", ((Map<String, String>)gridData.get(i)).get("INV_SEQ"));
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClIndividual", formData);
				}
			}
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (건별)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";

				Map<String, String> _keyDeptAmtMap = new HashMap<String, String>();
				Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
				Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
//				String _closeRevision = "";
				Object[] _keyList;
				double _totAmt = 0;
				
//				String _issueDate = formData.get("issue_date");
//				LOGGER.debug("_issueDate ==>{}<==", _issueDate);
				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수
				
				formData.putAll((Map<String, String>)gridData.get(0));
								
				for ( int i=0; i < gridData.size(); i++ ) {
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("GR_AMT"));
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					String _value = "";
					String DelYn = "N";
					
					DelYn = sqlSessionTemplate.selectOne("master.cmcl.selectIcomgrdtDelYn", (Map<String, String>) gridData.get(i));
					if(DelYn.equals("Y")) {
						throw new RuntimeException("삭제된 입고 건 입니다.");
					}
					
					_totAmt = _totAmt + _thisAmt;
					
					// 부서별 합산금액 설정
					if ( !_keyDeptAmtMap.containsKey(_deptCode) ) {
						_keyDeptAmtMap.put(_deptCode, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyDeptAmtMap.get(_deptCode);
						_keyDeptAmtMap.put(_deptCode, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}
				
				formData.put("tot_amt", String.valueOf(_totAmt)); // 총금액
				_keyList = _keyDeptAmtMap.keySet().toArray();	// 부서별 합산금액 리스트
				
				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);
				
				// 세금계산서 번호 생성
				String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
				formData.put("order_no", _orderNo);
				
				// 세금계산서 품목정보 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_KEPTITEM", formData);
				
				// 마감횟수 조회 -- 마감차수 로직 변경 : 2014.07.31
//				String _closeCnt = sqlSessionTemplate.selectOne("master.cmcl.selectCloseCnt", formData);
//				LOGGER.debug("_closeCnt ==>{}<==", _closeCnt);
//				
//				if ( _closeCnt.equals("3") ) {
//					if ( "10".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "1";
//					} else if ( "20".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "2";
//					} else {
//						_closeRevision = "3";
//					}
//				} else {
//					if ( "15".equals(_issueDate.substring(6,8)) ) {
//						_closeRevision = "1";
//					} else {
//						_closeRevision = "2";
//					}
//				}
				
//				formData.put("close_revision", _closeRevision);
				
				// 당사 정보 조회 및 파라메터 설정
				formData.put("com_code", "KRKORE0001");
				formData.put("irs_no", formData.get("KEP_IRS_NO"));
				LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));
				
				_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectKepIrsInfo", formData);
				
				LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);
				
				formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
				formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
				formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
				formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
				formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));
				
				// 고객사 정보 조회 및 파라메터 설정
				formData.put("com_code", formData.get("BUYER"));
				formData.put("irs_no", formData.get("BUYER_IRS_NO"));
				LOGGER.debug("com_code ==>{}<==", formData.get("BUYER"));
				LOGGER.debug("irs_no ==>{}<==", formData.get("BUYER_IRS_NO"));
				
				_buyerIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectBuyerIrsInfo", formData);

				LOGGER.debug("_buyerIrsInfoMap ==>{}<==", _buyerIrsInfoMap);
				
				formData.put("buyer_irs_name", _buyerIrsInfoMap.get("IRS_NAME"));
				formData.put("buyer_ceo_name_loc", _buyerIrsInfoMap.get("CEO_NAME_LOC"));
				formData.put("buyer_industry_type", _buyerIrsInfoMap.get("INDUSTRY_TYPE"));
				formData.put("buyer_business_items", _buyerIrsInfoMap.get("BUSINESS_ITEMS"));
				formData.put("buyer_address_loc", _buyerIrsInfoMap.get("ADDRESS_LOC"));
				
				LOGGER.debug("===== first for start =====");
				// 부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					String _deptCode = String.valueOf(_keyList[i]);
					double _suppPrice = Double.parseDouble(_keyDeptAmtMap.get(_keyList[i]));
					double _taxPrice  = Double.parseDouble(_keyDeptAmtMap.get(_keyList[i])) * 0.1;
					
					formData.put("dept_code", _deptCode);
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					
					LOGGER.debug("<< i >> ==>{}<==", i);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("supp_price ==>{}<==", _suppPrice);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					
					LOGGER.debug("BUYER ==>{}<==", formData.get("BUYER"));
					LOGGER.debug("st_user_id ==>{}<==", formData.get("st_user_id"));
					
					// 외상매출_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClIndividual_BillCloseList", formData);
					
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
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClIndividual_ICOMGRDT", formData);
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			} else {
				throw new RuntimeException("\n\n[ 작업 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			
		}
		
		return _rtnMsg;
	}
	
//	// 삭제
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
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClIndividual", formData);
//				LOGGER.error("deleteMasterCmClIndividual 실행 완료");
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
