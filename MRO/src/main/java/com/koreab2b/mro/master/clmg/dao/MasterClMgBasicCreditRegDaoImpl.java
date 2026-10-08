package com.koreab2b.mro.master.clmg.dao;

import java.util.ArrayList;
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

@Repository("masterClMgBasicCreditRegDao")
@Transactional
public class MasterClMgBasicCreditRegDaoImpl implements MasterClMgBasicCreditRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterClMgBasicCreditRegDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgBasicCreditReg", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 저장되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.clmg.insertMasterClMgBasicCreditReg", formData);
				logger.error("insertMasterClMgBasicCreditReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.clmg.deleteMasterClMgBasicCreditReg", formData);
				logger.error("deleteMasterClMgBasicCreditReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
	
	// 품의상신
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String apprMasterClMgBasicCreditReg(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		
		try{
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				//사업자번호, 담당팀 기준으로 중복 체크
				List<Map<String, String>> _resultListMap = new ArrayList<Map<String, String>>();
				List<Map<String, String>> _resultListMap2 = new ArrayList<Map<String, String>>();
				_resultListMap  = sqlSessionTemplate.selectList("master.clmg.selectrMasterClMgBasicCreditReg", formData);
				_resultListMap2  = sqlSessionTemplate.selectList("master.clmg.selectMasterClMgBasicCreditMapping", formData);
				String _irs_no = CommonUtil.nvl(formData.get("IRS_NO"));
				if(_resultListMap.size() >0){
					_rtnMsg = _irs_no+" 해당 사업자번호, 담당팀으로 여신이 등록 되어 있습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				String _com_code = CommonUtil.nvl(formData.get("COM_CODE"));
				//com_code 정보가 있을경우 만 insert
				if(!_com_code.equals("")){
					if(_resultListMap2.size() < 1){//cod3 등록안되었을 경우.
						// 여신한도 등록 기준 매핑
						sqlSessionTemplate.update("master.clmg.insertMasterClMgBasicCreditMapping", formData);
					}
				}

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품의상신 중 오류가 발생했습니다.");
		}

		return _rtnMsg;		
	}
}
