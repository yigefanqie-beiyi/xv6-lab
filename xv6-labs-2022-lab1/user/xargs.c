#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include "user/user.h"

//��������������ǰ�buf����ַ������տո�ָ������ַ������浽argv��
void dividestring(char *buf, char **argv) {
    char *p = buf;  // ָ�� buf �ĵ�ǰ�ַ�
    int argc = 0;   // ��¼��������
    while (*p != '\n' && *p != '\0') {  // ����ֱ�����з����ַ�������
        // ������ǿո񣬼�¼���ַ�������ʼ��ַ
        if (*p != '\n' && *p != '\0') {
            argv[argc++] = p;  // ���浱ǰ���ַ�������ʼ��ַ
        }
        // �ƶ�����һ���ո���з�
        while (*p != ' ' && *p != '\n' && *p != '\0') p++;
        // ���ո���з��滻Ϊ '\0'��������ַ�������
        if (*p == ' ' || *p == '\n') {
            *p = '\0';
            p++;
        }
    }
    // ���һ����������Ϊ NULL
    argv[argc] = 0;
}

int main(int argc, char *argv[])
{
    // �򿪱�׼���룬��ʱ������ʵ�ǹܵ��������
    char buf[100];
    char* p = buf;
    char ch;
    //ѭ��ÿ�ζ�ȡһ���ֽ�
    while(read(0, &ch, 1) != 0){
        //��������
        if(ch == '\n'){
            *p++ = ch;
            int pid = fork();
            if(pid == 0){
                //�ӽ���
                //��������б�
                char* newargv[MAXARG];
                for(int i = 1; i < argc; i++){
                    newargv[i - 1] = argv[i];
                }
                dividestring(buf, &newargv[argc - 1]);
                exec(newargv[0], newargv);
                exit(0);
            }
            else{
                //������
                wait(0);
                memset(buf, 0, 100 * sizeof(char));
                p = buf;
            }
        }
        //��û��������
        else{
            *p++ = ch;
        }
    }
    exit(0);
}
