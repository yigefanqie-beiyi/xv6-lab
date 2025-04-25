#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

//ɸѡ���̲���ӡ
void sieve(int p[2]){
    int nextp[2];
    pipe(nextp);
    int primenum;
    //�ȹر���߹ܵ���д�ˣ�������ȡ��߹ܵ������ݵ���βʱ���Ų���һֱ����
    close(p[1]);
    //�ݹ��������������߹ܵ�û����ʱ��˵���������ݴ������ˣ���ײ���ӽ��̿�ʼexit
    if(read(p[0], &primenum, sizeof(primenum)) == 0){
        return;
    }
    printf("prime %d\n", primenum);
    //�������ݣ��Ƚ���߹ܵ�������һ��һ���������������һ��һ��д���ұ߹ܵ�
    int num;
    while(read(p[0], &num, sizeof(num)) > 0){
        if(num % primenum != 0){
            write(nextp[1], &num, sizeof(num));
        }
    }
    //д�����߹ܵ��Ͳ����ٱ��õ��ˣ����Ҫ�ǵùر���߹ܵ���������
    close(p[0]);
    //�����ӽ���
    int pid = fork();
    if(pid == 0){
        //�ӽ��̵ݹ�
        sieve(nextp);
    }
    else{
        //������Ҫ���ý�����ʣ���pipe���������ر�
        close(nextp[0]);
        close(nextp[1]);
        //ͨ��wait��֤ͬ��
        wait(0);
    }
    exit(0);
}

int main(int argc, char *argv[])
{
    //��Ϊ���ɽ��̣�������ȫ��д���һ���ܵ�
    int p[2];
    pipe(p);
    for(int i = 2; i <= 35; i++){
        write(p[1], &i, sizeof(i));
    }
    int pid = fork();
    if(pid == 0){
        //�ӽ���,����
        sieve(p);
    }
    else{
        //������
        close(p[1]);
        close(p[0]);
        wait(0);
    }
    close(p[0]);
    close(p[1]);
    exit(0);
}
