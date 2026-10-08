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

@Repository("masterCmClSalesTaxsheetCreationDao")
@Transactional
public class MasterCmClSalesTaxsheetCreationDaoImpl implements MasterCmClSalesTaxsheetCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetCreationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 입고금액 합산 조회
	public String selectBuyerGrAmt(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.cmcl.selectBuyerGrAmt", param);
	}
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxsheetCreationList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "세금계산서가 생성 되었습니다.";
		
		try {
			Map<String, String> _kepIrsInfoMap = new HashMap<String, String>();
			Map<String, String> _buyerIrsInfoMap = new HashMap<String, String>();
			String _closeRevision = "";
			
			String _issueDate = formData.get("issue_date");
			formData.put("YM_date", String.valueOf(_issueDate).substring(0,6));
			formData.put("D_date", String.valueOf(_issueDate).substring(6,8));
			
			formData.putAll((Map<String, String>)gridData.get(0));
			
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
			
			if ( "".equals(_kepIrsInfoMap.get("IRS_NAME")) ) {
				throw new RuntimeException("\n\n[ kep 사업자번호 오류 ]");
			}
			if ( "".equals(_buyerIrsInfoMap.get("IRS_NAME")) ) {
				throw new RuntimeException("\n\n[ 고객사 사업자번호 오류 ]");
			}
			
			if ( "KRDOOD0001".equals(formData.get("BUYER")) ) {
				if ( "10".equals(_issueDate.substring(6,8)) ) {
					_closeRevision = "1";
				} else if ( "20".equals(_issueDate.substring(6,8)) ) {
					_closeRevision = "2";
				} else {
					_closeRevision = "3";
				}
			} else {
				if ( "15".equals(_issueDate.substring(6,8)) ) {
					_closeRevision = "1";
				} else {
					_closeRevision = "2";
				}
			}
			
			formData.put("close_revision", _closeRevision);
			
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 세금계산서 번호 생성
				String _orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
				formData.put("order_no", _orderNo);
				
				// 외상매출_세금계산서 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxsheetCreation_KEPTARDT", formData);
				
				// 세금계산서 품목정보 저장
				sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxsheetCreation_KEPTITEM", formData);
			}
			
			// 구매사별 입고정보 저장
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetCreation_ICOMGRDT", formData);
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 저장 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
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
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClSalesTaxsheetCreation", formData);
//				LOGGER.error("deleteMasterCmClSalesTaxsheetCreation 실행 완료");
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
