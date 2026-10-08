package com.koreab2b.mro.export.exbl.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
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

@Repository("exportExBlExportBlProcDao")
@Transactional
public class ExportExBlExportBlProcDaoImpl implements ExportExBlExportBlProcDao {
	private static final Logger logger = LoggerFactory.getLogger(ExportExBlExportBlProcDaoImpl.class);

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
			sqlSessionTemplate.select("export.exbl.selectExportExBlExportBlProcList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("export.exbl.selectExportExBlExportBlProcList", param);
	    }
		return resultList;
	}
	// 리스트 상세 조회
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_key"),"@");
		if(_list.size() > 0){
			param.put("st_key", _list);
		}
		return sqlSessionTemplate.selectList("export.exbl.selectExportExBlExportBlProcDetail", param);
	}

	// B/L 등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		String _blCnt = null;
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// B/L등록 시 House B/L No 등록 여부 체크
				_blCnt = (String)sqlSessionTemplate.selectOne("export.exbl.selectExportExBlHouseBlCheck", formData);
				logger.debug("_blCnt ==>> " + _blCnt);
				//House B/L no 등록되어 있으면 같은 번호로 등록 불가능.
				if(Integer.parseInt(_blCnt) > 0){
					_rtnMsg = "등록 된 B/L가 존재함으로 입력한 B/L번호로 등록 불가능 합니다.";
					throw new RuntimeException(_rtnMsg);
				} else {
					formData.put("BL_SEQ", String.valueOf(i+1));
					//INSERT KEP_EXP_BLDT
					sqlSessionTemplate.insert("export.exbl.insertExportExBlKepExpBlDt", formData);
					//BL_COMPLETE_MARK Y 업데이트
					sqlSessionTemplate.insert("export.exbl.updateExportExBlKepExpCiDt", formData);
					
					//INSERT KEP_EXP_BLHD 마지막
					logger.debug("gridData.size()-1 : {}", gridData.size()-1);
					if(i==gridData.size()-1){
						sqlSessionTemplate.insert("export.exbl.insertExportExBlKepExpBlHd", formData);
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "B/L 등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
}
