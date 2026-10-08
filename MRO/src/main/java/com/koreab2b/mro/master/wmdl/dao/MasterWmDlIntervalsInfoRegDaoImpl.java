package com.koreab2b.mro.master.wmdl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmDlIntervalsInfoRegDao")
@Transactional
public class MasterWmDlIntervalsInfoRegDaoImpl implements MasterWmDlIntervalsInfoRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlIntervalsInfoRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlIntervalsInfoRegList", param);
	}

	// 리스트 조회
	public List<Map<String,String>> selectAllList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlIntervalsInfoRegAllList", param);
	}	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));
				
				List<Map<String,Object>>  _checkDuple = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsInfoReg", formData);
				
				if( "N".equals(formData.get("SAVE_FLAG")) ){
					
					

					if(_checkDuple.size() >0){
						_rtnMsg ="차량번호:"+formData.get("CAR_NO")+ "는 이미 등록된 데이타이거나 등록하려는 데이타 중에 중복되어 있습니다." ;
						return _rtnMsg;

					}

					sqlSessionTemplate.update("master.wmdl.insertMasterWmDlIntervalsInfoReg", formData);
				}
				else if( "Y".equals(formData.get("SAVE_FLAG")) )
				{
					if(_checkDuple.size() ==0){
						_rtnMsg ="차량번호:"+formData.get("CAR_NO")+ "는 이미 등록되어 있지 않은 차량번호이므로 수정 할 수 없습니다." ;
						return _rtnMsg;

					}
					
					sqlSessionTemplate.update("master.wmdl.updateMasterWmDlIntervalsInfoReg", formData);
				}

			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg ="차량정보 등록 중 오류가 발생하였습니다. " ;
			throw new RuntimeException();
		}


		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				List<Map<String,Object>>  _checkDuple = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsInfoReg", formData);
				if(_checkDuple.size() ==0){
					_rtnMsg ="아이디:"+formData.get("CAR_ID")+ "는 이미 등록된 데이타가 아니거나 삭제하려는 데이타 중에 중복되어 있습니다." ;
					throw new RuntimeException("아이디:"+formData.get("CAR_ID")+"는 이미 등록된 데이타가 아니거나 삭제하려는 데이타 중에 중복되어 있습니다..");
				}
				sqlSessionTemplate.update("master.wmdl.deleteMasterWmDlIntervalsInfoReg", formData);

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg ="아이디:"+formData.get("CAR_ID")+ "는 이미 등록된 데이타가 아니거나 삭제하려는 데이타 중에 중복되어 있습니다." ;
			throw new RuntimeException("아이디:"+formData.get("CAR_ID")+"는 이미 등록된 데이타가 아니거나 삭제하려는 데이타 중에 중복되어 있습니다..");
		}

		return _rtnMsg;		
		
	}	

}
