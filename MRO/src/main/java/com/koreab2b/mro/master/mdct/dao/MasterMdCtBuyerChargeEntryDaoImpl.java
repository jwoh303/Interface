package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCtBuyerChargeEntryDao")
@Transactional
public class MasterMdCtBuyerChargeEntryDaoImpl implements MasterMdCtBuyerChargeEntryDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtBuyerChargeEntryDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 담당자 중복체크
	public String selectKepUserIdCheck(Map<String,String>  formData, List<Object> gridData) {
		return sqlSessionTemplate.selectOne("master.mdct.selectMasterMdCtBuyerChargeEntryUserIdCheck", formData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerChargeEntryList", param);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사별 담당자 저장이 완료 되었습니다.";
		String _idCnt ="0";
		String _deptCnt = "0";
		String _priorityCnt = "0";
		String _mainCnt = "0";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData.get("sStatus"));
											
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtBuyerChargeEntryList", formData);
				} else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtBuyerChargeEntryList", formData);
				}
			}
			
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				// ID 중복여부확인
				_idCnt = sqlSessionTemplate.selectOne("master.mdct.selectMasterMdCtBuyerChargeEntryUserIdCheck", formData);
				if (Integer.parseInt(_idCnt) > 1) {
					throw new RuntimeException("\n동일 고객사에 아이디를 중복으로 등록할 수 없습니다.");
				}
				
				//  main pm 중복여부 확인
				_priorityCnt = sqlSessionTemplate.selectOne("master.mdct.getMasterMdCtBuyerChargeEntryPriority", formData);
				if(Integer.parseInt(_priorityCnt) > 1) {
					throw new RuntimeException("\n메인 운영이 이미 지정되어 있습니다.");
				}
				
				// main bm 중복여부 확인
				_mainCnt = sqlSessionTemplate.selectOne("master.mdct.getMasterMdCtBuyerChargeEntryMain", formData);
				if(Integer.parseInt(_mainCnt) > 1) {
					throw new RuntimeException("\n메인 영업이 이미 지정되어 있습니다.");
				}
				
				//기존 등록 부서 확인
				_deptCnt = sqlSessionTemplate.selectOne("master.mdct.getMasterMdCtBuyerChargeEntryDept", formData);
				if (Integer.parseInt(_deptCnt) > 1) {
					throw new RuntimeException("동일 고객사에 다른 부서로 등록할 수 없습니다.");
				}
			}
		} catch (Exception e) {
			if(e.getMessage() == null || "".equals(e.getMessage()) || e.getMessage().isEmpty()) {
				_rtnMsg = "고객사별 담당자 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			}	else {
				_rtnMsg = e.getMessage();
			}
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사별 담당자 삭제가 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
	
				LOGGER.debug("deletetMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);
				sqlSessionTemplate.delete("master.mdct.deletetMasterMdCtBuyerChargeEntryList", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "고객사별 담당자 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사별 담당자 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}
