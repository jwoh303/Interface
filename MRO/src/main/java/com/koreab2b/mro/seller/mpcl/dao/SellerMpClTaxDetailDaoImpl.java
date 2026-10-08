package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * 전자세금계산서 상세내역 DAO 구현체
 * Java 1.6 호환성 유지
 */
@Repository("sellerMpClTaxDetailDao")
@Transactional
public class SellerMpClTaxDetailDaoImpl implements SellerMpClTaxDetailDao {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    /**
     * 세금계산서 번호를 기준으로 상세 발주내역 조회
     * @param formData 검색 조건 (taxBillNo 포함)
     * @return 상세 발주내역 리스트
     */
    public List<Map<String, String>> selectTaxDetailList(Map<String, String> formData) {
        return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClTaxDetailList", formData);
    }

}