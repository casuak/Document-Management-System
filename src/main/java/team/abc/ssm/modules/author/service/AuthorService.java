package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.web.SysDocType;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.dao.PaperDao;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.entity.User;

import java.util.*;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class AuthorService {

    @Autowired
    private AuthorMapper authorMapper;

    @Autowired
    private PaperDao paperDao;

    @Autowired
    private DocPatentMapper docPatentMapper;

    public int getAuthorListCount(Author author) {
        return authorMapper.getAuthorCount(author);
    }

    /**
     * @author zm 条件查询返回相应的author，若空则返回空的arrayList
     * @date 2019/4/22
     * @param author
     * @return java.util.List<team.abc.ssm.modules.author.entity.Author>
     * @Description //统计每个作者的论文+专利数量
     *  1. 导师一作，二作不为该导师的学生，计算在导师名下
     *  2. 导师一作，二作是该导师学生，属于导师和学生
     *  3. 学生一作，计算在其导师和该学生名下
     */
    public List<Author> getAuthorList(Author author) {
        /*查找出所有条件下的作者列表*/
        List<Author> authors = authorMapper.getAuthorListByPage(author);
        
        /*统计每个作者的论文+专利数*/
        for (Author tmpAuthor:authors) {
            if ("student".equals(tmpAuthor.getUserType())){
                //学生统计
                //1.学生是一作
                //2.学生是二作，且第一作者是该学生老师
                tmpAuthor.setPaperAmount(paperDao.selectStudentPaper(tmpAuthor));
                tmpAuthor.setPatentAmount(docPatentMapper.selectStudentPatent(tmpAuthor));
            } else if ("teacher".equals(tmpAuthor.getUserType())) {
                //教师统计
                //1.需要教师是一作
                //2.一作是该导师的学生
                tmpAuthor.setPaperAmount(paperDao.selectTeacherPaper(tmpAuthor));
                tmpAuthor.setPatentAmount(docPatentMapper.selectTeacherPatent(tmpAuthor));
            }else{
                //其他角色，暂不统计
            }
        }
        if(authors.size() == 0){
            return new ArrayList<>();
        }
        return authors;
    }

    public List<String> getSubList() {
        return authorMapper.getFirstSub();
    }

    public Author getAuthor(String authorId) {
        System.out.println("获取author");
        return authorMapper.selectByPrimaryKey(authorId);
    }

    /**
     * @param
     * @return void
     * @Description 批量插入字典项
     * @author zm
     * @date 9:13 2019/5/9
     */
    public void batchInsertDict(){
        List<Dict> dictList = new ArrayList<>();

        List<String> firstSubList = authorMapper.getFirstSub();

        for (String firstSub : firstSubList){
            Dict tmpDict = new Dict();
            tmpDict.setTypeId(String.valueOf(UUID.randomUUID()));

            tmpDict.setNameCn(firstSub);

            dictList.add(tmpDict);
        }

        System.out.println("打印dicList: "+dictList);

        int resInsert = authorMapper.batchInsert(dictList);
        System.out.println("一级学科插入项："+resInsert);
    }
}