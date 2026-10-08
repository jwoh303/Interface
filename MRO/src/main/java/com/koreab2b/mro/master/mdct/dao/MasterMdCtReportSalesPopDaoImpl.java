package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCtReportSalesPopDao")
@Transactional
public class MasterMdCtReportSalesPopDaoImpl implements MasterMdCtReportSalesPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtStndrdContractDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 고객사 기준 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesPopList", param);
	}
	// 부서 기준 리스트 조회
	public List<Map<String,String>> selectDeptList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesPopDeptList", param);
	}	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//고객사 코드 유효성 체크
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtBuyerCheck", formData);
				if(list.size() == 0){
					_rtnMsg = "고객사코드 확인 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				if(!"CMPY".equals(formData.get("st_group_gbn"))){
					//부서 코드 유효성 체크
					List<Map<String,String>> list2 = null;
					list2 = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtDeptCodeCheck", formData);
					if(list2.size() == 0){
						_rtnMsg = "부서코드 확인 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}	
				}
				if(i ==0) {
					//실적현황 상세 삭제
					sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesTotal", formData);
					//리포트 입력 완료 처리
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDt", formData);
				}
				sqlSessionTemplate.update("master.mdct.insertMasterMdCtReportSalesTotal", formData);
			}
		} catch (Exception e) {
			if("저장 되었습니다.".equals(_rtnMsg)) {
				_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	// 거래현황 입력 리스트
	public List<Map<String,String>> getMasterMdCtReportSalesTotalList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesTotalList", param);
	}
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportCustomerList", formData);
			}
			// 리포트 현황 가공 데이터 상태 갱신
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDtAll", formData);
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	// 계약신규 품목 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesNewPop", param);
	}
	// 계약신규 품목 등록 조회
	public List<Map<String,String>> getMasterMdCtReportSalesNewInputPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesNewInputPop", param);
	}
	// 계약신규 품목 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				logger.debug("saveMasterMdCtReportSalesNewPop 요청 파라미터 : formData {}", formData.get("sStatus"));
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtReportSalesNewPop", formData);
				} else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesNewPop", formData);
				}
				if(i ==0) {
					//리포트 입력 완료 처리
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesNewDt", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 계약신규 품목 삭제
	@SuppressWarnings("unchecked")
	public String deleteMasterMdCtReportSalesNewPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesNewPop", formData);
			}
			// 리포트 현황 가공 데이터 상태 갱신
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDtAll", formData);
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	// sg 품목별 조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesSgPop", param);
	}
	// sg 품목별 등록 조회
	public List<Map<String,String>> getMasterMdCtReportSalesSgInputPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesSgInputPop", param);
	}
	// sg 품목별 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "I".equals(formData.get("sStatus")) ) {
					//기존 데이터 삭제
					sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesSgPop", formData);
					//데이터 insert
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtReportSalesSgPop", formData);
				} else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesSgPop", formData);
				}
				if(i ==0) {
					//리포트 입력 완료 처리
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesSgDt", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// sg 품목별 삭제
	@SuppressWarnings("unchecked")
	public String deleteMasterMdCtReportSalesSgPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesSgPop", formData);
			}
			// 리포트 현황 가공 데이터 상태 갱신
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDtAll", formData);
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	// 카테고리 품목별 조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesCaPop", param);
	}
	// 카테고리 품목별 등록 조회
	public List<Map<String,String>> getMasterMdCtReportSalesCaInputPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesCaInputPop", param);
	}
	// 카테고리 품목별 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "I".equals(formData.get("sStatus")) ) {
					//기존 데이터 삭제
					sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesCaPop", formData);
					//데이터 insert
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtReportSalesCaPop", formData);
				} else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesCaPop", formData);
				}
				if(i ==0) {
					//리포트 입력 완료 처리
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesCaDt", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 카테고리 품목별 삭제
	@SuppressWarnings("unchecked")
	public String deleteMasterMdCtReportSalesCaPop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesCaPop", formData);
			}
			// 리포트 현황 가공 데이터 상태 갱신
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDtAll", formData);
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	// 납기견적 관리 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeRePop(Map<String,Object> param) {
		String st_sql_id = "";
		if(param.get("st_popup_type").equals("DECD")){//납기관리 calendar day
			param.put("st_gbn", "C");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesDePop";				
		}else if(param.get("st_popup_type").equals("DEWD")) {//납기관리 working day
			param.put("st_gbn", "W");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesDePop";
		}else if(param.get("st_popup_type").equals("RECD")) {//견적관리 calendar day
			param.put("st_gbn", "C");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesRePop";
		}else if(param.get("st_popup_type").equals("REWD")) {//견적관리 working day
			param.put("st_gbn", "W");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesRePop";
		}
		return sqlSessionTemplate.selectList(st_sql_id, param);
	}
	// 납기견적 관리 등록 조회
	public List<Map<String,String>> getMasterMdCtReportSalesDeReInputPop(Map<String,Object> param) {
		String st_sql_id = "";
		if(param.get("st_popup_type").equals("DECD")){//납기관리 calendar day
			param.put("st_gbn", "C");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesDeInputPop";				
		}else if(param.get("st_popup_type").equals("DEWD")) {//납기관리 working day
			param.put("st_gbn", "W");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesDeInputPop";
		}else if(param.get("st_popup_type").equals("RECD")) {//견적관리 calendar day
			param.put("st_gbn", "C");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesReInputPop";
		}else if(param.get("st_popup_type").equals("REWD")) {//견적관리 working day
			param.put("st_gbn", "W");
			st_sql_id ="master.mdct.selectMasterMdCtReportSalesReInputPop";
		}
		return sqlSessionTemplate.selectList(st_sql_id, param);
	}
	// 납기견적 관리 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장 되었습니다.";
		try {
			formData.put("st_status_yn", "Y");
			if(formData.get("st_popup_type").equals("DECD")||formData.get("st_popup_type").equals("DEWD")){
				if(formData.get("st_popup_type").equals("DECD")) {
					formData.put("st_gbn", "C");
				}else {
					formData.put("st_gbn", "W");
				}
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					if ( "I".equals(formData.get("sStatus")) ) {
						//기존 데이터 삭제
						sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesDePop", formData);
						//데이터 insert
						sqlSessionTemplate.insert("master.mdct.insertMasterMdCtReportSalesDePop", formData);
					} else {
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDePop", formData);
					}
					if(i ==0) {
						//리포트 입력 완료 처리
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDeDt", formData);
					}
				}
			}else if(formData.get("st_popup_type").equals("RECD")||formData.get("st_popup_type").equals("REWD")) {
				if(formData.get("st_popup_type").equals("RECD")) {
					formData.put("st_gbn", "C");
				}else {
					formData.put("st_gbn", "W");
				}
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					if ( "I".equals(formData.get("sStatus")) ) {
						//기존 데이터 삭제
						sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesRePop", formData);
						//데이터 insert
						sqlSessionTemplate.insert("master.mdct.insertMasterMdCtReportSalesRePop", formData);
					} else {
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesRePop", formData);
					}
					if(i ==0) {
						//리포트 입력 완료 처리
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesReDt", formData);
					}
				}				
			}
		} catch (Exception e) {
			_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 납기견적 관리 삭제
	@SuppressWarnings("unchecked")
	public String deleteMasterMdCtReportSalesDeRePop(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제 되었습니다.";
		try {
			formData.put("st_status_yn", "N");
			if(formData.get("st_popup_type").equals("DECD")||formData.get("st_popup_type").equals("DEWD")){
				if(formData.get("st_popup_type").equals("DECD")) {
					formData.put("st_gbn", "C");
				}else {
					formData.put("st_gbn", "W");
				}
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesDePop", formData);
					if(i ==0) {
						//리포트 입력 완료 처리
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesDeDt", formData);
					}
				}
			}else if(formData.get("st_popup_type").equals("RECD")||formData.get("st_popup_type").equals("REWD")) {
				if(formData.get("st_popup_type").equals("RECD")) {
					formData.put("st_gbn", "C");
				}else {
					formData.put("st_gbn", "W");
				}
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportSalesRePop", formData);
					if(i ==0) {
						//리포트 입력 완료 처리
						sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesReDt", formData);
					}
				}				
			}
		} catch (Exception e) {
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	//  총평조회
	public List<Map<String,String>> getMasterMdCtReportSalesEvaluationPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtReportSalesEvaluation", formData);
	}
	// 총평등록
	public String saveMasterMdCtReportSalesEvaluationPop(Map<String,String>  pMap){
		String _rtnMsg = "저장 되었습니다.";
		try{
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesEvaluationPop", pMap);
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportSalesEvaluationDt", pMap);
		}catch(Exception e){
			_rtnMsg = "저장에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;	
		
	}
}
