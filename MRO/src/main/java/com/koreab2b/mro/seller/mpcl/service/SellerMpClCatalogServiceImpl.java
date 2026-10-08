package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.seller.mpcl.dao.SellerMpClCatalogDao;

@Service("sellerMpClCatalogService")
public class SellerMpClCatalogServiceImpl implements SellerMpClCatalogService {
	
	@Autowired
	private SellerMpClCatalogDao sellerMpClCatalogDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClCatalogDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return sellerMpClCatalogDao.selectExcelList(formData);
	}	
	
	// 재고등록
	@Transactional
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpClCatalogDao.updateSelectedData(formData, gridData);
	}	
	//이미지등록요청
	public String saveSellerMpClCatalogImg(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCatalogDao.saveSellerMpClCatalogImg(uploadForm,formData);
	}	 	  
	//이미지등록
	public String saveSellerMpClCatalogImgFile(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCatalogDao.saveSellerMpClCatalogImgFile(uploadForm,formData);
	}
	//상세이미지등록
	public String saveSellerMpClCatalogDetailImgFile(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCatalogDao.saveSellerMpClCatalogDetailImgFile(uploadForm,formData);
	}
	//이미지등록 (v2 - 나노초 포함)
	public String saveSellerMpClCatalogImgFile_v2(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCatalogDao.saveSellerMpClCatalogImgFile_v2(uploadForm,formData);
	}
	//상세이미지등록 (v2 - 나노초 포함)
	public String saveSellerMpClCatalogDetailImgFile_v2(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCatalogDao.saveSellerMpClCatalogDetailImgFile_v2(uploadForm,formData);
	}
	//이미지등록 요청리스트
	public List<Map<String,String>> getSellerMpClCatalogImgPopList(Map<String,String> formData) {
		return sellerMpClCatalogDao.getSellerMpClCatalogImgPopList(formData);
	}

	/**
	 * 거래품목 조회 (리뉴얼 - v2)
	 * - 페이징 없음
	 * - 새로운 검색 조건 적용
	 *
	 * @param formData 검색 파라미터
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> getListV2(Map<String,String> formData) {
		return sellerMpClCatalogDao.selectListV2(formData);
	}

	/**
	 * 거래품목 조회 (리뉴얼 - v2) - 페이징
	 * - 무한 스크롤용 페이징 처리
	 *
	 * @param formData 검색 파라미터 (startRow, endRow 포함)
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> getListV2Paging(Map<String,String> formData) {
		return sellerMpClCatalogDao.selectListV2Paging(formData);
	}

	/**
	 * 거래품목 총 건수 조회 (리뉴얼 - v2)
	 * - 무한 스크롤용 총 건수
	 *
	 * @param formData 검색 파라미터
	 * @return 총 건수
	 */
	public int getListV2Count(Map<String,String> formData) {
		return sellerMpClCatalogDao.selectListV2Count(formData);
	}

}
