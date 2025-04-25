#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char* dir, char* filename){
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
    //�򿪵�ǰĿ¼
    if((fd = open(dir, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", dir);
        return;
    }
    //��ȡ��ǰ�ľ���·��
    strcpy(buf, dir);
    p = buf + strlen(buf);
    *p++ = '/';
    //ѭ����ȡ��ǰĿ¼�ļ���һ��Ŀ¼��
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0) continue;
        if(!strcmp(de.name, ".") || !strcmp(de.name, "..")) continue;
        //��ȡ��ǰĿ¼���Ӧ�ļ��ľ���·��������buf�У�ÿ��ѭ�����Ḳ�ǣ���Ϊ��С���޶�Ϊ��DIRSIZ
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;
        //��ȡ��ǰĿ¼����ļ�״̬
        if(stat(buf, &st) < 0){
            printf("find: cannot stat %s\n", buf);
            continue;
        }
        //�ж��Ƿ���Ŀ���ļ�
        if(st.type == 2 && !strcmp(de.name, filename)){
            printf("%s\n", buf);
        }
        //�ж��Ƿ���Ŀ¼
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
