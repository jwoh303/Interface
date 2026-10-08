package com.koreab2b.mro.export.exol.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("exportExOlExportProgressDao")
@Transactional
public class ExportExOlExportProgressDaoImpl implements ExportExOlExportProgressDao {
	private static final Logger logger = LoggerFactory.getLogger(ExportExOlExportProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("export.exol.selectExportExOlExportProgressList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressList", param);
	    }
		return resultList;
	}

	// 저장, 납품완료
	@SuppressWarnings("unchecked")
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				sqlSessionTemplate.update("export.exol.updateExportExOlExportProgressHd", formData);
				sqlSessionTemplate.update("export.exol.updateExportExOlExportProgressBlHd", formData);
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "저장에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}

	// CI, PL 삭제
	@SuppressWarnings("unchecked")
	public String updateSelectedCiData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// ICOMIVDT PKG_CI_QTY 수량 업데이트
				sqlSessionTemplate.insert("export.exol.updateExportExOlExportIcomivdt", formData);
				// WMSIVDT PKG_CI_QTY 수량 업데이트
				sqlSessionTemplate.insert("export.exol.updateExportExOlExportWmsivdt", formData);
				// CIDT 수정
				sqlSessionTemplate.update("export.exol.deleteCiExportExOlExportProgressCidt", formData);
				// CIHD 수정
				sqlSessionTemplate.update("export.exol.deleteCiExportExOlExportProgressCihd", formData);
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "삭제에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	
	// BL 삭제
	@SuppressWarnings("unchecked")
	public String updateSelectedBlData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제되었습니다.";
		String _endChk = null;
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 삭제 대상 BL 중 납품완료된 건이 있는지 있는지 확인
				_endChk = (String)sqlSessionTemplate.selectOne("export.exol.selectExportExOlExportEndCheck", formData);
				
				if(Integer.parseInt(_endChk) > 0){
					_rtnMsg = (i+1)+"번째 B/L 중 납품완료된 건이 있어 삭제할 수 없습니다.";
					throw new RuntimeException(_rtnMsg);
				}else{
					
					// CIHD BL_COMPLETE_MARK 변경
					sqlSessionTemplate.update("export.exol.deleteBlExportExOlExportProgressCihd", formData);
					
					// BLDT 삭제
					sqlSessionTemplate.update("export.exol.deleteBlExportExOlExportProgressBldt", formData);
					
					// BLHD 삭제
					sqlSessionTemplate.update("export.exol.deleteBlExportExOlExportProgressBlhd", formData);					
					
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "삭제에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
}
