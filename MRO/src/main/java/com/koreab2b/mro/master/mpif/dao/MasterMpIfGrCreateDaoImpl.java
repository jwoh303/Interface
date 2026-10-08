package com.koreab2b.mro.master.mpif.dao;

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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIfGrCreateDao")
@Transactional
public class MasterMpIfGrCreateDaoImpl implements MasterMpIfGrCreateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfGrCreateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfGrCreateList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 실행
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String executeDataList(Map<String,String>  formData, List<Object> gridData) {
	
		_rtnMsg = "정상적으로 실행되었습니다.";
		Map<String, Object> resultMap = null;
		int errCode = 0;
		
		try{
			
//			resultMap = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderCreateErrorCount", formData);
//			if(!(resultMap.get("CNT").toString()).equals("0")){
//				System.out.println(resultMap.get("CNT").toString());
//				System.out.println(resultMap.get("CNT").toString().equals("0"));
//				System.out.println((resultMap.get("CNT").toString()).equals("0"));
//				errCode = 1;
//				throw new RuntimeException();
//			}
			
			sqlSessionTemplate.insert("master.mpif.executeMasterMpIfGrCreate", formData);
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfGrFlagAll", formData);
			
		}catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if(errCode == 1){
				_rtnMsg = "실행 대상건 중 오류 건이 있습니다. 확인후 재실행 하시기바립니다.";
			}else{
				_rtnMsg = "실행 중 오류가 발생하였습니다.";
			}
			
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _jobKind = formData.get("job_kind");
		String _checkResult = "";
		try {
			
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 저장되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					if(formData.get("IF_FLAG").equals("1")){
						throw new RuntimeException("입고생성 중인 경우 저장 불가능 합니다.");
					}

					
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfGrCreate", formData);
					
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			
			if ( "save".equals(_jobKind) ) {
				throw new RuntimeException("\n\n- 저장 실패 -\n\n담당자에게 연락 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제 되었습니다";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfGrCreate", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}	
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData) {

		_rtnMsg = "업로드가 완료되었습니다.";
		String _checkResult = "";
		String st_com_code = "";
		String BUYER = "";
		String LEGACY_PO_NO = "";
		String LEGACY_PO_SEQ = "";
		String LEGACY_GR_NO = "";
		String LEGACY_GR_SEQ = "";
		String BUYER_ITEM_NO = "";
		String GR_DATE = "";
		String GR_QTY = "";
		int errCode = 0;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateSelectedDataExcelCheck  formData {} " , formData);
				
				st_com_code = CommonUtil.nvl(formData.get("st_com_code"),"");
				BUYER = CommonUtil.nvl(formData.get("st_com_code"),"");
				LEGACY_PO_NO = CommonUtil.nvl(formData.get("LEGACY_PO_NO"),"");
				LEGACY_PO_SEQ = CommonUtil.nvl(formData.get("LEGACY_PO_SEQ"),"");
				LEGACY_GR_NO = CommonUtil.nvl(formData.get("LEGACY_GR_NO"),"");
				LEGACY_GR_SEQ = CommonUtil.nvl(formData.get("LEGACY_GR_SEQ"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				GR_QTY = CommonUtil.nvl(formData.get("GR_QTY"),"");
				GR_DATE = CommonUtil.nvl(formData.get("GR_DATE"),"");
				
				// 필수값 체크
				System.out.println(BUYER+"/"+LEGACY_PO_NO+"/"+LEGACY_PO_SEQ+"/"+BUYER_ITEM_NO+"/"+GR_DATE+"/"+GR_QTY+"/");
				if("".equals(BUYER)
						|| "".equals(LEGACY_GR_NO)
						|| "".equals(LEGACY_GR_SEQ)
						|| "".equals(LEGACY_PO_NO)
						|| "".equals(LEGACY_PO_SEQ)
						|| "".equals(BUYER_ITEM_NO)
						|| "".equals(GR_DATE)
						|| "".equals(GR_QTY)){
					errCode = 1;
					throw new RuntimeException();
				}
					
				// 고객사코드 체크. 선택 고객사와 업로드 데이터의 고객사가 다른경우.
				if(!st_com_code.equals(BUYER)){
					errCode = 2;
					throw new RuntimeException();
				}
				
				// 허용 고객사 체크
				List<Map<String,Object>> chkCompany = null;
				chkCompany = sqlSessionTemplate.selectList("master.mpif.getMasterMpIfOrderCreateComcodeCheck",formData);
				if(chkCompany.size()>0){
					if( "0".equals(chkCompany.get(0).get("CNT").toString()) ){
						errCode = 3;
						throw new RuntimeException();
					}
				}
								
				/*삭제 중복제거*/
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfGrCreate", formData);
				
				/*인서트*/
				sqlSessionTemplate.update("master.mpif.saveMasterMpIfGrCreate",formData);
//				
//				if(!_checkResult.equals("")){
//					formData.put("ERROR_MSG", _checkResult);
//					formData.put("IF_FLAG", "E");
//				}else{
//					formData.put("ERROR_MSG", "");
//					formData.put("IF_FLAG", "N");
//				}
				System.out.println("ERROR MSG : "+_checkResult);
				formData.put("ERROR_MSG", _checkResult);
				formData.put("IF_FLAG", "N");
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfGrFlag", formData);

			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if(errCode == 1){
				throw new RuntimeException("필수값이 누락되었습니다.");
			}else if(errCode == 2){
				throw new RuntimeException("선택된 고객사와 업로드데이터의 고객사가 다릅니다.");
			}else if(errCode == 3){
				throw new RuntimeException("I/F입고 생성 허용된 고객사가 아닙니다.");
			}else{
				throw new RuntimeException("엑셀 검증에 실패하였습니다.");
			}
			
		}
		
		return _rtnMsg;
	}

}
