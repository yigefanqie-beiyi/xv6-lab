#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include "user/user.h"

//这个函数的作用是把buf里的字符串按照空格分隔成子字符串并存到argv里
void dividestring(char *buf, char **argv) {
    char *p = buf;  // 指向 buf 的当前字符
    int argc = 0;   // 记录参数个数
    while (*p != '\n' && *p != '\0') {  // 遍历直到换行符或字符串结束
        // 如果不是空格，记录子字符串的起始地址
        if (*p != '\n' && *p != '\0') {
            argv[argc++] = p;  // 保存当前子字符串的起始地址
        }
        // 移动到下一个空格或换行符
        while (*p != ' ' && *p != '\n' && *p != '\0') p++;
        // 将空格或换行符替换为 '\0'，标记子字符串结束
        if (*p == ' ' || *p == '\n') {
            *p = '\0';
            p++;
        }
    }
    // 最后一个参数设置为 NULL
    argv[argc] = 0;
}

int main(int argc, char *argv[])
{
    // 打开标准输入，此时输入其实是管道符的输出
    char buf[100];
    char* p = buf;
    char ch;
    //循环每次读取一个字节
    while(read(0, &ch, 1) != 0){
        //遇到换行
        if(ch == '\n'){
            *p++ = ch;
            int pid = fork();
            if(pid == 0){
                //子进程
                //构造参数列表
                char* newargv[MAXARG];
                for(int i = 1; i < argc; i++){
                    newargv[i - 1] = argv[i];
                }
                dividestring(buf, &newargv[argc - 1]);
                exec(newargv[0], newargv);
                exit(0);
            }
            else{
                //父进程
                wait(0);
                memset(buf, 0, 100 * sizeof(char));
                p = buf;
            }
        }
        //还没遇到换行
        else{
            *p++ = ch;
        }
    }
    exit(0);
}
