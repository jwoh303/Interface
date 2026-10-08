package com.koreab2b.mro.master.mdcm.dao;

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

@Repository("masterMdCmChemicalMatInfoDao")
@Transactional
public class MasterMdCmChemicalMatInfoDaoImpl implements MasterMdCmChemicalMatInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmChemicalMatInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmChemicalMatInfoList", param);
	}
	// 조회
	public List<Map<String,String>> getMasterMdCmChemicalMatInfoHdList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmChemicalMatInfoHdList", formData);
	}
	// 취소
	public String cancleMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try {
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("master.mdcm.checkMasterMdCmChemicalMatInfo",formData);
			String resultYn = CommonUtil.getListKeyValue(_list,"RESULT_YN","");
			//실적등록처리 확인
			if(resultYn.equals("Y")){
				_rtnMsg = "실적등록 처리 된 품목이므로 삭제 불가능합니다.";
				throw new RuntimeException(_rtnMsg);
			}
			//화학물질 삭제
			sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmChemicalMatByit", formData);
			sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmChemicalMatMake", formData);
			//ICOMBYIT 물질상태 초기화
			sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmChemicalMatIcombyit", formData);
		} catch (Exception e) {
			_rtnMsg = "처리에 실패했습니다.";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 되었습니다.";
		
		try {
			//유해화학물질 여부
			String stHarmfulYn = formData.get("st_harmful_yn");
			List<Map<String,String>>_list2 = null;
			_list2 = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmKepCmcByitSeq",formData);
			String stSeq = CommonUtil.getListKeyValue(_list2,"CMC_SEQ","1");
			formData.put("CMC_SEQ", stSeq);
			//기존정보 물질정보 삭제처리STATUS = 'D'처리.
			sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmChemicalMatByit", formData);
			sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmChemicalMatMake", formData);
			//물질정보 등록
			sqlSessionTemplate.update("master.mdcm.saveMasterMdCmChemicalMatByit", formData);
			//조성정보 신규insert
			if(stHarmfulYn.equals("Y")){//유해확물질 여부
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					//물질 조성정보 등록 
					sqlSessionTemplate.update("master.mdcm.saveMasterMdCmChemicalMatMake", formData);
				}				
			}else{
				//물질 조성정보 등록 
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmChemicalMatMake2", formData);				
			}
		} catch (Exception e) {
			_rtnMsg = "저장 실패했습니다.";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 실패했습니다.");
		}
		return _rtnMsg;
	}
}
