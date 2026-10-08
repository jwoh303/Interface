/**
 * OrgDeptUserVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.vo;

public class OrgDeptUserVO  implements java.io.Serializable {
    private java.lang.String activeYn;

    private java.lang.String cellKind;

    private java.lang.String cellPhoneNo;

    private java.lang.String chargeWork;

    private java.lang.String companyId;

    private java.lang.String companyName;

    private java.lang.String companyNameEn;

    private java.lang.String defaultDeptYn;

    private java.lang.String deptCode;

    private java.lang.String deptFullPath;

    private java.lang.String deptId;

    private java.lang.String deptName;

    private java.lang.String deptNameEn;

    private java.lang.String email;

    private java.lang.String employeeNo;

    private java.lang.String englishName;

    private java.lang.String faxNo;

    private java.lang.String femaleYn;

    private java.lang.String groupwareYn;

    private java.lang.String hrYn;

    private java.lang.String ipPhoneNo;

    private java.lang.String jobClassId;

    private java.lang.String jobClassName;

    private java.lang.String jobClassNameEn;

    private int jobClassOrder;

    private java.lang.String jobDutyId;

    private java.lang.String jobDutyName;

    private java.lang.String jobFunctionId;

    private java.lang.String jobFunctionName;

    private int jobFunctionOrder;

    private java.lang.String jobPositionId;

    private java.lang.String jobPositionName;

    private java.lang.String jobPositionNameEn;

    private int jobPositionOrder;

    private java.lang.String joinDate;

    private java.lang.String language;

    private java.lang.String lastLoginDate;

    private java.lang.String msnYn;

    private java.lang.String officePhoneNo;

    private java.lang.String outsideYn;

    private java.lang.String passwordExpireDate;

    private java.lang.String photoPath;

    private int securityLevel;

    private java.lang.String userExpireDate;

    private java.lang.String userId;

    private java.lang.String userKey;

    private java.lang.String userName;

    private java.lang.String userNameEn;

    private java.lang.String visibleYn;

    private java.lang.String webYn;

    private java.lang.String workPlace;

    public OrgDeptUserVO() {
    }

    public OrgDeptUserVO(
           java.lang.String activeYn,
           java.lang.String cellKind,
           java.lang.String cellPhoneNo,
           java.lang.String chargeWork,
           java.lang.String companyId,
           java.lang.String companyName,
           java.lang.String companyNameEn,
           java.lang.String defaultDeptYn,
           java.lang.String deptCode,
           java.lang.String deptFullPath,
           java.lang.String deptId,
           java.lang.String deptName,
           java.lang.String deptNameEn,
           java.lang.String email,
           java.lang.String employeeNo,
           java.lang.String englishName,
           java.lang.String faxNo,
           java.lang.String femaleYn,
           java.lang.String groupwareYn,
           java.lang.String hrYn,
           java.lang.String ipPhoneNo,
           java.lang.String jobClassId,
           java.lang.String jobClassName,
           java.lang.String jobClassNameEn,
           int jobClassOrder,
           java.lang.String jobDutyId,
           java.lang.String jobDutyName,
           java.lang.String jobFunctionId,
           java.lang.String jobFunctionName,
           int jobFunctionOrder,
           java.lang.String jobPositionId,
           java.lang.String jobPositionName,
           java.lang.String jobPositionNameEn,
           int jobPositionOrder,
           java.lang.String joinDate,
           java.lang.String language,
           java.lang.String lastLoginDate,
           java.lang.String msnYn,
           java.lang.String officePhoneNo,
           java.lang.String outsideYn,
           java.lang.String passwordExpireDate,
           java.lang.String photoPath,
           int securityLevel,
           java.lang.String userExpireDate,
           java.lang.String userId,
           java.lang.String userKey,
           java.lang.String userName,
           java.lang.String userNameEn,
           java.lang.String visibleYn,
           java.lang.String webYn,
           java.lang.String workPlace) {
           this.activeYn = activeYn;
           this.cellKind = cellKind;
           this.cellPhoneNo = cellPhoneNo;
           this.chargeWork = chargeWork;
           this.companyId = companyId;
           this.companyName = companyName;
           this.companyNameEn = companyNameEn;
           this.defaultDeptYn = defaultDeptYn;
           this.deptCode = deptCode;
           this.deptFullPath = deptFullPath;
           this.deptId = deptId;
           this.deptName = deptName;
           this.deptNameEn = deptNameEn;
           this.email = email;
           this.employeeNo = employeeNo;
           this.englishName = englishName;
           this.faxNo = faxNo;
           this.femaleYn = femaleYn;
           this.groupwareYn = groupwareYn;
           this.hrYn = hrYn;
           this.ipPhoneNo = ipPhoneNo;
           this.jobClassId = jobClassId;
           this.jobClassName = jobClassName;
           this.jobClassNameEn = jobClassNameEn;
           this.jobClassOrder = jobClassOrder;
           this.jobDutyId = jobDutyId;
           this.jobDutyName = jobDutyName;
           this.jobFunctionId = jobFunctionId;
           this.jobFunctionName = jobFunctionName;
           this.jobFunctionOrder = jobFunctionOrder;
           this.jobPositionId = jobPositionId;
           this.jobPositionName = jobPositionName;
           this.jobPositionNameEn = jobPositionNameEn;
           this.jobPositionOrder = jobPositionOrder;
           this.joinDate = joinDate;
           this.language = language;
           this.lastLoginDate = lastLoginDate;
           this.msnYn = msnYn;
           this.officePhoneNo = officePhoneNo;
           this.outsideYn = outsideYn;
           this.passwordExpireDate = passwordExpireDate;
           this.photoPath = photoPath;
           this.securityLevel = securityLevel;
           this.userExpireDate = userExpireDate;
           this.userId = userId;
           this.userKey = userKey;
           this.userName = userName;
           this.userNameEn = userNameEn;
           this.visibleYn = visibleYn;
           this.webYn = webYn;
           this.workPlace = workPlace;
    }


    /**
     * Gets the activeYn value for this OrgDeptUserVO.
     * 
     * @return activeYn
     */
    public java.lang.String getActiveYn() {
        return activeYn;
    }


    /**
     * Sets the activeYn value for this OrgDeptUserVO.
     * 
     * @param activeYn
     */
    public void setActiveYn(java.lang.String activeYn) {
        this.activeYn = activeYn;
    }


    /**
     * Gets the cellKind value for this OrgDeptUserVO.
     * 
     * @return cellKind
     */
    public java.lang.String getCellKind() {
        return cellKind;
    }


    /**
     * Sets the cellKind value for this OrgDeptUserVO.
     * 
     * @param cellKind
     */
    public void setCellKind(java.lang.String cellKind) {
        this.cellKind = cellKind;
    }


    /**
     * Gets the cellPhoneNo value for this OrgDeptUserVO.
     * 
     * @return cellPhoneNo
     */
    public java.lang.String getCellPhoneNo() {
        return cellPhoneNo;
    }


    /**
     * Sets the cellPhoneNo value for this OrgDeptUserVO.
     * 
     * @param cellPhoneNo
     */
    public void setCellPhoneNo(java.lang.String cellPhoneNo) {
        this.cellPhoneNo = cellPhoneNo;
    }


    /**
     * Gets the chargeWork value for this OrgDeptUserVO.
     * 
     * @return chargeWork
     */
    public java.lang.String getChargeWork() {
        return chargeWork;
    }


    /**
     * Sets the chargeWork value for this OrgDeptUserVO.
     * 
     * @param chargeWork
     */
    public void setChargeWork(java.lang.String chargeWork) {
        this.chargeWork = chargeWork;
    }


    /**
     * Gets the companyId value for this OrgDeptUserVO.
     * 
     * @return companyId
     */
    public java.lang.String getCompanyId() {
        return companyId;
    }


    /**
     * Sets the companyId value for this OrgDeptUserVO.
     * 
     * @param companyId
     */
    public void setCompanyId(java.lang.String companyId) {
        this.companyId = companyId;
    }


    /**
     * Gets the companyName value for this OrgDeptUserVO.
     * 
     * @return companyName
     */
    public java.lang.String getCompanyName() {
        return companyName;
    }


    /**
     * Sets the companyName value for this OrgDeptUserVO.
     * 
     * @param companyName
     */
    public void setCompanyName(java.lang.String companyName) {
        this.companyName = companyName;
    }


    /**
     * Gets the companyNameEn value for this OrgDeptUserVO.
     * 
     * @return companyNameEn
     */
    public java.lang.String getCompanyNameEn() {
        return companyNameEn;
    }


    /**
     * Sets the companyNameEn value for this OrgDeptUserVO.
     * 
     * @param companyNameEn
     */
    public void setCompanyNameEn(java.lang.String companyNameEn) {
        this.companyNameEn = companyNameEn;
    }


    /**
     * Gets the defaultDeptYn value for this OrgDeptUserVO.
     * 
     * @return defaultDeptYn
     */
    public java.lang.String getDefaultDeptYn() {
        return defaultDeptYn;
    }


    /**
     * Sets the defaultDeptYn value for this OrgDeptUserVO.
     * 
     * @param defaultDeptYn
     */
    public void setDefaultDeptYn(java.lang.String defaultDeptYn) {
        this.defaultDeptYn = defaultDeptYn;
    }


    /**
     * Gets the deptCode value for this OrgDeptUserVO.
     * 
     * @return deptCode
     */
    public java.lang.String getDeptCode() {
        return deptCode;
    }


    /**
     * Sets the deptCode value for this OrgDeptUserVO.
     * 
     * @param deptCode
     */
    public void setDeptCode(java.lang.String deptCode) {
        this.deptCode = deptCode;
    }


    /**
     * Gets the deptFullPath value for this OrgDeptUserVO.
     * 
     * @return deptFullPath
     */
    public java.lang.String getDeptFullPath() {
        return deptFullPath;
    }


    /**
     * Sets the deptFullPath value for this OrgDeptUserVO.
     * 
     * @param deptFullPath
     */
    public void setDeptFullPath(java.lang.String deptFullPath) {
        this.deptFullPath = deptFullPath;
    }


    /**
     * Gets the deptId value for this OrgDeptUserVO.
     * 
     * @return deptId
     */
    public java.lang.String getDeptId() {
        return deptId;
    }


    /**
     * Sets the deptId value for this OrgDeptUserVO.
     * 
     * @param deptId
     */
    public void setDeptId(java.lang.String deptId) {
        this.deptId = deptId;
    }


    /**
     * Gets the deptName value for this OrgDeptUserVO.
     * 
     * @return deptName
     */
    public java.lang.String getDeptName() {
        return deptName;
    }


    /**
     * Sets the deptName value for this OrgDeptUserVO.
     * 
     * @param deptName
     */
    public void setDeptName(java.lang.String deptName) {
        this.deptName = deptName;
    }


    /**
     * Gets the deptNameEn value for this OrgDeptUserVO.
     * 
     * @return deptNameEn
     */
    public java.lang.String getDeptNameEn() {
        return deptNameEn;
    }


    /**
     * Sets the deptNameEn value for this OrgDeptUserVO.
     * 
     * @param deptNameEn
     */
    public void setDeptNameEn(java.lang.String deptNameEn) {
        this.deptNameEn = deptNameEn;
    }


    /**
     * Gets the email value for this OrgDeptUserVO.
     * 
     * @return email
     */
    public java.lang.String getEmail() {
        return email;
    }


    /**
     * Sets the email value for this OrgDeptUserVO.
     * 
     * @param email
     */
    public void setEmail(java.lang.String email) {
        this.email = email;
    }


    /**
     * Gets the employeeNo value for this OrgDeptUserVO.
     * 
     * @return employeeNo
     */
    public java.lang.String getEmployeeNo() {
        return employeeNo;
    }


    /**
     * Sets the employeeNo value for this OrgDeptUserVO.
     * 
     * @param employeeNo
     */
    public void setEmployeeNo(java.lang.String employeeNo) {
        this.employeeNo = employeeNo;
    }


    /**
     * Gets the englishName value for this OrgDeptUserVO.
     * 
     * @return englishName
     */
    public java.lang.String getEnglishName() {
        return englishName;
    }


    /**
     * Sets the englishName value for this OrgDeptUserVO.
     * 
     * @param englishName
     */
    public void setEnglishName(java.lang.String englishName) {
        this.englishName = englishName;
    }


    /**
     * Gets the faxNo value for this OrgDeptUserVO.
     * 
     * @return faxNo
     */
    public java.lang.String getFaxNo() {
        return faxNo;
    }


    /**
     * Sets the faxNo value for this OrgDeptUserVO.
     * 
     * @param faxNo
     */
    public void setFaxNo(java.lang.String faxNo) {
        this.faxNo = faxNo;
    }


    /**
     * Gets the femaleYn value for this OrgDeptUserVO.
     * 
     * @return femaleYn
     */
    public java.lang.String getFemaleYn() {
        return femaleYn;
    }


    /**
     * Sets the femaleYn value for this OrgDeptUserVO.
     * 
     * @param femaleYn
     */
    public void setFemaleYn(java.lang.String femaleYn) {
        this.femaleYn = femaleYn;
    }


    /**
     * Gets the groupwareYn value for this OrgDeptUserVO.
     * 
     * @return groupwareYn
     */
    public java.lang.String getGroupwareYn() {
        return groupwareYn;
    }


    /**
     * Sets the groupwareYn value for this OrgDeptUserVO.
     * 
     * @param groupwareYn
     */
    public void setGroupwareYn(java.lang.String groupwareYn) {
        this.groupwareYn = groupwareYn;
    }


    /**
     * Gets the hrYn value for this OrgDeptUserVO.
     * 
     * @return hrYn
     */
    public java.lang.String getHrYn() {
        return hrYn;
    }


    /**
     * Sets the hrYn value for this OrgDeptUserVO.
     * 
     * @param hrYn
     */
    public void setHrYn(java.lang.String hrYn) {
        this.hrYn = hrYn;
    }


    /**
     * Gets the ipPhoneNo value for this OrgDeptUserVO.
     * 
     * @return ipPhoneNo
     */
    public java.lang.String getIpPhoneNo() {
        return ipPhoneNo;
    }


    /**
     * Sets the ipPhoneNo value for this OrgDeptUserVO.
     * 
     * @param ipPhoneNo
     */
    public void setIpPhoneNo(java.lang.String ipPhoneNo) {
        this.ipPhoneNo = ipPhoneNo;
    }


    /**
     * Gets the jobClassId value for this OrgDeptUserVO.
     * 
     * @return jobClassId
     */
    public java.lang.String getJobClassId() {
        return jobClassId;
    }


    /**
     * Sets the jobClassId value for this OrgDeptUserVO.
     * 
     * @param jobClassId
     */
    public void setJobClassId(java.lang.String jobClassId) {
        this.jobClassId = jobClassId;
    }


    /**
     * Gets the jobClassName value for this OrgDeptUserVO.
     * 
     * @return jobClassName
     */
    public java.lang.String getJobClassName() {
        return jobClassName;
    }


    /**
     * Sets the jobClassName value for this OrgDeptUserVO.
     * 
     * @param jobClassName
     */
    public void setJobClassName(java.lang.String jobClassName) {
        this.jobClassName = jobClassName;
    }


    /**
     * Gets the jobClassNameEn value for this OrgDeptUserVO.
     * 
     * @return jobClassNameEn
     */
    public java.lang.String getJobClassNameEn() {
        return jobClassNameEn;
    }


    /**
     * Sets the jobClassNameEn value for this OrgDeptUserVO.
     * 
     * @param jobClassNameEn
     */
    public void setJobClassNameEn(java.lang.String jobClassNameEn) {
        this.jobClassNameEn = jobClassNameEn;
    }


    /**
     * Gets the jobClassOrder value for this OrgDeptUserVO.
     * 
     * @return jobClassOrder
     */
    public int getJobClassOrder() {
        return jobClassOrder;
    }


    /**
     * Sets the jobClassOrder value for this OrgDeptUserVO.
     * 
     * @param jobClassOrder
     */
    public void setJobClassOrder(int jobClassOrder) {
        this.jobClassOrder = jobClassOrder;
    }


    /**
     * Gets the jobDutyId value for this OrgDeptUserVO.
     * 
     * @return jobDutyId
     */
    public java.lang.String getJobDutyId() {
        return jobDutyId;
    }


    /**
     * Sets the jobDutyId value for this OrgDeptUserVO.
     * 
     * @param jobDutyId
     */
    public void setJobDutyId(java.lang.String jobDutyId) {
        this.jobDutyId = jobDutyId;
    }


    /**
     * Gets the jobDutyName value for this OrgDeptUserVO.
     * 
     * @return jobDutyName
     */
    public java.lang.String getJobDutyName() {
        return jobDutyName;
    }


    /**
     * Sets the jobDutyName value for this OrgDeptUserVO.
     * 
     * @param jobDutyName
     */
    public void setJobDutyName(java.lang.String jobDutyName) {
        this.jobDutyName = jobDutyName;
    }


    /**
     * Gets the jobFunctionId value for this OrgDeptUserVO.
     * 
     * @return jobFunctionId
     */
    public java.lang.String getJobFunctionId() {
        return jobFunctionId;
    }


    /**
     * Sets the jobFunctionId value for this OrgDeptUserVO.
     * 
     * @param jobFunctionId
     */
    public void setJobFunctionId(java.lang.String jobFunctionId) {
        this.jobFunctionId = jobFunctionId;
    }


    /**
     * Gets the jobFunctionName value for this OrgDeptUserVO.
     * 
     * @return jobFunctionName
     */
    public java.lang.String getJobFunctionName() {
        return jobFunctionName;
    }


    /**
     * Sets the jobFunctionName value for this OrgDeptUserVO.
     * 
     * @param jobFunctionName
     */
    public void setJobFunctionName(java.lang.String jobFunctionName) {
        this.jobFunctionName = jobFunctionName;
    }


    /**
     * Gets the jobFunctionOrder value for this OrgDeptUserVO.
     * 
     * @return jobFunctionOrder
     */
    public int getJobFunctionOrder() {
        return jobFunctionOrder;
    }


    /**
     * Sets the jobFunctionOrder value for this OrgDeptUserVO.
     * 
     * @param jobFunctionOrder
     */
    public void setJobFunctionOrder(int jobFunctionOrder) {
        this.jobFunctionOrder = jobFunctionOrder;
    }


    /**
     * Gets the jobPositionId value for this OrgDeptUserVO.
     * 
     * @return jobPositionId
     */
    public java.lang.String getJobPositionId() {
        return jobPositionId;
    }


    /**
     * Sets the jobPositionId value for this OrgDeptUserVO.
     * 
     * @param jobPositionId
     */
    public void setJobPositionId(java.lang.String jobPositionId) {
        this.jobPositionId = jobPositionId;
    }


    /**
     * Gets the jobPositionName value for this OrgDeptUserVO.
     * 
     * @return jobPositionName
     */
    public java.lang.String getJobPositionName() {
        return jobPositionName;
    }


    /**
     * Sets the jobPositionName value for this OrgDeptUserVO.
     * 
     * @param jobPositionName
     */
    public void setJobPositionName(java.lang.String jobPositionName) {
        this.jobPositionName = jobPositionName;
    }


    /**
     * Gets the jobPositionNameEn value for this OrgDeptUserVO.
     * 
     * @return jobPositionNameEn
     */
    public java.lang.String getJobPositionNameEn() {
        return jobPositionNameEn;
    }


    /**
     * Sets the jobPositionNameEn value for this OrgDeptUserVO.
     * 
     * @param jobPositionNameEn
     */
    public void setJobPositionNameEn(java.lang.String jobPositionNameEn) {
        this.jobPositionNameEn = jobPositionNameEn;
    }


    /**
     * Gets the jobPositionOrder value for this OrgDeptUserVO.
     * 
     * @return jobPositionOrder
     */
    public int getJobPositionOrder() {
        return jobPositionOrder;
    }


    /**
     * Sets the jobPositionOrder value for this OrgDeptUserVO.
     * 
     * @param jobPositionOrder
     */
    public void setJobPositionOrder(int jobPositionOrder) {
        this.jobPositionOrder = jobPositionOrder;
    }


    /**
     * Gets the joinDate value for this OrgDeptUserVO.
     * 
     * @return joinDate
     */
    public java.lang.String getJoinDate() {
        return joinDate;
    }


    /**
     * Sets the joinDate value for this OrgDeptUserVO.
     * 
     * @param joinDate
     */
    public void setJoinDate(java.lang.String joinDate) {
        this.joinDate = joinDate;
    }


    /**
     * Gets the language value for this OrgDeptUserVO.
     * 
     * @return language
     */
    public java.lang.String getLanguage() {
        return language;
    }


    /**
     * Sets the language value for this OrgDeptUserVO.
     * 
     * @param language
     */
    public void setLanguage(java.lang.String language) {
        this.language = language;
    }


    /**
     * Gets the lastLoginDate value for this OrgDeptUserVO.
     * 
     * @return lastLoginDate
     */
    public java.lang.String getLastLoginDate() {
        return lastLoginDate;
    }


    /**
     * Sets the lastLoginDate value for this OrgDeptUserVO.
     * 
     * @param lastLoginDate
     */
    public void setLastLoginDate(java.lang.String lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }


    /**
     * Gets the msnYn value for this OrgDeptUserVO.
     * 
     * @return msnYn
     */
    public java.lang.String getMsnYn() {
        return msnYn;
    }


    /**
     * Sets the msnYn value for this OrgDeptUserVO.
     * 
     * @param msnYn
     */
    public void setMsnYn(java.lang.String msnYn) {
        this.msnYn = msnYn;
    }


    /**
     * Gets the officePhoneNo value for this OrgDeptUserVO.
     * 
     * @return officePhoneNo
     */
    public java.lang.String getOfficePhoneNo() {
        return officePhoneNo;
    }


    /**
     * Sets the officePhoneNo value for this OrgDeptUserVO.
     * 
     * @param officePhoneNo
     */
    public void setOfficePhoneNo(java.lang.String officePhoneNo) {
        this.officePhoneNo = officePhoneNo;
    }


    /**
     * Gets the outsideYn value for this OrgDeptUserVO.
     * 
     * @return outsideYn
     */
    public java.lang.String getOutsideYn() {
        return outsideYn;
    }


    /**
     * Sets the outsideYn value for this OrgDeptUserVO.
     * 
     * @param outsideYn
     */
    public void setOutsideYn(java.lang.String outsideYn) {
        this.outsideYn = outsideYn;
    }


    /**
     * Gets the passwordExpireDate value for this OrgDeptUserVO.
     * 
     * @return passwordExpireDate
     */
    public java.lang.String getPasswordExpireDate() {
        return passwordExpireDate;
    }


    /**
     * Sets the passwordExpireDate value for this OrgDeptUserVO.
     * 
     * @param passwordExpireDate
     */
    public void setPasswordExpireDate(java.lang.String passwordExpireDate) {
        this.passwordExpireDate = passwordExpireDate;
    }


    /**
     * Gets the photoPath value for this OrgDeptUserVO.
     * 
     * @return photoPath
     */
    public java.lang.String getPhotoPath() {
        return photoPath;
    }


    /**
     * Sets the photoPath value for this OrgDeptUserVO.
     * 
     * @param photoPath
     */
    public void setPhotoPath(java.lang.String photoPath) {
        this.photoPath = photoPath;
    }


    /**
     * Gets the securityLevel value for this OrgDeptUserVO.
     * 
     * @return securityLevel
     */
    public int getSecurityLevel() {
        return securityLevel;
    }


    /**
     * Sets the securityLevel value for this OrgDeptUserVO.
     * 
     * @param securityLevel
     */
    public void setSecurityLevel(int securityLevel) {
        this.securityLevel = securityLevel;
    }


    /**
     * Gets the userExpireDate value for this OrgDeptUserVO.
     * 
     * @return userExpireDate
     */
    public java.lang.String getUserExpireDate() {
        return userExpireDate;
    }


    /**
     * Sets the userExpireDate value for this OrgDeptUserVO.
     * 
     * @param userExpireDate
     */
    public void setUserExpireDate(java.lang.String userExpireDate) {
        this.userExpireDate = userExpireDate;
    }


    /**
     * Gets the userId value for this OrgDeptUserVO.
     * 
     * @return userId
     */
    public java.lang.String getUserId() {
        return userId;
    }


    /**
     * Sets the userId value for this OrgDeptUserVO.
     * 
     * @param userId
     */
    public void setUserId(java.lang.String userId) {
        this.userId = userId;
    }


    /**
     * Gets the userKey value for this OrgDeptUserVO.
     * 
     * @return userKey
     */
    public java.lang.String getUserKey() {
        return userKey;
    }


    /**
     * Sets the userKey value for this OrgDeptUserVO.
     * 
     * @param userKey
     */
    public void setUserKey(java.lang.String userKey) {
        this.userKey = userKey;
    }


    /**
     * Gets the userName value for this OrgDeptUserVO.
     * 
     * @return userName
     */
    public java.lang.String getUserName() {
        return userName;
    }


    /**
     * Sets the userName value for this OrgDeptUserVO.
     * 
     * @param userName
     */
    public void setUserName(java.lang.String userName) {
        this.userName = userName;
    }


    /**
     * Gets the userNameEn value for this OrgDeptUserVO.
     * 
     * @return userNameEn
     */
    public java.lang.String getUserNameEn() {
        return userNameEn;
    }


    /**
     * Sets the userNameEn value for this OrgDeptUserVO.
     * 
     * @param userNameEn
     */
    public void setUserNameEn(java.lang.String userNameEn) {
        this.userNameEn = userNameEn;
    }


    /**
     * Gets the visibleYn value for this OrgDeptUserVO.
     * 
     * @return visibleYn
     */
    public java.lang.String getVisibleYn() {
        return visibleYn;
    }


    /**
     * Sets the visibleYn value for this OrgDeptUserVO.
     * 
     * @param visibleYn
     */
    public void setVisibleYn(java.lang.String visibleYn) {
        this.visibleYn = visibleYn;
    }


    /**
     * Gets the webYn value for this OrgDeptUserVO.
     * 
     * @return webYn
     */
    public java.lang.String getWebYn() {
        return webYn;
    }


    /**
     * Sets the webYn value for this OrgDeptUserVO.
     * 
     * @param webYn
     */
    public void setWebYn(java.lang.String webYn) {
        this.webYn = webYn;
    }


    /**
     * Gets the workPlace value for this OrgDeptUserVO.
     * 
     * @return workPlace
     */
    public java.lang.String getWorkPlace() {
        return workPlace;
    }


    /**
     * Sets the workPlace value for this OrgDeptUserVO.
     * 
     * @param workPlace
     */
    public void setWorkPlace(java.lang.String workPlace) {
        this.workPlace = workPlace;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof OrgDeptUserVO)) return false;
        OrgDeptUserVO other = (OrgDeptUserVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.activeYn==null && other.getActiveYn()==null) || 
             (this.activeYn!=null &&
              this.activeYn.equals(other.getActiveYn()))) &&
            ((this.cellKind==null && other.getCellKind()==null) || 
             (this.cellKind!=null &&
              this.cellKind.equals(other.getCellKind()))) &&
            ((this.cellPhoneNo==null && other.getCellPhoneNo()==null) || 
             (this.cellPhoneNo!=null &&
              this.cellPhoneNo.equals(other.getCellPhoneNo()))) &&
            ((this.chargeWork==null && other.getChargeWork()==null) || 
             (this.chargeWork!=null &&
              this.chargeWork.equals(other.getChargeWork()))) &&
            ((this.companyId==null && other.getCompanyId()==null) || 
             (this.companyId!=null &&
              this.companyId.equals(other.getCompanyId()))) &&
            ((this.companyName==null && other.getCompanyName()==null) || 
             (this.companyName!=null &&
              this.companyName.equals(other.getCompanyName()))) &&
            ((this.companyNameEn==null && other.getCompanyNameEn()==null) || 
             (this.companyNameEn!=null &&
              this.companyNameEn.equals(other.getCompanyNameEn()))) &&
            ((this.defaultDeptYn==null && other.getDefaultDeptYn()==null) || 
             (this.defaultDeptYn!=null &&
              this.defaultDeptYn.equals(other.getDefaultDeptYn()))) &&
            ((this.deptCode==null && other.getDeptCode()==null) || 
             (this.deptCode!=null &&
              this.deptCode.equals(other.getDeptCode()))) &&
            ((this.deptFullPath==null && other.getDeptFullPath()==null) || 
             (this.deptFullPath!=null &&
              this.deptFullPath.equals(other.getDeptFullPath()))) &&
            ((this.deptId==null && other.getDeptId()==null) || 
             (this.deptId!=null &&
              this.deptId.equals(other.getDeptId()))) &&
            ((this.deptName==null && other.getDeptName()==null) || 
             (this.deptName!=null &&
              this.deptName.equals(other.getDeptName()))) &&
            ((this.deptNameEn==null && other.getDeptNameEn()==null) || 
             (this.deptNameEn!=null &&
              this.deptNameEn.equals(other.getDeptNameEn()))) &&
            ((this.email==null && other.getEmail()==null) || 
             (this.email!=null &&
              this.email.equals(other.getEmail()))) &&
            ((this.employeeNo==null && other.getEmployeeNo()==null) || 
             (this.employeeNo!=null &&
              this.employeeNo.equals(other.getEmployeeNo()))) &&
            ((this.englishName==null && other.getEnglishName()==null) || 
             (this.englishName!=null &&
              this.englishName.equals(other.getEnglishName()))) &&
            ((this.faxNo==null && other.getFaxNo()==null) || 
             (this.faxNo!=null &&
              this.faxNo.equals(other.getFaxNo()))) &&
            ((this.femaleYn==null && other.getFemaleYn()==null) || 
             (this.femaleYn!=null &&
              this.femaleYn.equals(other.getFemaleYn()))) &&
            ((this.groupwareYn==null && other.getGroupwareYn()==null) || 
             (this.groupwareYn!=null &&
              this.groupwareYn.equals(other.getGroupwareYn()))) &&
            ((this.hrYn==null && other.getHrYn()==null) || 
             (this.hrYn!=null &&
              this.hrYn.equals(other.getHrYn()))) &&
            ((this.ipPhoneNo==null && other.getIpPhoneNo()==null) || 
             (this.ipPhoneNo!=null &&
              this.ipPhoneNo.equals(other.getIpPhoneNo()))) &&
            ((this.jobClassId==null && other.getJobClassId()==null) || 
             (this.jobClassId!=null &&
              this.jobClassId.equals(other.getJobClassId()))) &&
            ((this.jobClassName==null && other.getJobClassName()==null) || 
             (this.jobClassName!=null &&
              this.jobClassName.equals(other.getJobClassName()))) &&
            ((this.jobClassNameEn==null && other.getJobClassNameEn()==null) || 
             (this.jobClassNameEn!=null &&
              this.jobClassNameEn.equals(other.getJobClassNameEn()))) &&
            this.jobClassOrder == other.getJobClassOrder() &&
            ((this.jobDutyId==null && other.getJobDutyId()==null) || 
             (this.jobDutyId!=null &&
              this.jobDutyId.equals(other.getJobDutyId()))) &&
            ((this.jobDutyName==null && other.getJobDutyName()==null) || 
             (this.jobDutyName!=null &&
              this.jobDutyName.equals(other.getJobDutyName()))) &&
            ((this.jobFunctionId==null && other.getJobFunctionId()==null) || 
             (this.jobFunctionId!=null &&
              this.jobFunctionId.equals(other.getJobFunctionId()))) &&
            ((this.jobFunctionName==null && other.getJobFunctionName()==null) || 
             (this.jobFunctionName!=null &&
              this.jobFunctionName.equals(other.getJobFunctionName()))) &&
            this.jobFunctionOrder == other.getJobFunctionOrder() &&
            ((this.jobPositionId==null && other.getJobPositionId()==null) || 
             (this.jobPositionId!=null &&
              this.jobPositionId.equals(other.getJobPositionId()))) &&
            ((this.jobPositionName==null && other.getJobPositionName()==null) || 
             (this.jobPositionName!=null &&
              this.jobPositionName.equals(other.getJobPositionName()))) &&
            ((this.jobPositionNameEn==null && other.getJobPositionNameEn()==null) || 
             (this.jobPositionNameEn!=null &&
              this.jobPositionNameEn.equals(other.getJobPositionNameEn()))) &&
            this.jobPositionOrder == other.getJobPositionOrder() &&
            ((this.joinDate==null && other.getJoinDate()==null) || 
             (this.joinDate!=null &&
              this.joinDate.equals(other.getJoinDate()))) &&
            ((this.language==null && other.getLanguage()==null) || 
             (this.language!=null &&
              this.language.equals(other.getLanguage()))) &&
            ((this.lastLoginDate==null && other.getLastLoginDate()==null) || 
             (this.lastLoginDate!=null &&
              this.lastLoginDate.equals(other.getLastLoginDate()))) &&
            ((this.msnYn==null && other.getMsnYn()==null) || 
             (this.msnYn!=null &&
              this.msnYn.equals(other.getMsnYn()))) &&
            ((this.officePhoneNo==null && other.getOfficePhoneNo()==null) || 
             (this.officePhoneNo!=null &&
              this.officePhoneNo.equals(other.getOfficePhoneNo()))) &&
            ((this.outsideYn==null && other.getOutsideYn()==null) || 
             (this.outsideYn!=null &&
              this.outsideYn.equals(other.getOutsideYn()))) &&
            ((this.passwordExpireDate==null && other.getPasswordExpireDate()==null) || 
             (this.passwordExpireDate!=null &&
              this.passwordExpireDate.equals(other.getPasswordExpireDate()))) &&
            ((this.photoPath==null && other.getPhotoPath()==null) || 
             (this.photoPath!=null &&
              this.photoPath.equals(other.getPhotoPath()))) &&
            this.securityLevel == other.getSecurityLevel() &&
            ((this.userExpireDate==null && other.getUserExpireDate()==null) || 
             (this.userExpireDate!=null &&
              this.userExpireDate.equals(other.getUserExpireDate()))) &&
            ((this.userId==null && other.getUserId()==null) || 
             (this.userId!=null &&
              this.userId.equals(other.getUserId()))) &&
            ((this.userKey==null && other.getUserKey()==null) || 
             (this.userKey!=null &&
              this.userKey.equals(other.getUserKey()))) &&
            ((this.userName==null && other.getUserName()==null) || 
             (this.userName!=null &&
              this.userName.equals(other.getUserName()))) &&
            ((this.userNameEn==null && other.getUserNameEn()==null) || 
             (this.userNameEn!=null &&
              this.userNameEn.equals(other.getUserNameEn()))) &&
            ((this.visibleYn==null && other.getVisibleYn()==null) || 
             (this.visibleYn!=null &&
              this.visibleYn.equals(other.getVisibleYn()))) &&
            ((this.webYn==null && other.getWebYn()==null) || 
             (this.webYn!=null &&
              this.webYn.equals(other.getWebYn()))) &&
            ((this.workPlace==null && other.getWorkPlace()==null) || 
             (this.workPlace!=null &&
              this.workPlace.equals(other.getWorkPlace())));
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
        if (getActiveYn() != null) {
            _hashCode += getActiveYn().hashCode();
        }
        if (getCellKind() != null) {
            _hashCode += getCellKind().hashCode();
        }
        if (getCellPhoneNo() != null) {
            _hashCode += getCellPhoneNo().hashCode();
        }
        if (getChargeWork() != null) {
            _hashCode += getChargeWork().hashCode();
        }
        if (getCompanyId() != null) {
            _hashCode += getCompanyId().hashCode();
        }
        if (getCompanyName() != null) {
            _hashCode += getCompanyName().hashCode();
        }
        if (getCompanyNameEn() != null) {
            _hashCode += getCompanyNameEn().hashCode();
        }
        if (getDefaultDeptYn() != null) {
            _hashCode += getDefaultDeptYn().hashCode();
        }
        if (getDeptCode() != null) {
            _hashCode += getDeptCode().hashCode();
        }
        if (getDeptFullPath() != null) {
            _hashCode += getDeptFullPath().hashCode();
        }
        if (getDeptId() != null) {
            _hashCode += getDeptId().hashCode();
        }
        if (getDeptName() != null) {
            _hashCode += getDeptName().hashCode();
        }
        if (getDeptNameEn() != null) {
            _hashCode += getDeptNameEn().hashCode();
        }
        if (getEmail() != null) {
            _hashCode += getEmail().hashCode();
        }
        if (getEmployeeNo() != null) {
            _hashCode += getEmployeeNo().hashCode();
        }
        if (getEnglishName() != null) {
            _hashCode += getEnglishName().hashCode();
        }
        if (getFaxNo() != null) {
            _hashCode += getFaxNo().hashCode();
        }
        if (getFemaleYn() != null) {
            _hashCode += getFemaleYn().hashCode();
        }
        if (getGroupwareYn() != null) {
            _hashCode += getGroupwareYn().hashCode();
        }
        if (getHrYn() != null) {
            _hashCode += getHrYn().hashCode();
        }
        if (getIpPhoneNo() != null) {
            _hashCode += getIpPhoneNo().hashCode();
        }
        if (getJobClassId() != null) {
            _hashCode += getJobClassId().hashCode();
        }
        if (getJobClassName() != null) {
            _hashCode += getJobClassName().hashCode();
        }
        if (getJobClassNameEn() != null) {
            _hashCode += getJobClassNameEn().hashCode();
        }
        _hashCode += getJobClassOrder();
        if (getJobDutyId() != null) {
            _hashCode += getJobDutyId().hashCode();
        }
        if (getJobDutyName() != null) {
            _hashCode += getJobDutyName().hashCode();
        }
        if (getJobFunctionId() != null) {
            _hashCode += getJobFunctionId().hashCode();
        }
        if (getJobFunctionName() != null) {
            _hashCode += getJobFunctionName().hashCode();
        }
        _hashCode += getJobFunctionOrder();
        if (getJobPositionId() != null) {
            _hashCode += getJobPositionId().hashCode();
        }
        if (getJobPositionName() != null) {
            _hashCode += getJobPositionName().hashCode();
        }
        if (getJobPositionNameEn() != null) {
            _hashCode += getJobPositionNameEn().hashCode();
        }
        _hashCode += getJobPositionOrder();
        if (getJoinDate() != null) {
            _hashCode += getJoinDate().hashCode();
        }
        if (getLanguage() != null) {
            _hashCode += getLanguage().hashCode();
        }
        if (getLastLoginDate() != null) {
            _hashCode += getLastLoginDate().hashCode();
        }
        if (getMsnYn() != null) {
            _hashCode += getMsnYn().hashCode();
        }
        if (getOfficePhoneNo() != null) {
            _hashCode += getOfficePhoneNo().hashCode();
        }
        if (getOutsideYn() != null) {
            _hashCode += getOutsideYn().hashCode();
        }
        if (getPasswordExpireDate() != null) {
            _hashCode += getPasswordExpireDate().hashCode();
        }
        if (getPhotoPath() != null) {
            _hashCode += getPhotoPath().hashCode();
        }
        _hashCode += getSecurityLevel();
        if (getUserExpireDate() != null) {
            _hashCode += getUserExpireDate().hashCode();
        }
        if (getUserId() != null) {
            _hashCode += getUserId().hashCode();
        }
        if (getUserKey() != null) {
            _hashCode += getUserKey().hashCode();
        }
        if (getUserName() != null) {
            _hashCode += getUserName().hashCode();
        }
        if (getUserNameEn() != null) {
            _hashCode += getUserNameEn().hashCode();
        }
        if (getVisibleYn() != null) {
            _hashCode += getVisibleYn().hashCode();
        }
        if (getWebYn() != null) {
            _hashCode += getWebYn().hashCode();
        }
        if (getWorkPlace() != null) {
            _hashCode += getWorkPlace().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(OrgDeptUserVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "orgDeptUserVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("activeYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "activeYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cellKind");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "cellKind"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cellPhoneNo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "cellPhoneNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("chargeWork");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "chargeWork"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("companyId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "companyId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("companyName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "companyName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("companyNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "companyNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("defaultDeptYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "defaultDeptYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deptCode");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "deptCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deptFullPath");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "deptFullPath"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deptId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "deptId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deptName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "deptName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deptNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "deptNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("email");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "email"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("employeeNo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "employeeNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("englishName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "englishName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("faxNo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "faxNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("femaleYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "femaleYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("groupwareYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "groupwareYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("hrYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "hrYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ipPhoneNo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "ipPhoneNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobClassId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobClassId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobClassName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobClassName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobClassNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobClassNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobClassOrder");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobClassOrder"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobDutyId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobDutyId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobDutyName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobDutyName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobFunctionId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobFunctionId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobFunctionName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobFunctionName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobFunctionOrder");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobFunctionOrder"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobPositionId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobPositionId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobPositionName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobPositionName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobPositionNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobPositionNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("jobPositionOrder");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "jobPositionOrder"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("joinDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "joinDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("language");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "language"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("lastLoginDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "lastLoginDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("msnYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "msnYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("officePhoneNo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "officePhoneNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("outsideYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "outsideYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("passwordExpireDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "passwordExpireDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("photoPath");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "photoPath"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("securityLevel");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "securityLevel"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userExpireDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "userExpireDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "userId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "userKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "userName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "userNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("visibleYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "visibleYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("webYn");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "webYn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("workPlace");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vo.org.ss.branch.neo.hanwha", "workPlace"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
