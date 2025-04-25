#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

//筛选进程并打印
void sieve(int p[2]){
    int nextp[2];
    pipe(nextp);
    int primenum;
    //先关闭左边管道的写端，这样读取左边管道的数据到结尾时，才不会一直阻塞
    close(p[1]);
    //递归结束条件，当左边管道没数据时，说明所有数据处理完了，最底层的子进程开始exit
    if(read(p[0], &primenum, sizeof(primenum)) == 0){
        return;
    }
    printf("prime %d\n", primenum);
    //处理数据，先将左边管道的数据一个一个读出来，处理后一个一个写到右边管道
    int num;
    while(read(p[0], &num, sizeof(num)) > 0){
        if(num % primenum != 0){
            write(nextp[1], &num, sizeof(num));
        }
    }
    //写完后，左边管道就不会再被用到了，因此要记得关闭左边管道的描述符
    close(p[0]);
    //创建子进程
    int pid = fork();
    if(pid == 0){
        //子进程递归
        sieve(nextp);
    }
    else{
        //父进程要将该进程下剩余的pipe的描述符关闭
        close(nextp[0]);
        close(nextp[1]);
        //通过wait保证同步
        wait(0);
    }
    exit(0);
}

int main(int argc, char *argv[])
{
    //作为生成进程，将数据全部写入第一个管道
    int p[2];
    pipe(p);
    for(int i = 2; i <= 35; i++){
        write(p[1], &i, sizeof(i));
    }
    int pid = fork();
    if(pid == 0){
        //子进程,迭代
        sieve(p);
    }
    else{
        //父进程
        close(p[1]);
        close(p[0]);
        wait(0);
    }
    close(p[0]);
    close(p[1]);
    exit(0);
}
