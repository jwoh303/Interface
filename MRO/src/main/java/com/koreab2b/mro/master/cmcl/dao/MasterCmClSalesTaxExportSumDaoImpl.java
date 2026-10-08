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

@Repository("masterCmClSalesTaxExportSumDao")
@Transactional
public class MasterCmClSalesTaxExportSumDaoImpl implements MasterCmClSalesTaxExportSumDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxExportSumDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxExportSumList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		try {
				LOGGER.debug("<<<<<<<<<< (합산)생성 처리 로직 Start >>>>>>>>>>");
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				String _beforeOrderNo = "";

				LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 마감년월
				LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
				LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수

				formData.putAll((Map<String, String>)gridData.get(0));
				
				for ( int i=0; i < gridData.size(); i++ ) {
					String _buyerIrsNo = ((Map<String, String>) gridData.get(i)).get("BUYER_IRS_NO");
					String _buyerCode = ((Map<String, String>) gridData.get(i)).get("BUYER");
					String _deptCode = ((Map<String, String>) gridData.get(i)).get("KEP_DEPT");
					double _thisAmt = Double.parseDouble(((Map<String, String>) gridData.get(i)).get("GR_AMT"));
					double _taxPrice = 0;
					double _totAmt = _thisAmt;

					formData.put("buyer_code", _buyerCode);
					formData.put("dept_code", _deptCode);
					formData.put("supp_price", String.valueOf(_thisAmt));
					formData.put("tax_price", String.valueOf(_taxPrice));
					formData.put("tot_amt", String.valueOf(_totAmt));
					formData.put("key_exp_gr_no", ((Map<String, String>)gridData.get(i)).get("EXP_GR_NO"));
					formData.put("key_exp_date", ((Map<String, String>)gridData.get(i)).get("EXP_DATE_OF_SHIPMENT"));
					formData.put("key_exp_cur", ((Map<String, String>)gridData.get(i)).get("EXP_CUR"));
					formData.put("key_exp_cur_price", ((Map<String, String>)gridData.get(i)).get("EXP_CUR_PRICE"));
					formData.put("exp_amt", ((Map<String, String>)gridData.get(i)).get("EXP_FOR_ITEM_AMT"));

					LOGGER.debug("<<< i : {} >>>", i);
					LOGGER.debug("buyer_code ==>{}<==", _buyerCode);
					LOGGER.debug("dept_code ==>{}<==", _deptCode);
					LOGGER.debug("supp_price ==>{}<==", _thisAmt);
					LOGGER.debug("tax_price ==>{}<==", _taxPrice);
					LOGGER.debug("tot_amt ==>{}<==", _totAmt);

					// 당사 정보 조회 및 파라메터 설정
					formData.put("com_code", "KRKORE0001");
					formData.put("irs_no", formData.get("KEP_IRS_NO"));
					LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));
					Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
					Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
					
					_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectKepIrsGroupInfo", formData);					

					LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);
	
					formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
					formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));
	
					// 고객사 정보 조회 및 파라메터 설정
					formData.put("com_code", _buyerCode);
					formData.put("irs_no", _buyerIrsNo);
					LOGGER.debug("com_code ==>{}<==", _buyerCode);
					LOGGER.debug("irs_no ==>{}<==",_buyerIrsNo);
	
					_buyerIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectBuyerIrsGroupInfo", formData);
	
					LOGGER.debug("_buyerIrsInfoMap ==>{}<==", _buyerIrsInfoMap);
	
					formData.put("buyer_irs_name", _buyerIrsInfoMap.get("IRS_NAME"));
					formData.put("buyer_ceo_name_loc", _buyerIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("buyer_industry_type", _buyerIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("buyer_business_items", _buyerIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("buyer_address_loc", _buyerIrsInfoMap.get("ADDRESS_LOC"));

					String ar_no = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
					formData.put("order_no",ar_no);

					// 외상매출_세금계산서 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxExportSum_KEPTARDT", formData);
					
					// 마감제출 TABLE MERGE INTO
					//sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxExportSum_BillCloseList", formData);
					
					if ( !_beforeOrderNo.equals(formData.get("order_no")) ) {
						// 세금계산서 품목정보 저장
						int resultCnt = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxExportSum_KEPTITEM", formData);
						
						if ( resultCnt != 1 ) {
							throw new RuntimeException("\n\n[ KEPTITEM 입력오류 : 1개이상 입력 ]");
						}
					}
					
					_beforeOrderNo = formData.get("order_no");
					
					formData.put("key_kep_dept_code", ((Map<String, String>)gridData.get(i)).get("KEP_DEPT_CODE"));
					formData.put("key_gr_from_date", ((Map<String, String>)gridData.get(i)).get("GR_FROM_DATE"));
					formData.put("key_gr_to_date", ((Map<String, String>)gridData.get(i)).get("GR_TO_DATE"));
					int upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxExportSum_ICOMGRDT", formData);
					if ( upCount == 0 ) {
						throw new RuntimeException("\n\n[ GR 변경 실패 ]");
					}			

					/* 생성된 AR로 IT사업팀 해당 카테고리 금액 계산 - START 20170607 by HSJ */
					Map<String, String> _itDeptMap = new HashMap<String, String>();
					
					_itDeptMap.put("ar_no", ar_no);
					_itDeptMap.put("buyer_code", _buyerCode);
					
					String it_dept_amt = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxExportSum_IT_DEPT_AMT", _itDeptMap);
					
					LOGGER.debug("it_dept_amt ==>{}<==", it_dept_amt);
					
					// 금액이 있을 때만 실행(조회 결과값 NVL = 0)
					if(!"0".equals(it_dept_amt)){
						LOGGER.debug("== IT사업팀 마감 분배 Start ==");
						
						_itDeptMap.put("it_amt", it_dept_amt);

						// 기생성 ARDT 수정(IT사업팀 금액만큼 차감)
						sqlSessionTemplate.insert("master.cmcl.updateMasterCmClSalesTaxExportSum_KEPTARDT_ORG", _itDeptMap);
						
						// 같은 AR_NO 로 IT사업팀으로 추가 생성
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxExportSum_IT_KEPTARDT", _itDeptMap);
						
						// 기생성 GRDT 수정(AR_CLOSE_DEPT = IT사업팀)
						sqlSessionTemplate.insert("master.cmcl.updateMasterCmClSalesTaxExportSum_IT_ICOMGRDT", _itDeptMap);
						
						LOGGER.debug("== IT사업팀 마감 분배 End ==");
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
