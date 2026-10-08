package com.koreab2b.mro.seller.mdct.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMdCtChemicalMatSendDao")
@Transactional
public class SellerMdCtChemicalMatSendDaoImpl implements SellerMdCtChemicalMatSendDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMdCtChemicalMatSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtChemicalMatSendList", param);
	}
		// 물질정보 제출
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "물질정보 제출 처리 되었습니다.";
		
		try {
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtKepCmcReqStatus",formData);
			String reqStatus = CommonUtil.getListKeyValue(_list,"REQ_STATUS","");
			//유해화학물질 여부
			String stHarmfulYn = formData.get("st_harmful_yn");
			
			//협력사제출일 경우 요청상태일경우만 제출 가능함.
			if(!reqStatus.equals("Q")&&!reqStatus.equals("R")){
				//운영사 제출, 화학물질 최종승인시 처리 불가능 로직
				_rtnMsg = "물질정보 제출처리가 되어 제출 불가능 합니다..";
				throw new RuntimeException(_rtnMsg);
			}				
			//물질정보 업데이트
			sqlSessionTemplate.update("seller.mdct.updateSellerMdCmChemicalMatSend", formData);
			//조성정보 삭제
			sqlSessionTemplate.update("seller.mdct.deleteSellerMdCmChemicalMatMakeSend", formData);
			//조성정보 신규insert
			if(stHarmfulYn.equals("Y")){//유해확물질 여부
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					LOGGER.debug("updateSelectedData 요청 파라미터 : formData {}", formData.get("sStatus"));
					//조성정보 INSERT - 추후 불필요 시 삭제 가능
					//sqlSessionTemplate.update("seller.mdct.saveSellerMdCmChemicalMatMakeSend", formData);
				}				
			}
		} catch (Exception e) {
			_rtnMsg = "물질정보 제출 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("물질정보 제출 처리에 실패했습니다.");
		}
		
		return _rtnMsg;
	}
	// 물질정보 제출 V2
	@SuppressWarnings("unchecked")
	public String updateSelectedDataV2(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "물질정보 제출 처리 되었습니다.";

		try {
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtKepCmcReqStatus",formData);
			String reqStatus = CommonUtil.getListKeyValue(_list,"REQ_STATUS","");
			//유해화학물질 여부
			String stHarmfulYn = formData.get("st_harmful_yn");

			//협력사제출일 경우 B, C 상태에서만 수정 불가
			// B: 발주 후 제출, C: 승인완료 상태에서는 수정 불가
			// 그 외 모든 상태 (Q, R, S, P, A, M 등)에서는 수정 가능
			if(reqStatus.equals("B") || reqStatus.equals("C")){
				//운영사 제출, 화학물질 최종승인시 처리 불가능 로직
				_rtnMsg = "물질정보 제출처리가 되어 제출 불가능 합니다. (현재 상태: " + reqStatus + ")";
				throw new RuntimeException(_rtnMsg);
			}
			//물질정보 업데이트 - V2 쿼리 호출
			sqlSessionTemplate.update("seller.mdct.updateSellerMdCmChemicalMatSendV2", formData);
			//조성정보 삭제
			sqlSessionTemplate.update("seller.mdct.deleteSellerMdCmChemicalMatMakeSend", formData);
			//조성정보 신규insert
			if(stHarmfulYn.equals("Y")){//유해확물질 여부
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					LOGGER.debug("updateSelectedDataV2 요청 파라미터 : formData {}", formData.get("sStatus"));
					//조성정보 INSERT - 추후 불필요 시 삭제 가능
					//sqlSessionTemplate.update("seller.mdct.saveSellerMdCmChemicalMatMakeSend", formData);
				}
			}

			// 첨부파일 삭제 처리 (테이블에서 완전 삭제)
			String deletedFilesJson = CommonUtil.nvl(formData.get("st_deleted_files"), "");
			if (!deletedFilesJson.isEmpty()) {
				try {
					// JSON 문자열을 List<String>로 파싱 (파일명 배열)
					ObjectMapper mapper = new ObjectMapper();
					List<String> deletedFileNames = mapper.readValue(
						deletedFilesJson,
						new TypeReference<List<String>>() {}
					);

					LOGGER.debug("삭제할 파일 목록: {}", deletedFileNames);

					// 현재 REQ_NO의 fileKey 조회
					String currentFileKey = CommonUtil.nvl(formData.get("st_msds_file_key"), "");

					if (!currentFileKey.isEmpty()) {
						// ICOMATCH에서 현재 fileKey로 등록된 모든 파일 조회
						Map<String, String> fileQueryParams = new HashMap<String, String>();
						fileQueryParams.put("DOC_NO", currentFileKey);

						List<Map<String, String>> existingFiles = sqlSessionTemplate.selectList(
							"common.getDetailIcomatch_v2",
							fileQueryParams
						);

						LOGGER.debug("기존 등록된 파일 목록: {}", existingFiles);

						// 삭제 대상 파일과 매칭하여 ICOMATCH 테이블에서 완전 삭제
						int deletedCount = 0;
						for (String deletedFileName : deletedFileNames) {
							for (Map<String, String> existingFile : existingFiles) {
								if (deletedFileName.equals(existingFile.get("SRC_FILE_NAME"))) {
									// 매칭되는 파일 테이블에서 완전 삭제
									Map<String, String> updateParams = new HashMap<String, String>();
									updateParams.put("D_DOC_NO", existingFile.get("DOC_NO"));
									updateParams.put("D_DOC_SEQ", existingFile.get("DOC_SEQ"));

									sqlSessionTemplate.delete("common.removeIcomatch", updateParams);
									deletedCount++;

									LOGGER.info("파일 삭제 완료 (DELETE) - DOC_NO: {}, DOC_SEQ: {}, SRC_FILE_NAME: {}",
										new Object[]{existingFile.get("DOC_NO"), existingFile.get("DOC_SEQ"), deletedFileName}
									);
									break;
								}
							}
						}

						LOGGER.info("총 {}개 파일 삭제 완료", deletedCount);
					}
				} catch (Exception e) {
					LOGGER.error("첨부파일 삭제 처리 중 오류 발생", e);
					throw new RuntimeException("첨부파일 삭제 처리에 실패했습니다.");
				}
			}
		} catch (Exception e) {
			_rtnMsg = "물질정보 제출 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("물질정보 제출 처리에 실패했습니다.");
		}

		return _rtnMsg;
	}
	//물질정보 상세 팝업 조성정보 조회
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerChemicalMatRegPopList", param);
	}	
	// 조회
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPopHd(Map<String,String> formData) {
		String quotation_no = CommonUtil.nvl(formData.get("st_quotation_no"), "");
		String quotation_seq = CommonUtil.nvl(formData.get("st_quotation_seq"), "");
		String revision = CommonUtil.nvl(formData.get("st_revision"), "0");

		// NULL을 빈 문자열로 변환하여 formData에 저장 (Oracle JDBC 타입 에러 방지)
		formData.put("st_quotation_no", quotation_no);
		formData.put("st_quotation_seq", quotation_seq);
		formData.put("st_revision", revision);

		if(!"".equals(quotation_no) && !"".equals(quotation_seq) && !"".equals(revision)) { 
			// 견적 정보로 조회
			return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtChemicalMatRegRfqPopHd", formData);
		}else { 
			// 카탈로그 정보로 조회
			return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtChemicalMatRegPopHd", formData);
		}
	}
	// 물질정보 오분류
	@SuppressWarnings("unchecked")
	public String returnSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "물질정보 오분류 처리 되었습니다.";

		try {
			sqlSessionTemplate.update("seller.mdct.returnSellerMdCtChemicalMatSendList", formData);
		} catch (Exception e) {
			_rtnMsg = "물질정보 오분류 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("물질정보 오분류 처리에 실패했습니다.");
		}
		return _rtnMsg;
	}
	// 물질정보 오분류 V2
	@SuppressWarnings("unchecked")
	public String returnSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "물질정보 오분류 처리 되었습니다.";

		try {
			sqlSessionTemplate.update("seller.mdct.returnSellerMdCtChemicalMatSendListV2", formData);
		} catch (Exception e) {
			_rtnMsg = "물질정보 오분류 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("물질정보 오분류 처리에 실패했습니다.");
		}
		return _rtnMsg;
	}
	// 발주 후 제출(협력사)
	@SuppressWarnings("unchecked")
	public String afterSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "발주 후 제출 처리 되었습니다.";

		try {
			sqlSessionTemplate.update("seller.mdct.afterSellerMdCtChemicalMatSendList", formData);
		} catch (Exception e) {
			_rtnMsg = "발주 후 제출 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주 후 제출 처리에 실패했습니다.");
		}
		return _rtnMsg;
	}
	// 발주 후 제출(협력사) V2
	@SuppressWarnings("unchecked")
	public String afterSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "발주 후 제출 처리 되었습니다.";

		try {
			sqlSessionTemplate.update("seller.mdct.afterSellerMdCtChemicalMatSendListV2", formData);
		} catch (Exception e) {
			_rtnMsg = "발주 후 제출 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주 후 제출 처리에 실패했습니다.");
		}
		return _rtnMsg;
	}
}
