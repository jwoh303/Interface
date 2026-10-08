package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCmsBuyInfoExcelUploadDao")
@Transactional
public class MasterMdCmCmsBuyInfoExcelUploadDaoImpl implements MasterMdCmCmsBuyInfoExcelUploadDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectItemList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoRegItemList", param);
	}

	public List<Map<String,String>> selectExistingKeyList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoRegDupKeyList", param);
	}

	public List<Map<String,String>> selectAgentList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoRegAgentList", param);
	}

	public List<Map<String,String>> selectItemMakeTypeList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoItemMakeTypeList");
	}

	public List<Map<String,String>> selectWarehouseList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoWarehouseList");
	}

	public List<Map<String,String>> selectModBeforeList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoModBeforeList", param);
	}

	public List<Map<String,String>> selectSupplyReasonList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoSupplyReasonList");
	}

	public List<Map<String,String>> selectTaxTypeList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoTaxTypeList");
	}

	public List<String> selectCatlgExists(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoCatlgExists", param);
	}

	public int updateBuyInfoMod(Map<String,Object> param) {
		return sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsBuyInfoModApplyBulk", param);
	}

	/* ⚠ INSERT ... SELECT 는 <update> 로 선언돼 있다 - 전역 useGeneratedKeys=true 가
	 *   <insert> 에 RETURNING 을 덧붙여 ORA-00933 이 난다. update() 로 부를 것. */
	public int insertBuyInfo(Map<String,Object> param) {
		return sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsBuyInfoReg", param);
	}
}
