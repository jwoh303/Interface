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

@Repository("masterCmClSalesTaxSumDao")
@Transactional
public class MasterCmClSalesTaxSumDaoImpl implements MasterCmClSalesTaxSumDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxSumDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxSumList", param, _resultHander);
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
				_rtnMsg = "담당부서 저장이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxSum", formData);
				}
			} 
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				LOGGER.debug("<<<<<<<<<< (합산)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
				Map<String, String[]> _keyBuyerInfoMap = new HashMap<String, String[]>();
				Map<String, String> _keyBuyerDeptAmtMap = new HashMap<String, String>();
				Map<String, String> _keyOrderNoMap = new HashMap<String, String>();
//				String _closeRevision = "";
				String _beforeOrderNo = "";
				Object[] _keyList;

//				String _issueDate = formData.get("issue_date");
//				LOGGER.debug("_issueDate ==>{}<==", _issueDate);
				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수

				formData.putAll((Map<String, String>)gridData.get(0));	

				for ( int i=0; i < gridData.size(); i++ ) {
					String _buyerIrsNo = ((Map<String, String>) gridData.get(i)).get("BUYER_IRS_NO");
					String _buyer = ((Map<String, String>) gridData.get(i)).get("BUYER");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("GR_AMT"));
					
					String DelYn = "";
					
					DelYn = sqlSessionTemplate.selectOne("master.cmcl.selectIcomgrdtDelYn_sum", (Map<String, String>) gridData.get(i));
					if(DelYn.equals("Y")) {
						throw new RuntimeException("합산 금액 중 삭제된 입고가 포함되어있습니다. 재조회 후 생성 바랍니다.");
					}
					
					String _value = "";
					String[] _buyerInfo = new String[2];
					_buyerInfo[0] = String.valueOf(_thisAmt);
					_buyerInfo[1] = _buyerIrsNo;
					
//					formData.put("BUYER", _buyer);	// ***** 고객사코드 설정 : 마감횟수 조회용도 ( but.. 이러면.. 여러 고객사일 경우 젤 마지막 고객사의 마감횟수를 사용하는데.. 문제 없음..? ) *****

					// 고객사별 (합산금액, 사업자번호) 설정
					if ( !_keyBuyerInfoMap.containsKey(_buyer) ) {
						_keyBuyerInfoMap.put(_buyer, _buyerInfo);
					} else {
						String[] _temp = (String[])_keyBuyerInfoMap.get(_buyer);
						_buyerInfo[0] = String.valueOf(Double.parseDouble(_temp[0]) + _thisAmt);
						_keyBuyerInfoMap.put(_buyer, _buyerInfo);
					}
					
					// 고객사+부서별 합산금액 설정
					if ( !_keyBuyerDeptAmtMap.containsKey(_buyer+_deptCode) ) {
						_keyBuyerDeptAmtMap.put(_buyer+_deptCode, String.valueOf(_thisAmt));
					} else {
						_value = (String)_keyBuyerDeptAmtMap.get(_buyer+_deptCode);
						_keyBuyerDeptAmtMap.put(_buyer+_deptCode, String.valueOf(Double.parseDouble(_value) + _thisAmt));
					}
				}

				_keyList = _keyBuyerDeptAmtMap.keySet().toArray();	// 고객사+부서별 합산금액 리스트

				LOGGER.debug("_keyList.length ==>{}<==", _keyList.length);
				LOGGER.debug("_keyList ==>{}<==", _keyList);

				// 마감횟수 조회 -- 마감차수 로직 변경 : 2014.07.31
//				String _closeCnt = sqlSessionTemplate.selectOne("master.cmcl.selectCloseCnt", formData);
//				LOGGER.debug("_closeCnt ==>{}<==", _closeCnt);

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
//				
//				formData.put("close_revision", _closeRevision);

				LOGGER.debug("===== first for start =====");
				// 고객사+부서별 처리
				for ( int i = 0; i < _keyList.length; i++) {
					Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
					Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
					String _buyerCode = String.valueOf(_keyList[i]).substring(0,10);
					String _deptCode = String.valueOf(_keyList[i]).substring(10,13);
					String [] _buyerInfo = (String[])_keyBuyerInfoMap.get(_buyerCode);
					double _suppPrice = Double.parseDouble(_keyBuyerDeptAmtMap.get(_keyList[i]));
					double _taxPrice = Double.parseDouble(_keyBuyerDeptAmtMap.get(_keyList[i])) * 0.1;
					double _totAmt = Double.parseDouble(_buyerInfo[0]);

					formData.put("buyer_code", _buyerCode);
					formData.put("dept_code", _deptCode);
					formData.put("supp_price", String.valueOf(_suppPrice));
					formData.put("tax_price", String.valueOf(_taxPrice));
					formData.put("tot_amt", String.valueOf(_totAmt));

					LOGGER.debug("<<< i : {} >>>", i);
					LOGGER.debug("buyer_code ==>{}<==", _buyerCode);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("supp_price ==>{}<==", _suppPrice);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					LOGGER.debug("tot_amt ==>{}<==", _totAmt);

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
					formData.put("com_code", _buyerCode);
					formData.put("irs_no", _buyerInfo[1]);
					LOGGER.debug("com_code ==>{}<==", _buyerCode);
					LOGGER.debug("irs_no ==>{}<==", _buyerInfo[1]);
	
					_buyerIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectBuyerIrsInfo", formData);
	
					LOGGER.debug("_buyerIrsInfoMap ==>{}<==", _buyerIrsInfoMap);
	
					formData.put("buyer_irs_name", _buyerIrsInfoMap.get("IRS_NAME"));
					formData.put("buyer_ceo_name_loc", _buyerIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("buyer_industry_type", _buyerIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("buyer_business_items", _buyerIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("buyer_address_loc", _buyerIrsInfoMap.get("ADDRESS_LOC"));
					
					// 고객사별 세금계산서 번호 생성 여부 체크
					if ( !_keyOrderNoMap.containsKey(_buyerCode) ) {
						// 세금계산서 번호 생성
						_keyOrderNoMap.put(_buyerCode, String.valueOf(sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR")));
					}
					
					formData.put("order_no", _keyOrderNoMap.get(_buyerCode));

					// 외상매출_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxSum_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxSum_BillCloseList", formData);
					
					if ( !_beforeOrderNo.equals(formData.get("order_no")) ) {
						// 세금계산서 품목정보 저장
						int resultCnt = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxSum_KEPTITEM", formData);
						
						if ( resultCnt != 1 ) {
							throw new RuntimeException("\n\n[ KEPTITEM 입력오류 : 1개이상 입력 ]");
						}
					}
					
					_beforeOrderNo = formData.get("order_no");

					LOGGER.debug("===== second for start =====");
					for ( int j=0; j < gridData.size(); j++ ) {
						if ( ((Map<String, String>)gridData.get(j)).get("BUYER").equals(_buyerCode) && ((Map<String, String>)gridData.get(j)).get("KEP_DEPT").equals(_deptCode) ) {
							formData.put("key_kep_dept_code", ((Map<String, String>)gridData.get(j)).get("KEP_DEPT_CODE"));
							formData.put("key_agent_code", ((Map<String, String>)gridData.get(j)).get("AGENT_CODE"));
							formData.put("key_gr_from_date", ((Map<String, String>)gridData.get(j)).get("GR_FROM_DATE"));
							formData.put("key_gr_to_date", ((Map<String, String>)gridData.get(j)).get("GR_TO_DATE"));

							LOGGER.debug("<<< j : {} >>>", j);
							LOGGER.debug("order_no ==>{}<==", formData.get("order_no"));
							LOGGER.debug("dept_code ==>{}<==", formData.get("dept_code"));
							LOGGER.debug("buyer_code ==>{}<==", formData.get("buyer_code"));
							LOGGER.debug("key_kep_dept_code ==>{}<==", formData.get("key_kep_dept_code"));
							LOGGER.debug("key_agent_code ==>{}<==", formData.get("key_agent_code"));
							LOGGER.debug("key_gr_from_date ==>{}<==", formData.get("key_gr_from_date"));
							LOGGER.debug("key_gr_to_date ==>{}<==", formData.get("key_gr_to_date"));

							// 구매사별 입고정보 저장
							int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxSum_ICOMGRDT", formData);
							if ( upCount == 0 ) {
								throw new RuntimeException("\n\n[ GR 변경 실패 ]");
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
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClSalesTaxSum", formData);
//				LOGGER.error("deleteMasterCmClSalesTaxSum 실행 완료");
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
