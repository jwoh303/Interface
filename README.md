# 로컬 인터페이스 프로젝트 (Local IF Projects)

이 디렉터리는 원본 인터페이스 저장소(`D:\project\if\workspace\if`)에서 핵심 7개 프로젝트를 복사하여 로컬 분석 및 수정을 위해 구성된 환경입니다.

---

## 1. 프로젝트 목록 및 개요

| 프로젝트명 | 유형 / 스택 | 설명 |
|---|---|---|
| **[IfRestApi](file:///D:/project/if_local/IfRestApi)** | Spring MVC REST API (Maven) | 내부/외부 연동을 위한 RESTful 웹 서비스 API 모듈 |
| **[SFTPClient](file:///D:/project/if_local/SFTPClient)** | Java Standalone / SFTP & AWS S3 | SFTP 기반 파일 송수신 및 AWS S3 클라우드 연계 클라이언트 |
| **[BatchClient](file:///D:/project/if_local/BatchClient)** | Java Standalone / SAP JCo / AS400 | SAP ERP(JCo3), AS400(JT400), DB 연계 정기 배치 실행기 |
| **[wsCustomer](file:///D:/project/if_local/wsCustomer)** | SOAP WebService Client (Axis/JAX-RPC) | 고객사 SAP PI/PO 연계 웹서비스 컨슈머 (동화, Fiber, K2PKBB 등) |
| **[uCUBE](file:///D:/project/if_local/uCUBE)** | EAI / Middleware Engine (JBoss) | uCUBE EAI 엔진 기반 DB/File 어댑터 및 변환 규칙 실행 환경 |
| **[FileClient](file:///D:/project/if_local/FileClient)** | Java Standalone / File I/F | 구매사/고객사 파일 기반 인터페이스(CNDI PO/GR/IV 등) 송수신 모듈 |
| **[SoapAxisServer](file:///D:/project/if_local/SoapAxisServer)** | SOAP WebService Provider (Apache Axis) | 외부에서 호출하는 SOAP 웹서비스 제공 서버 모듈 |
| **[MRO](file:///D:/project/if_local/MRO)** | Spring MVC Web / Security (Maven) | MRO 메인 코어 웹 애플리케이션 모듈 (`D:\project\MRO_PJT\workspace\MRO_PJT\MRO`) |

---

## 2. 형상 관리 (Git) 정책

- **Git 저장소 경로**: `D:\project\if_local`
- **대용량 파일 제외**: 100MB를 초과하는 빌드 산출물 jar 및 war 파일은 `.gitignore`에 등록되어 로컬 디스크에는 보존되나 Git 트래킹 대상에서는 제외되었습니다.
  - `BatchClient/Client/BatchClient.jar` (456MB)
  - `BatchClient/lib/aws-java-sdk-1.11.893-javadoc.jar` (221MB)
  - `BatchClient/lib/aws-java-sdk-1.11.893.jar` (174MB)
  - `SFTPClient/bin_sftp/SFTPClient.jar` (414MB)
  - `SFTPClient/lib/aws-java-sdk-1.11.892-javadoc.jar` (221MB)
  - `SFTPClient/lib/aws-java-sdk-1.11.892.jar` (174MB)
  - `MRO/src/main/webapp/WEB-INF/lib/aws-java-sdk-1.11.893-javadoc.jar` (221MB)
  - `MRO/src/main/webapp/WEB-INF/lib/aws-java-sdk-1.11.893.jar` (174MB)
  - `*.war`
