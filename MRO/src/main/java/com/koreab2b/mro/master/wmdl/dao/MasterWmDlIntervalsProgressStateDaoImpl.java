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

@Repository("masterWmDlIntervalsProgressStateDao")
@Transactional
public class MasterWmDlIntervalsProgressStateDaoImpl implements MasterWmDlIntervalsProgressStateDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlIntervalsProgressStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlIntervalsProgressStateList", param);
	}

	// 리스트 조회
	public List<Map<String,String>> getPopCnt(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlIntervalsProgressStatePopCnt", param);
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		
		try{
			List<Map<String,String>> rtnList;
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));
				

				
				//update
				if("Y".equals(formData.get("SAVE_FLAG"))){
					
					rtnList = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsProgressState", formData);
					if(rtnList.size() == 0){
						_rtnMsg = "수정하고자 하는 차량 정보가 등록되어 있지 않습니다." ;
						return _rtnMsg;
					}
				
					if("Y".equals(formData.get("BASE_YN"))){
						
						rtnList = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsProgressStateBaseYN", formData);
						
						if(rtnList.size() >0){
							
							_rtnMsg = "이미 기본 차량으로  등록된 차량이  있습니다." ;
							return _rtnMsg;
						
						}
						
					}
					sqlSessionTemplate.update("master.wmdl.updateMasterWmDlIntervalsProgressState", formData);
					
				}
				else{  //insert
					
				
					rtnList = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsProgressState", formData);
					if(rtnList.size() >0){
						_rtnMsg = "등록하고자 하는 차량과 같은  차량이 등록이 되어 있습니다." ;
						return _rtnMsg;
					}
					
					if("Y".equals(formData.get("BASE_YN"))){
						
						rtnList = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsProgressStateBaseYN", formData);
						
						if(rtnList.size() >0){
							
							_rtnMsg = "이미 기본 차량으로  등록된 차량이  있습니다." ;
							return _rtnMsg;
						
						}
					
					}
					sqlSessionTemplate.update("master.wmdl.insertMasterWmDlIntervalsProgressState", formData);
				}
					

	
			    
			}
			
		} catch (RuntimeException e){
			_rtnMsg = "차량등록 시 오류가 발생 하였습니다." ;

		}
		return _rtnMsg;
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedPopData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		
		try{
				
			sqlSessionTemplate.update("master.wmdl.insertMasterWmDlIntervalsProgressStatePop", formData);
	
			
		} catch (Exception e){
			_rtnMsg = "일일배송 횟수 등록에 실패 하였습니다." ;
			throw new RuntimeException("일일배송 횟수 등록에 실패 하였습니다." );
		}
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		
		try{
			List<Map<String,String>> rtnList;
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));						
				rtnList = sqlSessionTemplate.selectList("master.wmdl.checktDuplicationMasterWmDlIntervalsProgressState", formData);
				if(rtnList.size() ==0){
					_rtnMsg = "차량아이디:"+formData.get("CAR_ID")+"는 이미 등록된 차량아이디가 아니거나 삭제할 목록 중에 중복하여 존재 합니다. " ;
					return _rtnMsg;
					//throw new RuntimeException( "차량아이디:"+formData.get("CAR_ID")+"는 이미 등록된 차량아이디가 아니거나 삭제할 목록 중에 중복하여 존재 합니다. " );
				}
				sqlSessionTemplate.update("master.wmdl.deleteMasterWmDlIntervalsProgressState", formData);

			}
		}catch(Exception e){
			_rtnMsg = "차량아이디:"+formData.get("CAR_ID")+"는 이미 등록된 차량아이디가 아니거나 삭제할 목록 중에 중복하여 존재 합니다. " ;
			throw new RuntimeException( "차량아이디:"+formData.get("CAR_ID")+"는 이미 등록된 차량아이디가 아니거나 삭제할 목록 중에 중복하여 존재 합니다. " );
		}

		return _rtnMsg;		
		
	}	

}
