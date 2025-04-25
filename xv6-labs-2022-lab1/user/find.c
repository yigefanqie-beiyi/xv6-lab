#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char* dir, char* filename){
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
    //打开当前目录
    if((fd = open(dir, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", dir);
        return;
    }
    //获取当前的绝对路径
    strcpy(buf, dir);
    p = buf + strlen(buf);
    *p++ = '/';
    //循环读取当前目录文件的一个目录项
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0) continue;
        if(!strcmp(de.name, ".") || !strcmp(de.name, "..")) continue;
        //获取当前目录项对应文件的绝对路径，存在buf中，每个循环都会覆盖，因为大小被限定为了DIRSIZ
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;
        //获取当前目录项的文件状态
        if(stat(buf, &st) < 0){
            printf("find: cannot stat %s\n", buf);
            continue;
        }
        //判断是否是目标文件
        if(st.type == 2 && !strcmp(de.name, filename)){
            printf("%s\n", buf);
        }
        //判断是否是目录
        if(st.type == 1){
            find(buf, filename);
        }
    }
    close(fd);
}

int main(int argc, char *argv[])
{
  if(argc != 3){
    exit(0);
  }
  find(argv[1], argv[2]);
  exit(0);
}
