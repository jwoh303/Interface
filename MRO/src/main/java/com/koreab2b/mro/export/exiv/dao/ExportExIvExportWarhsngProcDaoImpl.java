package com.koreab2b.mro.export.exiv.dao;

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

@Repository("exportExIvExportWarhsngProcDao")
@Transactional
public class ExportExIvExportWarhsngProcDaoImpl implements ExportExIvExportWarhsngProcDao {
	private static final Logger logger = LoggerFactory.getLogger(ExportExIvExportWarhsngProcDaoImpl.class);

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
		List< String > _polist = new ArrayList< String >( );
		_polist = CommonUtil.getStringArrary((String) param.get("st_po_no_multi"),"@");
		if(_polist.size() > 0){
			param.put("st_poArr", _polist);
		}
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("export.exiv.selectExportExIvExportWarhsngProcList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportWarhsngProcList", param);
	    }
		return resultList;
	}
	//납품번호 조회
	public List<Map<String,String>> selectDetail(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportWarhsngDetail", formData);
	}
	
	// 납품번호 조회 품목
	public List<Map<String,String>> selectDetailData(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportWarhsngDetailData", formData);
	}
	// 입고등록
	@SuppressWarnings("unchecked")
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "입고등록 처리가 되었습니다.";
		String _grCnt = null;
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExivPkgGrQtyHdCheck", formData);
				logger.debug("_grCnt ==>> " + _grCnt);
				if(Integer.parseInt(_grCnt) > 0){
					_rtnMsg = (i+1)+"번째 입고 등록건 입니다.\n 재조회 후 다시 등록하시기 바랍니다.";
				} else {
					logger.debug("PROCESS_TYPE ==>> " +formData.get("PROCESS_TYPE"));	
					if(formData.get("PROCESS_TYPE").equals("0")){
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportWarhsngProcHd", formData);
					}else{
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportWarhsngProcTrHd", formData);						
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 상세입고등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		String _grCnt = null;
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grCnt = (String)sqlSessionTemplate.selectOne("export.exiv.selectExportExivPkgGrQtyCheck", formData);
				logger.debug("_grCnt ==>> " + _grCnt);
				if(Integer.parseInt(_grCnt) > 0){
					_rtnMsg = (i+1)+"번째 입고 등록건 입니다.\n 재조회 후 다시 등록하시기 바랍니다.";
				} else {
					logger.debug("PROCESS_TYPE ==>> " +formData.get("PROCESS_TYPE"));	
					if(formData.get("PROCESS_TYPE").equals("0")){
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportWarhsngProc", formData);
					}else{
						sqlSessionTemplate.insert("export.exiv.updateExportExIvExportWarhsngProcTr", formData);						
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 상세 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		List< String > _polist = new ArrayList< String >( );
		_polist = CommonUtil.getStringArrary((String) param.get("st_po_multi"),"@");
		if(_polist.size() > 0){
			param.put("st_poArr", _polist);
		}
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("export.exiv.selectExportExIvExportWarhsngProcDetail", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("export.exiv.selectExportExIvExportWarhsngProcDetail", param);
	    }
		return resultList;
	}
}
