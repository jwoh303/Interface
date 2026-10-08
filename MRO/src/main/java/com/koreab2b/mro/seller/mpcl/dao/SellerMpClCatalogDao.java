package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface SellerMpClCatalogDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 엑셀조회
	public List<Map<String,String>> selectExcelList(Map<String,String> formData);
	
	// 재고등록
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	
	//이미지등록요청
	public String saveSellerMpClCatalogImg(FileUploadForm uploadForm,Map<String,String>  formData);
	
	//이미지등록
	public String saveSellerMpClCatalogImgFile(FileUploadForm uploadForm,Map<String,String>  formData);
	
	//상세이미지등록
	public String saveSellerMpClCatalogDetailImgFile(FileUploadForm uploadForm,Map<String,String>  formData);

	//이미지등록 (v2 - 나노초 포함)
	public String saveSellerMpClCatalogImgFile_v2(FileUploadForm uploadForm,Map<String,String>  formData);

	//상세이미지등록 (v2 - 나노초 포함)
	public String saveSellerMpClCatalogDetailImgFile_v2(FileUploadForm uploadForm,Map<String,String>  formData);

	//이미지등록요청리스트팝업
	public List<Map<String,String>> getSellerMpClCatalogImgPopList(Map<String,String> formData);

	/**
	 * 거래품목 조회 (리뉴얼 - v2)
	 * - 페이징 없음
	 * - 새로운 검색 조건 (imageStatus, origin, manufacturer, itemName, specification)
	 *
	 * @param formData 검색 파라미터
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> selectListV2(Map<String,String> formData);

	/**
	 * 거래품목 조회 (리뉴얼 - v2) - 페이징
	 * - 무한 스크롤용 페이징 처리
	 *
	 * @param formData 검색 파라미터 (startRow, endRow 포함)
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> selectListV2Paging(Map<String,String> formData);

	/**
	 * 거래품목 총 건수 조회 (리뉴얼 - v2)
	 * - 무한 스크롤용 총 건수
	 *
	 * @param formData 검색 파라미터
	 * @return 총 건수
	 */
	public int selectListV2Count(Map<String,String> formData);
}
