/**
 * NE9090_KEPEH_SRMDH_ST_GR_INFO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_ST_GR_INFO  implements java.io.Serializable {
    /* 회사코드 */
    private java.lang.String companyCode;

    /* 입고예정번호 */
    private java.lang.String grNo;

    /* 입고예정순번 */
    private java.lang.String grSeq;

    /* 상태 */
    private java.lang.String status;

    /* KEP품번 */
    private java.lang.String itemNo;

    /* 설명 */
    private java.lang.String desc;

    /* 스펙 */
    private java.lang.String spec;

    /* PO번호 */
    private java.lang.String poNo;

    /* PO순번 */
    private java.lang.String poSeq;

    /* 계정 */
    private java.lang.String account;

    /* 수량 */
    private java.lang.String qty;

    /* 단위 */
    private java.lang.String unit;

    /* 단위금액 */
    private java.lang.String unitPrice;

    /* 입고예정금액 */
    private java.lang.String grPrice;

    /* 통화 */
    private java.lang.String currency;

    /* 자재문서년도 */
    private java.lang.String docYear;

    /* 입고예정일자 */
    private java.lang.String grDate;

    /* 입고장소 */
    private java.lang.String workArea;

    /* 디비전코드 */
    private java.lang.String divCode;

    /* 입고예정부서코드 */
    private java.lang.String grDept;

    /* 원입고예정번호 */
    private java.lang.String originGrNo;

    /* 입고예정시각 */
    private java.lang.String grTime;

    /* 입고담당자사번 */
    private java.lang.String grEmpNo;

    /* 입고담당자명 */
    private java.lang.String grEmpNm;

    /* 입고부서설명 */
    private java.lang.String grDeptDesc;

    /* 자재코드 */
    private java.lang.String mtrlNo;

    /* 사업장(3사업장 : D131 / 2사업장 : D121) */
    private java.lang.String plnt;

    /* 자재구분 */
    private java.lang.String itmGb;

    public NE9090_KEPEH_SRMDH_ST_GR_INFO() {
    }

    public NE9090_KEPEH_SRMDH_ST_GR_INFO(
           java.lang.String companyCode,
           java.lang.String grNo,
           java.lang.String grSeq,
           java.lang.String status,
           java.lang.String itemNo,
           java.lang.String desc,
           java.lang.String spec,
           java.lang.String poNo,
           java.lang.String poSeq,
           java.lang.String account,
           java.lang.String qty,
           java.lang.String unit,
           java.lang.String unitPrice,
           java.lang.String grPrice,
           java.lang.String currency,
           java.lang.String docYear,
           java.lang.String grDate,
           java.lang.String workArea,
           java.lang.String divCode,
           java.lang.String grDept,
           java.lang.String originGrNo,
           java.lang.String grTime,
           java.lang.String grEmpNo,
           java.lang.String grEmpNm,
           java.lang.String grDeptDesc,
           java.lang.String mtrlNo,
           java.lang.String plnt,
           java.lang.String itmGb) {
           this.companyCode = companyCode;
           this.grNo = grNo;
           this.grSeq = grSeq;
           this.status = status;
           this.itemNo = itemNo;
           this.desc = desc;
           this.spec = spec;
           this.poNo = poNo;
           this.poSeq = poSeq;
           this.account = account;
           this.qty = qty;
           this.unit = unit;
           this.unitPrice = unitPrice;
           this.grPrice = grPrice;
           this.currency = currency;
           this.docYear = docYear;
           this.grDate = grDate;
           this.workArea = workArea;
           this.divCode = divCode;
           this.grDept = grDept;
           this.originGrNo = originGrNo;
           this.grTime = grTime;
           this.grEmpNo = grEmpNo;
           this.grEmpNm = grEmpNm;
           this.grDeptDesc = grDeptDesc;
           this.mtrlNo = mtrlNo;
           this.plnt = plnt;
           this.itmGb = itmGb;
    }


    /**
     * Gets the companyCode value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return companyCode   * 회사코드
     */
    public java.lang.String getCompanyCode() {
        return companyCode;
    }


    /**
     * Sets the companyCode value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param companyCode   * 회사코드
     */
    public void setCompanyCode(java.lang.String companyCode) {
        this.companyCode = companyCode;
    }


    /**
     * Gets the grNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grNo   * 입고예정번호
     */
    public java.lang.String getGrNo() {
        return grNo;
    }


    /**
     * Sets the grNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grNo   * 입고예정번호
     */
    public void setGrNo(java.lang.String grNo) {
        this.grNo = grNo;
    }


    /**
     * Gets the grSeq value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grSeq   * 입고예정순번
     */
    public java.lang.String getGrSeq() {
        return grSeq;
    }


    /**
     * Sets the grSeq value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grSeq   * 입고예정순번
     */
    public void setGrSeq(java.lang.String grSeq) {
        this.grSeq = grSeq;
    }


    /**
     * Gets the status value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return status   * 상태
     */
    public java.lang.String getStatus() {
        return status;
    }


    /**
     * Sets the status value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param status   * 상태
     */
    public void setStatus(java.lang.String status) {
        this.status = status;
    }


    /**
     * Gets the itemNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return itemNo   * KEP품번
     */
    public java.lang.String getItemNo() {
        return itemNo;
    }


    /**
     * Sets the itemNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param itemNo   * KEP품번
     */
    public void setItemNo(java.lang.String itemNo) {
        this.itemNo = itemNo;
    }


    /**
     * Gets the desc value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return desc   * 설명
     */
    public java.lang.String getDesc() {
        return desc;
    }


    /**
     * Sets the desc value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param desc   * 설명
     */
    public void setDesc(java.lang.String desc) {
        this.desc = desc;
    }


    /**
     * Gets the spec value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return spec   * 스펙
     */
    public java.lang.String getSpec() {
        return spec;
    }


    /**
     * Sets the spec value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param spec   * 스펙
     */
    public void setSpec(java.lang.String spec) {
        this.spec = spec;
    }


    /**
     * Gets the poNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return poNo   * PO번호
     */
    public java.lang.String getPoNo() {
        return poNo;
    }


    /**
     * Sets the poNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param poNo   * PO번호
     */
    public void setPoNo(java.lang.String poNo) {
        this.poNo = poNo;
    }


    /**
     * Gets the poSeq value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return poSeq   * PO순번
     */
    public java.lang.String getPoSeq() {
        return poSeq;
    }


    /**
     * Sets the poSeq value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param poSeq   * PO순번
     */
    public void setPoSeq(java.lang.String poSeq) {
        this.poSeq = poSeq;
    }


    /**
     * Gets the account value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return account   * 계정
     */
    public java.lang.String getAccount() {
        return account;
    }


    /**
     * Sets the account value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param account   * 계정
     */
    public void setAccount(java.lang.String account) {
        this.account = account;
    }


    /**
     * Gets the qty value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return qty   * 수량
     */
    public java.lang.String getQty() {
        return qty;
    }


    /**
     * Sets the qty value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param qty   * 수량
     */
    public void setQty(java.lang.String qty) {
        this.qty = qty;
    }


    /**
     * Gets the unit value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return unit   * 단위
     */
    public java.lang.String getUnit() {
        return unit;
    }


    /**
     * Sets the unit value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param unit   * 단위
     */
    public void setUnit(java.lang.String unit) {
        this.unit = unit;
    }


    /**
     * Gets the unitPrice value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return unitPrice   * 단위금액
     */
    public java.lang.String getUnitPrice() {
        return unitPrice;
    }


    /**
     * Sets the unitPrice value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param unitPrice   * 단위금액
     */
    public void setUnitPrice(java.lang.String unitPrice) {
        this.unitPrice = unitPrice;
    }


    /**
     * Gets the grPrice value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grPrice   * 입고예정금액
     */
    public java.lang.String getGrPrice() {
        return grPrice;
    }


    /**
     * Sets the grPrice value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grPrice   * 입고예정금액
     */
    public void setGrPrice(java.lang.String grPrice) {
        this.grPrice = grPrice;
    }


    /**
     * Gets the currency value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return currency   * 통화
     */
    public java.lang.String getCurrency() {
        return currency;
    }


    /**
     * Sets the currency value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param currency   * 통화
     */
    public void setCurrency(java.lang.String currency) {
        this.currency = currency;
    }


    /**
     * Gets the docYear value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return docYear   * 자재문서년도
     */
    public java.lang.String getDocYear() {
        return docYear;
    }


    /**
     * Sets the docYear value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param docYear   * 자재문서년도
     */
    public void setDocYear(java.lang.String docYear) {
        this.docYear = docYear;
    }


    /**
     * Gets the grDate value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grDate   * 입고예정일자
     */
    public java.lang.String getGrDate() {
        return grDate;
    }


    /**
     * Sets the grDate value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grDate   * 입고예정일자
     */
    public void setGrDate(java.lang.String grDate) {
        this.grDate = grDate;
    }


    /**
     * Gets the workArea value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return workArea   * 입고장소
     */
    public java.lang.String getWorkArea() {
        return workArea;
    }


    /**
     * Sets the workArea value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param workArea   * 입고장소
     */
    public void setWorkArea(java.lang.String workArea) {
        this.workArea = workArea;
    }


    /**
     * Gets the divCode value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return divCode   * 디비전코드
     */
    public java.lang.String getDivCode() {
        return divCode;
    }


    /**
     * Sets the divCode value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param divCode   * 디비전코드
     */
    public void setDivCode(java.lang.String divCode) {
        this.divCode = divCode;
    }


    /**
     * Gets the grDept value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grDept   * 입고예정부서코드
     */
    public java.lang.String getGrDept() {
        return grDept;
    }


    /**
     * Sets the grDept value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grDept   * 입고예정부서코드
     */
    public void setGrDept(java.lang.String grDept) {
        this.grDept = grDept;
    }


    /**
     * Gets the originGrNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return originGrNo   * 원입고예정번호
     */
    public java.lang.String getOriginGrNo() {
        return originGrNo;
    }


    /**
     * Sets the originGrNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param originGrNo   * 원입고예정번호
     */
    public void setOriginGrNo(java.lang.String originGrNo) {
        this.originGrNo = originGrNo;
    }


    /**
     * Gets the grTime value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grTime   * 입고예정시각
     */
    public java.lang.String getGrTime() {
        return grTime;
    }


    /**
     * Sets the grTime value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grTime   * 입고예정시각
     */
    public void setGrTime(java.lang.String grTime) {
        this.grTime = grTime;
    }


    /**
     * Gets the grEmpNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grEmpNo   * 입고담당자사번
     */
    public java.lang.String getGrEmpNo() {
        return grEmpNo;
    }


    /**
     * Sets the grEmpNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grEmpNo   * 입고담당자사번
     */
    public void setGrEmpNo(java.lang.String grEmpNo) {
        this.grEmpNo = grEmpNo;
    }


    /**
     * Gets the grEmpNm value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grEmpNm   * 입고담당자명
     */
    public java.lang.String getGrEmpNm() {
        return grEmpNm;
    }


    /**
     * Sets the grEmpNm value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grEmpNm   * 입고담당자명
     */
    public void setGrEmpNm(java.lang.String grEmpNm) {
        this.grEmpNm = grEmpNm;
    }


    /**
     * Gets the grDeptDesc value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return grDeptDesc   * 입고부서설명
     */
    public java.lang.String getGrDeptDesc() {
        return grDeptDesc;
    }


    /**
     * Sets the grDeptDesc value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param grDeptDesc   * 입고부서설명
     */
    public void setGrDeptDesc(java.lang.String grDeptDesc) {
        this.grDeptDesc = grDeptDesc;
    }


    /**
     * Gets the mtrlNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return mtrlNo   * 자재코드
     */
    public java.lang.String getMtrlNo() {
        return mtrlNo;
    }


    /**
     * Sets the mtrlNo value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param mtrlNo   * 자재코드
     */
    public void setMtrlNo(java.lang.String mtrlNo) {
        this.mtrlNo = mtrlNo;
    }


    /**
     * Gets the plnt value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return plnt   * 사업장(3사업장 : D131 / 2사업장 : D121)
     */
    public java.lang.String getPlnt() {
        return plnt;
    }


    /**
     * Sets the plnt value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param plnt   * 사업장(3사업장 : D131 / 2사업장 : D121)
     */
    public void setPlnt(java.lang.String plnt) {
        this.plnt = plnt;
    }


    /**
     * Gets the itmGb value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @return itmGb   * 자재구분
     */
    public java.lang.String getItmGb() {
        return itmGb;
    }


    /**
     * Sets the itmGb value for this NE9090_KEPEH_SRMDH_ST_GR_INFO.
     * 
     * @param itmGb   * 자재구분
     */
    public void setItmGb(java.lang.String itmGb) {
        this.itmGb = itmGb;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_ST_GR_INFO)) return false;
        NE9090_KEPEH_SRMDH_ST_GR_INFO other = (NE9090_KEPEH_SRMDH_ST_GR_INFO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.companyCode==null && other.getCompanyCode()==null) || 
             (this.companyCode!=null &&
              this.companyCode.equals(other.getCompanyCode()))) &&
            ((this.grNo==null && other.getGrNo()==null) || 
             (this.grNo!=null &&
              this.grNo.equals(other.getGrNo()))) &&
            ((this.grSeq==null && other.getGrSeq()==null) || 
             (this.grSeq!=null &&
              this.grSeq.equals(other.getGrSeq()))) &&
            ((this.status==null && other.getStatus()==null) || 
             (this.status!=null &&
              this.status.equals(other.getStatus()))) &&
            ((this.itemNo==null && other.getItemNo()==null) || 
             (this.itemNo!=null &&
              this.itemNo.equals(other.getItemNo()))) &&
            ((this.desc==null && other.getDesc()==null) || 
             (this.desc!=null &&
              this.desc.equals(other.getDesc()))) &&
            ((this.spec==null && other.getSpec()==null) || 
             (this.spec!=null &&
              this.spec.equals(other.getSpec()))) &&
            ((this.poNo==null && other.getPoNo()==null) || 
             (this.poNo!=null &&
              this.poNo.equals(other.getPoNo()))) &&
            ((this.poSeq==null && other.getPoSeq()==null) || 
             (this.poSeq!=null &&
              this.poSeq.equals(other.getPoSeq()))) &&
            ((this.account==null && other.getAccount()==null) || 
             (this.account!=null &&
              this.account.equals(other.getAccount()))) &&
            ((this.qty==null && other.getQty()==null) || 
             (this.qty!=null &&
              this.qty.equals(other.getQty()))) &&
            ((this.unit==null && other.getUnit()==null) || 
             (this.unit!=null &&
              this.unit.equals(other.getUnit()))) &&
            ((this.unitPrice==null && other.getUnitPrice()==null) || 
             (this.unitPrice!=null &&
              this.unitPrice.equals(other.getUnitPrice()))) &&
            ((this.grPrice==null && other.getGrPrice()==null) || 
             (this.grPrice!=null &&
              this.grPrice.equals(other.getGrPrice()))) &&
            ((this.currency==null && other.getCurrency()==null) || 
             (this.currency!=null &&
              this.currency.equals(other.getCurrency()))) &&
            ((this.docYear==null && other.getDocYear()==null) || 
             (this.docYear!=null &&
              this.docYear.equals(other.getDocYear()))) &&
            ((this.grDate==null && other.getGrDate()==null) || 
             (this.grDate!=null &&
              this.grDate.equals(other.getGrDate()))) &&
            ((this.workArea==null && other.getWorkArea()==null) || 
             (this.workArea!=null &&
              this.workArea.equals(other.getWorkArea()))) &&
            ((this.divCode==null && other.getDivCode()==null) || 
             (this.divCode!=null &&
              this.divCode.equals(other.getDivCode()))) &&
            ((this.grDept==null && other.getGrDept()==null) || 
             (this.grDept!=null &&
              this.grDept.equals(other.getGrDept()))) &&
            ((this.originGrNo==null && other.getOriginGrNo()==null) || 
             (this.originGrNo!=null &&
              this.originGrNo.equals(other.getOriginGrNo()))) &&
            ((this.grTime==null && other.getGrTime()==null) || 
             (this.grTime!=null &&
              this.grTime.equals(other.getGrTime()))) &&
            ((this.grEmpNo==null && other.getGrEmpNo()==null) || 
             (this.grEmpNo!=null &&
              this.grEmpNo.equals(other.getGrEmpNo()))) &&
            ((this.grEmpNm==null && other.getGrEmpNm()==null) || 
             (this.grEmpNm!=null &&
              this.grEmpNm.equals(other.getGrEmpNm()))) &&
            ((this.grDeptDesc==null && other.getGrDeptDesc()==null) || 
             (this.grDeptDesc!=null &&
              this.grDeptDesc.equals(other.getGrDeptDesc()))) &&
            ((this.mtrlNo==null && other.getMtrlNo()==null) || 
             (this.mtrlNo!=null &&
              this.mtrlNo.equals(other.getMtrlNo()))) &&
            ((this.plnt==null && other.getPlnt()==null) || 
             (this.plnt!=null &&
              this.plnt.equals(other.getPlnt()))) &&
            ((this.itmGb==null && other.getItmGb()==null) || 
             (this.itmGb!=null &&
              this.itmGb.equals(other.getItmGb())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getCompanyCode() != null) {
            _hashCode += getCompanyCode().hashCode();
        }
        if (getGrNo() != null) {
            _hashCode += getGrNo().hashCode();
        }
        if (getGrSeq() != null) {
            _hashCode += getGrSeq().hashCode();
        }
        if (getStatus() != null) {
            _hashCode += getStatus().hashCode();
        }
        if (getItemNo() != null) {
            _hashCode += getItemNo().hashCode();
        }
        if (getDesc() != null) {
            _hashCode += getDesc().hashCode();
        }
        if (getSpec() != null) {
            _hashCode += getSpec().hashCode();
        }
        if (getPoNo() != null) {
            _hashCode += getPoNo().hashCode();
        }
        if (getPoSeq() != null) {
            _hashCode += getPoSeq().hashCode();
        }
        if (getAccount() != null) {
            _hashCode += getAccount().hashCode();
        }
        if (getQty() != null) {
            _hashCode += getQty().hashCode();
        }
        if (getUnit() != null) {
            _hashCode += getUnit().hashCode();
        }
        if (getUnitPrice() != null) {
            _hashCode += getUnitPrice().hashCode();
        }
        if (getGrPrice() != null) {
            _hashCode += getGrPrice().hashCode();
        }
        if (getCurrency() != null) {
            _hashCode += getCurrency().hashCode();
        }
        if (getDocYear() != null) {
            _hashCode += getDocYear().hashCode();
        }
        if (getGrDate() != null) {
            _hashCode += getGrDate().hashCode();
        }
        if (getWorkArea() != null) {
            _hashCode += getWorkArea().hashCode();
        }
        if (getDivCode() != null) {
            _hashCode += getDivCode().hashCode();
        }
        if (getGrDept() != null) {
            _hashCode += getGrDept().hashCode();
        }
        if (getOriginGrNo() != null) {
            _hashCode += getOriginGrNo().hashCode();
        }
        if (getGrTime() != null) {
            _hashCode += getGrTime().hashCode();
        }
        if (getGrEmpNo() != null) {
            _hashCode += getGrEmpNo().hashCode();
        }
        if (getGrEmpNm() != null) {
            _hashCode += getGrEmpNm().hashCode();
        }
        if (getGrDeptDesc() != null) {
            _hashCode += getGrDeptDesc().hashCode();
        }
        if (getMtrlNo() != null) {
            _hashCode += getMtrlNo().hashCode();
        }
        if (getPlnt() != null) {
            _hashCode += getPlnt().hashCode();
        }
        if (getItmGb() != null) {
            _hashCode += getItmGb().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_ST_GR_INFO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S>T_GR_INFO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("companyCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "companyCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grSeq");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grSeq"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("status");
        elemField.setXmlName(new javax.xml.namespace.QName("", "status"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("itemNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "itemNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("desc");
        elemField.setXmlName(new javax.xml.namespace.QName("", "desc"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("spec");
        elemField.setXmlName(new javax.xml.namespace.QName("", "spec"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("poNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "poNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("poSeq");
        elemField.setXmlName(new javax.xml.namespace.QName("", "poSeq"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("account");
        elemField.setXmlName(new javax.xml.namespace.QName("", "account"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("qty");
        elemField.setXmlName(new javax.xml.namespace.QName("", "qty"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("unit");
        elemField.setXmlName(new javax.xml.namespace.QName("", "unit"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("unitPrice");
        elemField.setXmlName(new javax.xml.namespace.QName("", "unitPrice"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grPrice");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grPrice"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("currency");
        elemField.setXmlName(new javax.xml.namespace.QName("", "currency"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("docYear");
        elemField.setXmlName(new javax.xml.namespace.QName("", "docYear"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grDate");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("workArea");
        elemField.setXmlName(new javax.xml.namespace.QName("", "workArea"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("divCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "divCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grDept");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grDept"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("originGrNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "originGrNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grTime");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grEmpNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grEmpNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grEmpNm");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grEmpNm"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grDeptDesc");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grDeptDesc"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mtrlNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "mtrlNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("plnt");
        elemField.setXmlName(new javax.xml.namespace.QName("", "plnt"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("itmGb");
        elemField.setXmlName(new javax.xml.namespace.QName("", "itmGb"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
