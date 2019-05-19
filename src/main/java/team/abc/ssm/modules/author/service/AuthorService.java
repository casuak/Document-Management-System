package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.entity.Author;
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

    public int getAuthorListCount(Author author) {
        return authorMapper.getAuthorCount(author);
    }

    /**
     * @author zm 条件查询返回相应的author，若空则返回空的arrayList
     * @date 2019/4/22
     * @param author
     * @return java.util.List<team.abc.ssm.modules.author.entity.Author>
     */
    public List<Author> getAuthorList(Author author) {
        List<Author> authors = authorMapper.getAuthorListByPage(author);

        if(authors.size() == 0)
            return new ArrayList<>();
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
