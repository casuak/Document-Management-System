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
     * @author zm 条件查询返回相应的List<Author>，若空则返回空的arrayList
     * @date 2019/4/22
     * @param author
     * @return java.util.List<team.abc.ssm.modules.author.entity.Author>
     * @Description
     * version1：20190422
     * 统计每个作者的论文+专利数量
     *      1.1 导师一作，二作不为该导师的学生，计算在导师名下
     *      1.2 导师一作，二作是该导师学生，属于导师和学生
     *      1.3 学生一作，计算在其导师和该学生名下
     *
     * version2: 20190804
     * 取消单个作者的论文+专利数量统计
     */
    public List<Author> getAuthorList(Author author) {
        /*查找出所有条件下的作者列表*/
        List<Author> authors = authorMapper.getAuthorListByPage(author);
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