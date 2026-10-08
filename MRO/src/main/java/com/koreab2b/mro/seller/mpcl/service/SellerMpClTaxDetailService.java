package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

/**
 * 전자세금계산서 상세내역 Service 인터페이스
 * Java 1.6 호환성 유지
 */
public interface SellerMpClTaxDetailService {

    /**
     * 세금계산서 번호를 기준으로 상세 발주내역 조회
     * @param formData 검색 조건 (taxBillNo 포함)
     * @return 상세 발주내역 리스트
     */
    List<Map<String, String>> getTaxDetailList(Map<String, String> formData);

}