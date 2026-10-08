/*********************************************************************/
/*Copyright(c) 2006 POSDATA                                          */
/*@File           : Sock.h                                           */
/*@FileName       : Sock Client Header Source                        */
/*Open Issues     :                                                  */
/*Change history                                                     */
/*@LastModifyDate : 20060609                                         */
/*@LastModifier   : Shin Joo Youn                                    */
/*@LastVersion    : 1.0                                              */
/*2006-06-09        Shin Joo Youn                                    */
/*1.0                                                                */
/*********************************************************************/
#ifdef _WIN32_
#define FILE_SEP "\\"
#include <winsock2.h>
#elif  defined (_SOLARIS_) && !defined (_DIGITALUNIX_)
#define FILE_SEP "/"
#elif  defined (_DIGITALUNIX_)
#define FILE_SEP "\0"
#endif

#define SOCK_SUCCESS     0
#define Sock_FAIL       -1

struct sockMessage {
    long size;
    char *sendtime;
    char *systemID;
    char *log_info;
    char *data;
} msg;

struct MsgProperty {

    char *sourceType;
    char *targetType;
    char *srcPC;
    char *ifid;
    char *usesrcFilename;
    char *dataType;
    char *dataLength;
    char *timestamp;
    char *seqTime;
    char *seqNo;
    char *encriptFlag;
    char *queueName;

};

typedef struct MsgProperty * msgProp;

#ifdef EXTERN_REQUIRED
extern "C" {
#endif

#ifdef _VB_
#define STDCALL __stdcall
#else
#define STDCALL
#endif

int STDCALL initialize(char *);
void STDCALL recvData(char **, char **, int *, long);
void STDCALL HandleReturnValue(int, char *, char *);
int STDCALL sendFile(char *, char *, char *);
int STDCALL sendTC(char *, char *, long);
void STDCALL onClose();
int STDCALL handleData(char *, char *, int);

#ifdef EXTERN_REQUIRED
}
#endif

