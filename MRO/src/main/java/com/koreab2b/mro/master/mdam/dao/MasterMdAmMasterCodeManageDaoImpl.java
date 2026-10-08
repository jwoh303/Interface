package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdAmMasterCodeManageDao")
@Transactional
public class MasterMdAmMasterCodeManageDaoImpl implements MasterMdAmMasterCodeManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdAmMasterCodeManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 코드 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		String _type = (String)param.get("st_type");
		
		// 부서코드 조회
		if ( "C001".equals(_type) ) {
			resultList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMasterCodeManageList_Dept", param);
		}
		else {
			resultList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMasterCodeManageList", param);
		}
		
		return resultList;
	}
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		String _type = (String)param.get("st_type");
		
		// 부서코드 조회
		if ( "C001".equals(_type) ) {
			resultList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMasterCodeManageList_Dept_v2", param);
		}
		else {
			resultList = sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMasterCodeManageList", param);
		}
		
		return resultList;
	}

	// 코드 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _type = (String)formData.get("st_type");
		String _code = (String)formData.get("CODE");
		String _orgCode = (String)formData.get("ORG_CODE");
		String _deptType = (String)formData.get("DEPT_TYPE");
		String _orgDeptType = (String)formData.get("ORG_DEPT_TYPE");
		String _checkVal = "";
		String _msg = "";
		int _count = 0;
		
		if ( "C012".equals(_type) ) {
			_msg = "도착지";
		}
		else if ( "C003".equals(_type) ) {
			_msg = "직급";
		}
		else if ( "C001".equals(_type) ) {
			_msg = "부서";
		}
		else if ( "Z014".equals(_type) ) {
			_msg = "계정";
		}
		else if ( "M014".equals(_type) ) {
			_msg = "관리";
		}
		
		_rtnMsg = _msg + "코드 생성 및 수정이 정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				formData.put("st_type", _type);
				
				if ( !_code.equals(_orgCode) ) {
					LOGGER.debug("===>> check <<===");
					// 트랜잭션 체크
					_checkVal = (String)sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmMasterCodeManageCheck", formData);
					
					if ( !"".equals(CommonUtil.nvl(_checkVal)) ) {
						throw new RuntimeException("\n\n[ " + _msg + "코드가 이미 등록되어 있습니다. ]\n\n다시 확인하여 주십시요.");
					}
				}
				
				if ( "U".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> U <<===");
					// 회사별 코드관리 수정
					_count = sqlSessionTemplate.update("master.mdam.updateMasterMdAmMasterCodeManage", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("\n\n[ " + _msg + "코드 수정 실패 ]\n\n다시 확인하여 주십시요.");
					}

					// 부서코드
					if ( "C001".equals(_type) ) {
						LOGGER.debug("===>> U : C001 <<===");
						// 발주부서(생성), 일반부서(삭제)
						formData.put("st_type", "C004");
						formData.put("TEXT1", "");
						formData.put("TEXT2", "");
						formData.put("TEXT3", "");
						formData.put("TEXT4", "");
						
						if ( !_code.equals(_orgCode) ) {
							// 트랜잭션 체크
							_checkVal = (String)sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmMasterCodeManageCheck", formData);
							
							if ( !"".equals(CommonUtil.nvl(_checkVal)) ) {
								throw new RuntimeException("\n\n[ 부서코드가 이미 등록되어 있습니다. ]\n\n다시 확인하여 주십시요.");
							}
						}
						
						// 발주부서 선택
						if ( "Y".equals(_deptType) ) {
							// 기존 부서가 발주부서면 발주부서 테이블 수정
							if ( "Y".equals(_orgDeptType) ) {
								LOGGER.debug("===>> U : U <<===");
								// 회사별 코드관리 수정
								_count = sqlSessionTemplate.update("master.mdam.updateMasterMdAmMasterCodeManage", formData);
								
								if ( _count != 1 ) {
									throw new RuntimeException("\n\n[ 발주부서 수정 실패 ]\n\n다시 확인하여 주십시요.");
								}
							}
							// 기존 부서가 발주부서가 아니여서 처음으로 발주부서(C004)에 등록
							else {
								LOGGER.debug("===>> U : I <<===");
								// 회사별 코드관리 생성
								_count = sqlSessionTemplate.insert("master.mdam.insertMasterMdAmMasterCodeManage", formData);
								
								if ( _count != 1 ) {
									throw new RuntimeException("\n\n[ 발주부서 생성 실패 ]\n\n다시 확인하여 주십시요.");
								}
							}
						}
						// 기존에 발주부서였는데 이번 선택은 발주부서가 아닐 때 (C004 삭제)
						else if ( !"Y".equals(_deptType) && "Y".equals(_orgDeptType) ) {
							LOGGER.debug("===>> U : D <<===");
							// 회사별 코드관리 삭제
							sqlSessionTemplate.update("master.mdam.deleteMasterMdAmMasterCodeManage", formData);
						}
						
					}
				}
				else if ( "I".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> I <<===");
					// 회사별 코드관리 생성
					_count = sqlSessionTemplate.insert("master.mdam.insertMasterMdAmMasterCodeManage", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("\n\n[ " + _msg + "코드 생성 실패 ]\n\n다시 확인하여 주십시요.");
					}
					
					// 부서코드
					if ( "C001".equals(_type) ) {
						LOGGER.debug("===>> I : C001 <<===");
						// 발주부서(생성), 일반부서(삭제)
						formData.put("st_type", "C004");
						formData.put("TEXT1", "");
						formData.put("TEXT2", "");
						formData.put("TEXT3", "");
						formData.put("TEXT4", "");
						
						// 트랜잭션 체크
						_checkVal = (String)sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmMasterCodeManageCheck", formData);
						
						if ( !"".equals(CommonUtil.nvl(_checkVal)) ) {
							throw new RuntimeException("\n\n[ 발주부서가 이미 등록되어 있습니다. ]\n\n다시 확인하여 주십시요.");
						}
						
						// 발주부서 선택 시 발주부서(C004)에도 등록
						if ( "Y".equals(_deptType) ) {
							LOGGER.debug("===>> I : I <<===");
							// 회사별 코드관리 생성
							_count = sqlSessionTemplate.insert("master.mdam.insertMasterMdAmMasterCodeManage", formData);
						}
						
						if ( _count != 1 ) {
							throw new RuntimeException("\n\n[ 발주부서 생성 실패 ]\n\n다시 확인하여 주십시요.");
						}
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ " + _msg + "코드 생성 및 수정 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 코드 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _type = (String)formData.get("st_type");
		String _checkVal = "";
		String _msg = "";
		int _count = 0;
		
		if ( "C012".equals(_type) ) {
			_msg = "도착지";
		}
		else if ( "C003".equals(_type) ) {
			_msg = "직급";
		}
		else if ( "C001".equals(_type) ) {
			_msg = "부서";
		}
		else if ( "Z014".equals(_type) ) {
			_msg = "계정";
		}
		else if ( "M014".equals(_type) ) {
			_msg = "관리";
		}
		
		_rtnMsg = _msg + "코드 삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				formData.put("st_type", _type);
				
				if ( "Z014".equals(_type) ) {
					// 트랜잭션 체크
					_checkVal = (String)sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmMasterCodeManageAccountCheck", formData);
					
					if ( "OO".equals(_checkVal) ) {
						throw new RuntimeException("\n\n[ 예산편성된 계정은 삭제 할 수 없습니다. ]\n\n다시 확인하여 주십시요.");
					}
				}
				
				_count = sqlSessionTemplate.update("master.mdam.deleteMasterMdAmMasterCodeManage", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("\n\n[ " + _msg + "코드 삭제 실패 ]\n\n다시 확인하여 주십시요.");
				}
				
				// 부서코드
				if ( "C001".equals(_type) ) {
					
					// DEPT_TYPE : Y-발주부서, N-일반부서
					if ("Y".equals(formData.get("DEPT_TYPE"))) {
						// 발주부서(생성), 일반부서(삭제)
						formData.put("st_type", "C004");
						
						// 회사별 코드관리 삭제 - 발주부서 삭제
						_count = sqlSessionTemplate.update("master.mdam.deleteMasterMdAmMasterCodeManage", formData);
						
						if ( _count != 1 ) {
							throw new RuntimeException("\n\n[ 발주부서 삭제 실패 ]\n\n다시 확인하여 주십시요.");
						}
					}
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ " + _msg + "코드 삭제 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}

		return _rtnMsg;		
	}
	
}
