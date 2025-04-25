#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if(argc != 1){
        printf("argument error\n");
        exit(1);
    }
    int p[2];
    char buf[5];
    pipe(p);
    int pid  = fork();
    if(pid == 0){
        //子进程
        if(read(p[0], buf, 4)){
            printf("%d: received %s\r\n", getpid(), buf);
            write(p[1], "pong", 4);
            close(p[1]);
            close(p[0]);
        }
    }
    else{
        //父进程
        write(p[1], "ping", 4);
        close(p[1]);
        wait(0);
        if(read(p[0], buf, 4)){
            printf("%d: received pong\r\n", getpid(), buf);
            close(p[0]);
        }
    }
    exit(0);
}
