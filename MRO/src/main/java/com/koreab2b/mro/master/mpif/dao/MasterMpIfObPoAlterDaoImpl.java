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

@Repository("masterMpIfObPoAlterDao")
public class MasterMpIfObPoAlterDaoImpl implements MasterMpIfObPoAlterDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfOrderCreateDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> pMap) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfObPoAlterList", pMap, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

	return resultList;
	}

	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "업로드가 완료되었습니다.";
		String _checkResult = "";
		String st_com_code = "";
		String BUYER = "";
		String LEGACY_PO_NO = "";
		String BUYER_ITEM_NO = "";
		String MOBILE_NUMBER = "";
		String DELY_TO_LOCATION_TEXT = "";
		String REMARK = "";
		String IF_FLAG = "N";
		int errCode = 0;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateSelectedDataExcelCheck  formData {} " , formData);
				
				st_com_code = CommonUtil.nvl(formData.get("st_com_code"),"");
				BUYER = CommonUtil.nvl(formData.get("BUYER"),"");
				LEGACY_PO_NO = CommonUtil.nvl(formData.get("LEGACY_PO_NO"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				MOBILE_NUMBER = CommonUtil.nvl(formData.get("MOBILE_NUMBER"),"");
				DELY_TO_LOCATION_TEXT = CommonUtil.nvl(formData.get("DELY_TO_LOCATION_TEXT"),"");
				REMARK = CommonUtil.nvl(formData.get("REMARK"),"");
				
				// 필수값 체크
				System.out.println(BUYER+"/"+LEGACY_PO_NO+"/"+BUYER_ITEM_NO+"/"+MOBILE_NUMBER+"/");
				if("".equals(BUYER)
						|| "".equals(BUYER)
						|| "".equals(LEGACY_PO_NO)
						|| "".equals(BUYER_ITEM_NO)
						|| "".equals(MOBILE_NUMBER)
						){
					errCode = 1;
					throw new RuntimeException();
				}
				
				/*삭제 중복제거*/
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfObPoAlter", formData);
				
				/*인서트*/
				sqlSessionTemplate.update("master.mpif.saveMasterMpIfObPoAlter",formData);
			}
			
		}catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if(errCode == 1){
				throw new RuntimeException("필수값이 누락되었습니다.");
			}
		}
		return _rtnMsg;
	}

	// 실행
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String executeDataList(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 실행되었습니다.";
		Map<String, Object> resultMap = null;
		int errCode = 0;
		
		try{
	
			sqlSessionTemplate.update("master.mpif.callMasterMpIfObPoAlter", formData);	
			
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

	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData) {
	_rtnMsg = "정상적으로 삭제 되었습니다";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfObPoAlterList", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}

}
