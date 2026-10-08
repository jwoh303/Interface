package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCmsItemExcelUploadDao")
@Transactional
public class MasterMdCmCmsItemExcelUploadDaoImpl implements MasterMdCmCmsItemExcelUploadDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 카테고리별 동적 속성 컬럼 정의 조회 (실 속성 테이블 연결용 seam)
	public List<Map<String,String>> selectAttrColumns(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadAttrColumns", param);
	}

	// 담당(세션 사용자) 카테고리별 속성 조회 (CMS_CATEG_ID + ATTR1~20)
	public List<Map<String,String>> selectFormList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadFormList", param);
	}

	// 일괄수정 결과 - 업로드한 상품정보코드의 [기존](현재) 값
	public List<Map<String,String>> selectBeforeList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadBeforeList", param);
	}

	// 일괄수정 결과 - 대체코드 실재 여부
	public List<String> selectCodeExists(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadCodeExists", param);
	}

	// 일괄수정 - 제조사코드(ICOMCOD1 M104) 실재 여부
	public List<String> selectMakerExists(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadMakerExists", param);
	}

	// 일괄수정 - 원산지코드(ICOMCOD1 M001) 실재 여부
	public List<Map<String,String>> selectMakerNames(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadMakerNames", param);
	}

	public List<String> selectOriginExists(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadOriginExists", param);
	}

	// 일괄수정 양식 - 상품상태 변경사유 목록(ICOMCOD1 M182)
	public List<Map<String,String>> selectReasonList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemExcelUploadReasonList");
	}

	// 일괄수정 양식 - TR취급가능여부 목록(M181). 상세팝업 셀렉트와 같은 statement 를 쓴다
	public List<Map<String,String>> selectTrHandleList() {
		return sqlSessionTemplate.selectList("master.mdcm.getCmsItemTrHandleCodeList");
	}

	// 기준가 일괄수정 - [기존] 기준가 값
	public List<Map<String,String>> selectBasePriceBeforeList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemBasePriceBeforeList", param);
	}

	// 기준가 일괄수정 - 기준가유형 목록(ICOMCOD1 M183)
	public List<Map<String,String>> selectBasePriceTypeList() {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemBasePriceTypeList");
	}

}
