/*********************************************************************/
/*Copyright(c) 2005 POSDATA                                          */
/*@File           : jmsjni.h                                         */
/*@FileName       : JNI Wrapper header for CtoJAVA                   */
/*Open Issues     :                                                  */
/*Change history                                                     */
/*@LastModifyDate : 20050904                                         */
/*@LastModifier   : Shin Joo Youn                                    */
/*@LastVersion    : 2.0                                              */
/*2007-04-25        Shin Joo Youn                                    */
/*1.0                                                                */ 
/*2.0 POSCO 지원을 위한 수신 thread 추가                             */ 
/*********************************************************************/
#include <jni.h>
/*
_IMPLICITDLL_ :: implicit dll을 생성 (C에서 사용)
_VB_ :: vb wrapper 생성*/

#define ADAPTER_VERSION "1.1.2 [20070425]"

#ifndef _VB_
#ifdef __cplusplus
extern "C" {
#endif
#endif

#ifdef _DEBUG_
void setSleep(int);
#endif

#ifdef _WIN32_
#include <WINDOWS.h>
#include <process.h>
#elif (defined (_SOLARIS_) || defined (_DIGITALUNIX_) ) && !defined (_MI_RT_) 
#include <pthread.h>
#else 
#endif

#ifdef _IMPLICITDLL_
#    ifdef _INDLL_
#        define DEFINE_DLL __declspec(dllexport)
#    else
#        define DEFINE_DLL __declspec(dllimport)
#    endif
DEFINE_DLL int initialize(char *) ;
DEFINE_DLL int sendTC(char *, char *, int);
DEFINE_DLL int sendFile(char *, char *, char *);
DEFINE_DLL void receiveData(char**, char**, int*, long);
DEFINE_DLL void HandleReturnValue(int, char *, char *);
DEFINE_DLL void onClose();
#elif defined _VB_
int __stdcall CALLBACK initialize(char *) ;
int __stdcall CALLBACK sendTC(char *, char *, int);
int __stdcall CALLBACK sendFile(char *, char *, char *);
void __stdcall CALLBACK receiveData(char **, char **, int*, long);
void __stdcall CALLBACK HandleReturnValue(int, char *, char *);
void __stdcall CALLBACK onClose();
#else
int initialize(char *) ;
int sendTC(char *, char *, int);
int sendFile(char *, char *, char *);
void receiveData(char **, char **, int *, long);
void HandleReturnValue(int, char *, char *);
void onClose();
int handleData(char *data, char *ifd, int ret);
#endif

int isInit();
void createVM();
void createObject();
int getMethodID();
int returnValue(int);
void detachVM();

#ifdef _WIN32_
#ifdef _WIN64_
    uintptr_t recv_thread;
#else
    unsigned long recv_thread;
#endif
#endif
#ifdef _SOLARIS_
	int recv_thread;
	pthread_t pt_recv;
#endif

int RSC_lock(
#ifdef _WIN32_
	CRITICAL_SECTION *	
#elif defined (_SOLARIS_) || defined (_DIGITALUNIX_)
	pthread_mutex_t *	
#else 
	int					
#endif
	lock);

int RSC_unlock(
#ifdef _WIN32_
	CRITICAL_SECTION *	
#elif defined (_SOLARIS_) || defined (_DIGITALUNIX_)
	pthread_mutex_t *	
#else 
	int					
#endif
	lock);

#if defined (_DIGITALUNIX_) 
#if defined  (_VMS72_)
#define  PTH_MUT_ATTR_DEF NULL
#define  PTH_CON_ATTR_DEF NULL
#else
#define  PTH_MUT_ATTR_DEF pthread_mutexattr_default
#define  PTH_CON_ATTR_DEF pthread_condattr_default
#endif
#elif defined (_UNIX_3_2_)
#define  PTH_MUT_ATTR_DEF pthread_mutexattr_default
#define  PTH_CON_ATTR_DEF pthread_condattr_default
#elif defined (_SOLARIS_) 
#define  PTH_MUT_ATTR_DEF NULL
#define  PTH_CON_ATTR_DEF NULL
#endif

void start_recv();
void start_recv_thread();

#ifdef _ATTACH_
JNIEnv * attachVM(JNIEnv *);
void detachVM();
#endif

/*#define JMS_PATH             "-Djava.class.path=C:\\EAI\\zpss\\dep\\adapter\\lib\\log4j.jar;C:\\EAI\\zpss\\dep\\adapter\\lib\\seadapter.jar;C:\\EAI\\jms\\lib\\jbossall-client.jar;"*/

#define JMS_REF_CLASS        "com/posdata/eai/adapter/JNIHandler"

#define JMS_INIT             "jInit"
#define JMS_INIT_ARG         "(Ljava/lang/String;)I"

#define JMS_SENDTC           "jSendTC"
#define JMS_SENDTC_ARG       "(Ljava/lang/String;[BI)I"

#define JMS_SENDFILE           "jSendFile"
#define JMS_SENDFILE_ARG       "(Ljava/lang/String;[B[B)I"
                     
#define JMS_RECEIVE          "jReceive"
#define JMS_RECEIVE_ARG      "(J)I"

#define JMS_GETRCVDATA        "getReceiveData"
#define JMS_GETRCVDATA_ARG    "()[B"

#define JMS_GETRCVIFD      "getReceiveIFD"
#define JMS_GETRCVIFD_ARG  "()[B"

#define JMS_GETRCVSTATUS      "getReceiveStatus"
#define JMS_GETRCVSTATUS_ARG  "()I"

#define JMS_COMMIT     "jCommit"
#define JMS_COMMIT_ARG  "()V"

#define JMS_ROLLBACK      "jRollback"
#define JMS_ROLLBACK_ARG  "()V"

#define JMS_ONCLOSE    "jOnClose"
#define JMS_ONCLOSE_ARG   "()V"

#ifdef _ATTACH_
#define JMS_RELOADCLASS     "reLoadClass"
#define JMS_RELOADCLASS_ARG  "()V"
#endif

#define EAI_CALL_ERROR      -8

#ifdef _DEBUG_
#define JMS_JAVASLEEP      "javasleep"
#define JMS_JAVASLEEP_ARG  "(I)V"
#endif

#ifndef _VB_
#ifdef __cplusplus
}
#endif
#endif