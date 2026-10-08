package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClSalesLogisticCostRegDao")
@Transactional
public class MasterCmClSalesLogisticCostRegDaoImpl implements MasterCmClSalesLogisticCostRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesLogisticCostRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesLogisticCostRegList", param, _resultHander);
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
				_rtnMsg = "매출세금계산서 업로드가 완료 되었습니다.";
				int _selCount = 0;
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 매출물류비세금계산서 업로드 임시 테이블 조회
					_selCount = (Integer)sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesLogisticCostReg_Check", formData);
					LOGGER.debug("_selCount : {}", _selCount);
					
					if ( _selCount != 0 ) {
						throw new RuntimeException("\n\n임시 테이블에 이미 데이터가 존재합니다.\n\n다시 확인해 보시기 바랍니다.");
					}
					
					// 매출물류비세금계산서 업로드 임시 테이블 저장
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClSalesLogisticCostReg", formData);
				}
			}
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				Map<String, String> _kepIrsInfoMap = null;
				Map<String, String> _buyerIrsInfoMap = null;
				int _upCount = 0;
				
				for ( int i=0; i < gridData.size(); i++ ) {
					LOGGER.debug("grid index ==>{}<==", i);
//					Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
//					Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
					formData.putAll((Map<String, String>)gridData.get(i));
					
					LOGGER.debug("issue_date ==>{}<==", formData.get("issue_date")); // 입고일자
					LOGGER.debug("AR_MONTH ==>{}<==", formData.get("AR_MONTH")); // 마감년월
					LOGGER.debug("issue_last_day ==>{}<==", formData.get("issue_last_day")); // 마감일자
					LOGGER.debug("st_close_revision ==>{}<==", formData.get("st_close_revision")); // 마감차수
					
//					String _ARcloseMonth = formData.get("AR_CLOSE_MONTH"); // 마감월(엑셀)
//					String _ARcloseRevision = formData.get("AR_CLOSE_REVISION"); // 마감차수(엑셀)
//					String _closeRevision = ""; // 저장될 마감차수
//					String _issueDate = ""; // 저장될 마감일
					
					// 마감횟수 조회
//					String _closeCnt = sqlSessionTemplate.selectOne("master.cmcl.selectCloseCnt", formData);
//					LOGGER.debug("_closeCnt ==>{}<==", _closeCnt);
//					
//					if ( _closeCnt.equals("3") ) {
//						if ( "1".equals(_ARcloseRevision) ) {
//							_closeRevision = _ARcloseRevision;
//							_issueDate = _ARcloseMonth + "10";
//						}
//						else if ( "2".equals(_ARcloseRevision) ) {
//							_closeRevision = _ARcloseRevision;
//							_issueDate = _ARcloseMonth + "20";
//						}
//						else {
//							_closeRevision = "3";
//							_issueDate = _ARcloseMonth + formData.get("LAST_DAY");
//						}
//					} else if ( _closeCnt.equals("2") ) {
//						if ( "1".equals(_ARcloseRevision) ) {
//							_closeRevision = _ARcloseRevision;
//							_issueDate = _ARcloseMonth + "15";
//						} else {
//							_closeRevision = "2";
//							_issueDate = _ARcloseMonth + formData.get("LAST_DAY");
//						}
//					} else {
//						_closeRevision = "1";
//						_issueDate = _ARcloseMonth + formData.get("LAST_DAY");
//					}
//					
//					formData.put("close_revision", _closeRevision);
//					formData.put("issue_date", _issueDate);
					
					// 세금계산서 번호 생성
					String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
					formData.put("order_no", _orderNo);
					LOGGER.debug("order_no ==>{}<==", _orderNo);
					
					// 당사 정보 조회 및 파라메터 설정
					formData.put("com_code", "KRKORE0001");
					formData.put("irs_no", formData.get("KEP_IRS_NO"));
					LOGGER.debug("irs_no ==>{}<==", formData.get("KEP_IRS_NO"));
					
					_kepIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectKepIrsInfo", formData);
					
					LOGGER.debug("_kepIrsInfoMap ==>{}<==", _kepIrsInfoMap);
					
					if ( _kepIrsInfoMap == null || _kepIrsInfoMap.isEmpty() ) {
						throw new RuntimeException("\n\n[ 당사사업장코드 : KRKORE0001 / 사업자번호 : " + formData.get("KEP_IRS_NO") + " ]"+ "\n에 대한 정보가 없습니다.\n\n다시 확인하여 주시기 바랍니다.");
					}
					
					formData.put("kep_irs_name", _kepIrsInfoMap.get("IRS_NAME"));
					formData.put("kep_ceo_name_loc", _kepIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("kep_industry_type", _kepIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("kep_business_items", _kepIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("kep_address_loc", _kepIrsInfoMap.get("ADDRESS_LOC"));
//					_kepIrsInfoMap = null;
					
					// 고객사 정보 조회 및 파라메터 설정
					formData.put("com_code", formData.get("BUYER"));
					formData.put("irs_no", formData.get("BUYER_IRS_NO"));
					LOGGER.debug("com_code ==>{}<==", formData.get("BUYER"));
					LOGGER.debug("irs_no ==>{}<==", formData.get("BUYER_IRS_NO"));
					
					_buyerIrsInfoMap = sqlSessionTemplate.selectOne("master.cmcl.selectBuyerIrsInfo", formData);

					LOGGER.debug("_buyerIrsInfoMap ==>{}<==", _buyerIrsInfoMap);
					
					if ( _buyerIrsInfoMap == null || _buyerIrsInfoMap.isEmpty() ) {
						throw new RuntimeException("\n\n[ 고객사코드 : " + formData.get("BUYER") + " / 사업자번호 : " + formData.get("BUYER_IRS_NO") + " ]" + "\n에 대한 정보가 없습니다.\n\n다시 확인하여 주시기 바랍니다.");
					}
					
					formData.put("buyer_irs_name", _buyerIrsInfoMap.get("IRS_NAME"));
					formData.put("buyer_ceo_name_loc", _buyerIrsInfoMap.get("CEO_NAME_LOC"));
					formData.put("buyer_industry_type", _buyerIrsInfoMap.get("INDUSTRY_TYPE"));
					formData.put("buyer_business_items", _buyerIrsInfoMap.get("BUSINESS_ITEMS"));
					formData.put("buyer_address_loc", _buyerIrsInfoMap.get("ADDRESS_LOC"));
//					_buyerIrsInfoMap = null;
					
					// 물류비_세금계산서 업로드 임시 테이블 수정
					_upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesLogisticCostReg", formData);
					
					if ( _upCount == 0 ) {
						throw new RuntimeException("\n\n[ BNTKEPTEXUP 수정실패 ]");
					}
					
					// 물류비_외상매출_세금계산서 저장
					_upCount = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisticCostReg_BNTKEPTARDT", formData);
					
					if ( _upCount == 0 ) {
						throw new RuntimeException("\n\n[ BNTKEPTARDT 입력실패 ]");
					}
					
					// 물류비_세금계산서 품목정보 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesLogisticCostReg_BNTKEPTITEM", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			
			if ( "save".equals(formData.get("job_kind")) ) {
				throw new RuntimeException("\n\n[ 업로드 저장 실패 ]");
			}
			else if ( "create".equals(formData.get("job_kind")) ) {
				throw new RuntimeException("\n\n[ 세금계산서 생성 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제가 정상적으로 처리되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				LOGGER.debug("BUYER ==>{}<==", formData.get("BUYER"));
				LOGGER.debug("AGENT ==>{}<==", formData.get("AGENT"));
				LOGGER.debug("AR_MONTH ==>{}<==", formData.get("AR_MONTH"));
				LOGGER.debug("ISSUE_DATE==>{}<==", formData.get("ISSUE_DATE"));
				
				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClSalesLogisticCostReg", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 삭제 요청 실패 ]");
		}

		return _rtnMsg;		
	}	

}
